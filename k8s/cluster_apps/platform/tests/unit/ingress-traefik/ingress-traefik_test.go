package unit

import (
	"homelab/k8s/cluster_apps/platform/tests/utils/unit"
	"path/filepath"
	// "strings"
	"testing"

	// "github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
)

func TestGoldenDefaultsTemplate(t *testing.T) {
	t.Parallel()

	chartPath, err := filepath.Abs("../../../ingress-traefik")
	require.NoError(t, err)
	// FIXME/TODO: the "inbound-secret" generates a random secret every time thus failing to pass on golden
	//templateNames := []string{"service", "serviceaccount", "deployment", "ingress"}
	templateNames := []string{"traefik-service-monitor"}
	release := "ingress-traefik-test"
	nameSpace := "ingress-traefik-test"

	for _, name := range templateNames {
		suite.Run(t, &unit.TemplateGoldenTest{
			ChartPath:      chartPath,
			Release:        release,
			Namespace:      nameSpace,
			//Namespace:      "camunda-platform-" + strings.ToLower(random.UniqueId()),
			GoldenFileName: name,
			Templates:      []string{"templates/" + name + ".yaml"},
			SetValues: map[string]string{
				"connectors.enabled":                "true",
				"connectors.ingress.enabled":        "true",
				"connectors.serviceAccount.enabled": "true",
			},
			IgnoredLines: []string{
				`\s+.*-secret:\s+.*`,    // secrets are auto-generated and need to be ignored.
				`\s+checksum/.+?:\s+.*`, // ignore configmap checksum.
				`# Source: +.*(\r\n|\r|\n)`, // ignore generated # Source line
			},
		})
	}
}