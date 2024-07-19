package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"homelab/k8s/cluster_apps/platform/tests/utils/commonutil"
	"homelab/k8s/cluster_apps/platform/tests/utils/integration/kindutil"
	"io/ioutil"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	// "sync"
	"testing"
	"time"
)

var testOptions = []TestOptions{
	{
		HelmChartPath:       "../../../ingress-traefik",
		Namespace:           "traefik",
		ExpectedPodCount:    1,
		ExpectedServiceName: "test-release-traefik",
	},
	{
		HelmChartPath: "../../../grafana",
		Namespace:     "grafana",
		OverrideHelmValues: map[string]string{
			"grafana.testFramework.enabled": "false",
		},
		ExpectedPodCount:    1,
		ExpectedServiceName: "test-release-grafana",
	},
}

func TestMinikubeIntegration(t *testing.T) {

	//create temp directory "/tmp/integrationtest"
	tempDir, err := commonutil.CreateTempDir("integrationtest")
	require.NoError(t, err)
	originalKubeconfig := os.Getenv("KUBECONFIG")

	kindCfg := kindutil.Config{
		ClusterName:       "test-cluster",
		KubernetesVersion: "v1.28.7",
		KubeConfigPath:    tempDir + "/kind-kubeconfig",
		KindConfigFile:    tempDir + "/kind-config.yaml",
		KindDockerIp:      commonutil.GetDockerIp(),
	}

	defer postTestTeardown(t, kindCfg, tempDir, originalKubeconfig)

	preTestSetup(t, kindCfg)
	for _, options := range testOptions {
		runHelmChartTest(t, kindCfg, options)
	}
	// var wg sync.WaitGroup // Use a WaitGroup to wait for all goroutines to complete
	// for _, options := range testOptions {
	// 	options := options // Capture range variable
	// 	wg.Add(1)
	// 	go func(options TestOptions) {
	// 		defer wg.Done()
	// 		t.Run(fmt.Sprintf("Testing Helm chart: %s", options.HelmChartPath), func(t *testing.T) {
	// 			t.Parallel()
	// 			runHelmChartTest(t, kindCfg, options)
	// 		})
	// 	}(options)
	// }
	// wg.Wait()
}

func preTestSetup(t *testing.T, kindCfg kindutil.Config) {
	// Start the Kind cluster
	err := kindutil.StartKindCluster(kindCfg)
	require.NoError(t, err, "Failed to start Kind cluster")
	commonutil.SetKubeconfig(kindCfg.KubeConfigPath)
	assert.Equal(t, kindCfg.KubeConfigPath, os.Getenv("KUBECONFIG"), "KUBECONFIG should be set to the custom kubeconfig path")
	kubectlOptions := k8s.NewKubectlOptions("", kindCfg.KubeConfigPath, "")
	k8s.WaitUntilAllNodesReady(t, kubectlOptions, 5, 5*time.Second) //maxRetries=5 & sleepBetweenRetries=5sec
	installPrerequisiteCRDs(t, kubectlOptions)                      // Install Prerequisite CRD's
}

func postTestTeardown(t *testing.T, kindCfg kindutil.Config, tempDir string, originalKubeconfig string) {
	err := kindutil.DeleteKindCluster(kindCfg)
	assert.NoError(t, err, "Failed to stop Kind cluster")
	commonutil.ResetKubeconfig(originalKubeconfig)
	err = commonutil.RemoveTempDir(tempDir)
	assert.NoError(t, err, "failed to remove temporary directory")
}

func runHelmChartTest(t *testing.T, kindCfg kindutil.Config, testOptions TestOptions) {
	//helm test starts
	helmChartPath, err := filepath.Abs(testOptions.HelmChartPath)
	require.NoError(t, err)

	kubectlOptions := k8s.NewKubectlOptions("", kindCfg.KubeConfigPath, testOptions.Namespace)
	k8s.CreateNamespace(t, kubectlOptions, testOptions.Namespace)
	defer k8s.DeleteNamespace(t, kubectlOptions, testOptions.Namespace)

	helmValues := map[string]string{
		"global.external-secrets.enabled": "false",
		"global.test-secrets.enabled":     "true",
	} // override helm values
	helmOptions := &helm.Options{
		KubectlOptions: kubectlOptions,
		SetValues:      commonutil.CombineMaps(helmValues, testOptions.OverrideHelmValues),
		// BuildDependencies: true,
	}
	extraHelmArgs := []string{"--include-crds", "--create-namespace", "--dependency-update"}
	releaseName := "test-release"
	helmOutput := helm.RenderTemplate(t, helmOptions, helmChartPath, releaseName, []string{}, extraHelmArgs...)
	crdManifests, otherManifests := splitCRDsAndOthers(helmOutput)
	if crdManifests != "" {
		k8s.KubectlApplyFromString(t, helmOptions.KubectlOptions, crdManifests) // Apply CRDs first
	}
	if otherManifests != "" {
		k8s.KubectlApplyFromString(t, helmOptions.KubectlOptions, otherManifests) // Apply the remaining resources
	}
	filterOptions := metav1.ListOptions{
		// LabelSelector: fmt.Sprintf("app.kubernetes.io/instance=%s", releaseName+"-"+nameSpace),
	}
	k8s.WaitUntilNumPodsCreated(t, helmOptions.KubectlOptions, filterOptions, 1, 10, 5*time.Second) //desiredCount=1 , retries=10, sleepBetweenRetries=5sec
	pods := k8s.ListPods(t, helmOptions.KubectlOptions, filterOptions)
	assert.Equal(t, 1, len(pods))
	k8s.GetService(t, helmOptions.KubectlOptions, testOptions.ExpectedServiceName)
}

func installPrerequisiteCRDs(t *testing.T, options *k8s.KubectlOptions) {
	crdURLs := []string{
		"https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml",
	}
	for _, url := range crdURLs {
		err := applyCRD(t, options, url)
		if err != nil {
			t.Fatalf("Failed to apply CRD %s: %v", url, err)
		}
	}
}

func applyCRD(t *testing.T, options *k8s.KubectlOptions, url string) error {
	resp, err := http.Get(url)
	if err != nil {
		return fmt.Errorf("failed to download CRD from %s: %v", url, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("failed to download CRD from %s: %s", url, resp.Status)
	}

	crdYaml, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("failed to read CRD from %s: %v", url, err)
	}
	err = k8s.KubectlApplyFromStringE(t, options, string(crdYaml))
	if err != nil {
		return fmt.Errorf("failed to apply CRD: %v", err)
	}
	return nil
}

func splitCRDsAndOthers(manifests string) (string, string) {
	crdManifests := []string{}
	otherManifests := []string{}
	for _, manifest := range strings.Split(manifests, "---") {
		if strings.Contains(manifest, "CustomResourceDefinition") {
			crdManifests = append(crdManifests, manifest)
		} else {
			otherManifests = append(otherManifests, manifest)
		}
	}
	return strings.Join(crdManifests, "---"), strings.Join(otherManifests, "---")
}

type TestOptions struct {
	HelmChartPath       string
	Namespace           string
	OverrideHelmValues  map[string]string
	ExpectedPodCount    int
	ExpectedServiceName string
}
