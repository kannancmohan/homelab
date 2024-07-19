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

func CreateTempDir(prefix string) (string, error) {
	tempDirParent := os.TempDir()
	tempDir := filepath.Join(tempDirParent, prefix)
	if _, err := os.Stat(tempDir); os.IsNotExist(err) {
		err := os.Mkdir(tempDir, 0755)
		if err != nil {
			return "", err
		}
	}
	return tempDir, nil
}

func RemoveTempDir(tempDir string) error {
	err := os.RemoveAll(tempDir)
	if err != nil {
		return err
	}
	return nil
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

func CombineMaps(m1 map[string]string, m2 map[string]string) map[string]string {
	if len(m2) > 0 {
		for key, value := range m2 {
			m1[key] = value
		}
	}
	return m1
}
