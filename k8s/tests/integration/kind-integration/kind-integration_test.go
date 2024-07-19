package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"homelab/k8s/tests/utils/commonutil"
	"homelab/k8s/tests/utils/integration/kindutil"
	"io/ioutil"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

var testOptions = []TestOptions{
	{
		HelmChartPath: "../../../cluster_apps/platform/cert-manager",
		Namespace:     "cert-manager",
		OverrideHelmValues: map[string]string{
			"global.leaderElection.namespace": "cert-manager",
		},
		ExpectedPodCount:    4,
		ExpectedServiceName: "test-release-cert-manager",
	},
	{
		HelmChartPath:       "../../../cluster_apps/platform/ingress-traefik",
		Namespace:           "traefik",
		ExpectedPodCount:    1,
		ExpectedServiceName: "test-release-traefik",
	},
	{
		HelmChartPath: "../../../cluster_apps/platform/grafana",
		Namespace:     "grafana",
		OverrideHelmValues: map[string]string{
			"grafana.testFramework.enabled": "false",
		},
		ExpectedPodCount:    1,
		ExpectedServiceName: "test-release-grafana",
	},
}

func TestKindIntegration(t *testing.T) {

	tempDir, err := commonutil.CreateTempDir("integrationtest") //create temp directory "/tmp/integrationtest"
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
		options := options // Capture range variable
		testName := fmt.Sprintf("Testing Helm chart: %s", options.HelmChartPath)
		t.Run(testName, func(t *testing.T) {
			//t.Parallel()
			runHelmChartTest(t, kindCfg, options)
		})
	}
}

func preTestSetup(t *testing.T, kindCfg kindutil.Config) {
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

func runHelmChartTest(t *testing.T, kindCfg kindutil.Config, testOpts TestOptions) {
	helmChartPath, err := filepath.Abs(testOpts.HelmChartPath)
	require.NoError(t, err)

	kubectlOpts := k8s.NewKubectlOptions("", kindCfg.KubeConfigPath, testOpts.Namespace)
	k8s.CreateNamespace(t, kubectlOpts, testOpts.Namespace)
	defer k8s.DeleteNamespace(t, kubectlOpts, testOpts.Namespace)

	helmValues := map[string]string{
		"global.external-secrets.enabled": "false",
		"global.test-secrets.enabled":     "true",
	} // set helm values
	helmOpts := &helm.Options{
		KubectlOptions: kubectlOpts,
		SetValues:      commonutil.CombineMaps(helmValues, testOpts.OverrideHelmValues),
		// BuildDependencies: true,
	}
	extraHelmArgs := []string{"--include-crds", "--create-namespace", "--dependency-update"}
	releaseName := "test-release"
	helmOutput := helm.RenderTemplate(t, helmOpts, helmChartPath, releaseName, []string{}, extraHelmArgs...)
	crdManifests, otherManifests := splitCRDsAndOthers(helmOutput)
	if crdManifests != "" {
		k8s.KubectlApplyFromString(t, helmOpts.KubectlOptions, crdManifests) // Apply CRDs first
	}
	if otherManifests != "" {
		k8s.KubectlApplyFromString(t, helmOpts.KubectlOptions, otherManifests) // Apply the remaining resources
	}
	filterOptions := metav1.ListOptions{
		// LabelSelector: fmt.Sprintf("app.kubernetes.io/instance=%s", releaseName+"-"+nameSpace),
	}
	if testOpts.ExpectedPodCount > 0 {
		k8s.WaitUntilNumPodsCreated(t, helmOpts.KubectlOptions, filterOptions, testOpts.ExpectedPodCount, 5, 5*time.Second) // retries=5, sleepBetweenRetries=5sec
	}
	if testOpts.ExpectedServiceName != "" {
		k8s.GetService(t, helmOpts.KubectlOptions, testOpts.ExpectedServiceName)
	}
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
