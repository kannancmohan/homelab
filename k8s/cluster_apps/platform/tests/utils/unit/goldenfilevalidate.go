package unit

import (
	"flag"
	"io/ioutil"
	"regexp"
	// "fmt"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/suite"
)

var update = flag.Bool("update-golden", false, "update golden test output files")

type TemplateGoldenTest struct {
	suite.Suite
	ChartPath      string
	Release        string
	Namespace      string
	GoldenFileName string
	Templates      []string
	IgnoredLines   []string
	SetValues      map[string]string
	ExtraHelmArgs  []string
}

func (s *TemplateGoldenTest) TestContainerGoldenTestDefaults() {
	options := &helm.Options{
		KubectlOptions: k8s.NewKubectlOptions("", "", s.Namespace),
		SetValues:      s.SetValues,
	}

	output := helm.RenderTemplate(s.T(), options, s.ChartPath, s.Release, s.Templates, s.ExtraHelmArgs...)
	s.IgnoredLines = append(s.IgnoredLines, `\s+helm.sh/chart:\s+.*`)
	bytes := []byte(output)
	for _, ignoredLine := range s.IgnoredLines {
		regex := regexp.MustCompile(ignoredLine)
		bytes = regex.ReplaceAll(bytes, []byte(""))
	}
	output = string(bytes)
	// fmt.Printf("output: %s\n", output)

	goldenFile := "golden/" + s.GoldenFileName + ".golden.yaml"
	if *update {
		err := ioutil.WriteFile(goldenFile, bytes, 0644)
		s.Require().NoError(err, "Golden file was not writable")
	}

	expected, err := ioutil.ReadFile(goldenFile)

	// Test
	s.Require().NoError(err, "Golden file doesn't exist or was not readable")
	s.Require().Equal(string(expected), output)
}
