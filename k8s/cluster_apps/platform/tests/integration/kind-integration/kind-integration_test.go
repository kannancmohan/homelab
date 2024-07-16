package test

import (
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/assert"
	"homelab/k8s/cluster_apps/platform/tests/utils/commonutil"
	"homelab/k8s/cluster_apps/platform/tests/utils/integration/kindutil"
	"os"
	"testing"
	"time"
)

func TestMinikubeIntegration(t *testing.T) {
	t.Parallel()
	originalKubeconfig := os.Getenv("KUBECONFIG")

	//create temp directory "/tmp/integrationtest"
	tempDir, tempDirCleanup, err := commonutil.CreateTempDir("integrationtest")
	if err != nil {
		t.Fatalf("Failed to create temp dir: %v", err)
	}

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
		commonutil.ResetKubeconfig(originalKubeconfig)
		tempDirCleanup()
		assert.NoError(t, err, "Failed to stop Kind cluster")
	}()

	// Start the Kind cluster
	err = kindutil.StartKindCluster(cfg)
	assert.NoError(t, err, "Failed to start Kind cluster")
	commonutil.SetKubeconfig(cfg.KubeConfigPath)
	assert.Equal(t, cfg.KubeConfigPath, os.Getenv("KUBECONFIG"), "KUBECONFIG should be set to the custom kubeconfig path")

	options := k8s.NewKubectlOptions("", cfg.KubeConfigPath, "default")

	// Wait until all nodes are ready
	maxRetries := 5
	sleepBetweenRetries := 5 * time.Second
	k8s.WaitUntilAllNodesReady(t, options, maxRetries, sleepBetweenRetries)

}
