package commonutil

import (
	"path/filepath"
	"fmt"
	"runtime"
    "os"
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