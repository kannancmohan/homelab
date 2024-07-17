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
	"testing"
	"time"
)

func TestMinikubeIntegration(t *testing.T) {
	t.Parallel()
	originalKubeconfig := os.Getenv("KUBECONFIG")

	//create temp directory "/tmp/integrationtest"
	tempDir, tempDirCleanup, err := commonutil.CreateTempDir("integrationtest")
	require.NoError(t, err)

	cfg := kindutil.Config{
		ClusterName:       "test-cluster",
		KubernetesVersion: "v1.28.7",
		KubeConfigPath:    tempDir + "/kind-kubeconfig",
		KindConfigFile:    tempDir + "/kind-config.yaml",
		KindDockerIp:      commonutil.GetDockerIp(),
	}

	//cleanup
	defer func() {
		err = kindutil.DeleteKindCluster(cfg)
		assert.NoError(t, err, "Failed to stop Kind cluster")
		commonutil.ResetKubeconfig(originalKubeconfig)
		tempDirCleanup()
	}()

	// Start the Kind cluster
	err = kindutil.StartKindCluster(cfg)
	assert.NoError(t, err, "Failed to start Kind cluster")
	commonutil.SetKubeconfig(cfg.KubeConfigPath)
	assert.Equal(t, cfg.KubeConfigPath, os.Getenv("KUBECONFIG"), "KUBECONFIG should be set to the custom kubeconfig path")

	// Wait until all nodes are ready
	nameSpace := "traefik"
	kubectlOptions := k8s.NewKubectlOptions("", cfg.KubeConfigPath, nameSpace)
	//kubectlOptions.ExtraArgs = []string{"wait", "--for=condition=established"}
	k8s.WaitUntilAllNodesReady(t, kubectlOptions, 5, 5*time.Second) //maxRetries=5 & sleepBetweenRetries=5sec

	//helm test starts
	helmChartPath, err := filepath.Abs("../../../ingress-traefik")

	k8s.CreateNamespace(t, kubectlOptions, nameSpace)
	defer k8s.DeleteNamespace(t, kubectlOptions, nameSpace)

	helmOptValues := map[string]string{"global.external-secrets.enabled": "false", "traefik.deployment.enabled": "true"} // override helm values
	helmOptions := &helm.Options{
		KubectlOptions: kubectlOptions,
		SetValues:      helmOptValues,
		// BuildDependencies: true,
	}

	extraHelmArgs := []string{"--include-crds", "--create-namespace", "--dependency-update"}
	releaseName := "test-release"
	helmOutput := helm.RenderTemplate(t, helmOptions, helmChartPath, releaseName, []string{}, extraHelmArgs...)
	crdManifests, otherManifests := splitCRDsAndOthers(helmOutput)

	installPrerequisiteCRDs(t, kubectlOptions)                                // Install Prerequisite CRD's
	k8s.KubectlApplyFromString(t, helmOptions.KubectlOptions, crdManifests)   // Apply CRDs first
	k8s.KubectlApplyFromString(t, helmOptions.KubectlOptions, otherManifests) // Apply the remaining resources

	//then
	filterOptions := metav1.ListOptions{
		LabelSelector: fmt.Sprintf("app.kubernetes.io/name=%s", nameSpace),
	}
	k8s.WaitUntilNumPodsCreated(t, helmOptions.KubectlOptions, filterOptions, 1, 10, 5*time.Second) //desiredCount=1 , retries=10, sleepBetweenRetries=5sec
	pods := k8s.ListPods(t, helmOptions.KubectlOptions, filterOptions)
	assert.Equal(t, 1, len(pods))

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
