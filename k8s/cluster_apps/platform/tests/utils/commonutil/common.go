package commonutil

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
)

func GetCurrentDirectory() (string, error) {
	_, filePath, _, ok := runtime.Caller(1)
	if !ok {
		return "", fmt.Errorf("failed to get current file path")
	}
	return filepath.Dir(filePath), nil
}

func CreateTempDir(prefix string) (string, func(), error) {
	tempDirParent := os.TempDir()
	tempDir := filepath.Join(tempDirParent, prefix)

	if _, err := os.Stat(tempDir); os.IsNotExist(err) {
		err := os.Mkdir(tempDir, 0755)
		if err != nil {
			return "", nil, err
		}
	}

	cleanup := func() {
		os.RemoveAll(tempDir)
	}
	return tempDir, cleanup, nil
}

func SetKubeconfig(kubeconfigPath string) {
	os.Setenv("KUBECONFIG", kubeconfigPath)
}

func ResetKubeconfig(originalKubeconfig string) {
	if originalKubeconfig == "" {
		os.Unsetenv("KUBECONFIG")
	} else {
		os.Setenv("KUBECONFIG", originalKubeconfig)
	}
}

func GetEnvAsString(key string) string {
	val, exists := os.LookupEnv(key)
	if !exists {
		return ""
	}
	return val
}

func GetDockerIp() string {
	envVarValue, exists := os.LookupEnv("REMOTE_DOCKER_IP") //this env variable is set in shell.nix
	if exists {
		return envVarValue
	}
	return "127.0.0.1"
}
