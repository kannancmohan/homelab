package minikubeutil

import (
	"fmt"
	"os/exec"
	"testing"
	"time"
)

// StartMinikube starts a Minikube cluster and sets the kubectl context
func StartMinikube(t *testing.T) {

	// Clean up any existing Minikube state
	cmd := exec.Command("minikube", "delete")
	err := cmd.Run()
	if err != nil {
		log.Printf("Failed to delete existing Minikube cluster: %v", err)
	}

	fmt.Printf("Starting Minikube cluster")
	cmd := exec.Command("minikube", "start")
	err := cmd.Run()
	if err != nil {
		t.Fatalf("Failed to start Minikube: %v", err)
	}

	// Wait for Minikube to be fully up and running
	time.Sleep(30 * time.Second)
	fmt.Printf("Started Minikube cluster")

	// Set the kubectl context to minikube
	cmd = exec.Command("kubectl", "config", "use-context", "minikube")
	err = cmd.Run()
	if err != nil {
		t.Fatalf("Failed to set kubectl context: %v", err)
	}
}

// StopMinikube stops a Minikube cluster
func StopMinikube(t *testing.T) {
	fmt.Printf("Stopping Minikube cluster")
	cmd := exec.Command("minikube", "stop")
	err := cmd.Run()
	if err != nil {
		t.Fatalf("Failed to stop Minikube: %v", err)
	}
}
