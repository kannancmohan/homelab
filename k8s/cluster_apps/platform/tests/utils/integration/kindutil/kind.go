package kindutil

import (
	"fmt"
	"os/exec"
	"os"
	"strings"
	"text/template"
)

func GenerateKindConfigFromTemplate(cfg Config) error{
	tmpl, err := template.ParseFiles("kind-config.tmpl.yaml")
    if err != nil {
		return fmt.Errorf("Error parsing template: %v", err)
    }
    outFile, err := os.Create(cfg.KindConfigFile)
    if err != nil {
		return fmt.Errorf("Error creating output file: %v", err)
    }

	if err := tmpl.Execute(outFile, cfg); err != nil {
		return fmt.Errorf("Error executing template: %v", err)
    }
	return nil
}

func StartKindCluster(cfg Config) error {	
	image := fmt.Sprintf("kindest/node:%s", cfg.KubernetesVersion)
	
	exists, err := ClusterExists(cfg.ClusterName)
	if err != nil {
		return fmt.Errorf("Could not find whether Kind Cluster already exists: %v", err)
	}
	if exists {
		fmt.Println("Deleting already existing cluster:", cfg.ClusterName)
		DeleteKindCluster(cfg)
	}

	err = GenerateKindConfigFromTemplate(cfg)
	if err != nil {
		return fmt.Errorf("Could generate KindConfig file from template: %v", err)
	}
	
	fmt.Printf("Starting Kind cluster: %s with Kubernetes version: %s\n", cfg.ClusterName, cfg.KubernetesVersion)
	cmdArgs := []string{"create", "cluster", "--kubeconfig", cfg.KubeConfigPath, "--image", image, "--config", cfg.KindConfigFile}

	cmd := exec.Command("kind", cmdArgs...)
	cmdOutput, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("failed to start Kind cluster: %v, output: %s", err, string(cmdOutput))
	}
	fmt.Println("Kind cluster created..")
	return nil
}

func DeleteKindCluster(cfg Config) error {
	fmt.Printf("Deleting Kind cluster: %s\n", cfg.ClusterName)
	cmdArgs := []string{"delete", "cluster", "--name", cfg.ClusterName}
	cmd := exec.Command("kind", cmdArgs...)
	cmdOutput, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("failed to stop Kind cluster: %v, output: %s", err, string(cmdOutput))
	}
	os.Remove(cfg.KubeConfigPath)
	fmt.Println("Kind cluster deleted successfully")
	return nil
}

func ClusterExists(name string) (bool, error) {
	cmd := exec.Command("kind", "get", "clusters")
	output, err := cmd.CombinedOutput()
	if err != nil {
		return false, fmt.Errorf("failed to get kind clusters: %v, output: %s", err, string(output))
	}

	clusters := strings.Split(strings.TrimSpace(string(output)), "\n")
	for _, cluster := range clusters {
		if cluster == name {
			fmt.Println("Cluster already exists for:", name)
			return true, nil
		}
	}

	return false, nil
}

type Config struct {
    ClusterName      string
    KubernetesVersion string
	KubeConfigPath string
	KindConfigFile string
	KindDockerIp string
}