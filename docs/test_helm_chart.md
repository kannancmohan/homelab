# Helm Unit & Integration Test

## Prerequisite
1. Ensure you have Go installed and initialize a new Go module in your project root
Executing the following command will generate go.mod file
```
cd /k8s/tests
go mod init homelab_test
```
2. Edit go.mod to include Terratest dependency
Eg:
```
module homelab_test

go 1.21.10

require (
	github.com/gruntwork-io/terratest v0.46.16
	github.com/stretchr/testify v1.9.0
	k8s.io/api v0.28.4
)
```

3. Execute the tidy command:
```
go mod tidy
```
Executing the command will update go.mod and creates go.sum

## To add new apps to test
cd k8s/tests/cluster_apps
For Unit Test: add expected k8s definition file in k8s/tests/cluster_apps/unit/ingress-traefik/golden
For Integration Test: add new entry in testOptions variable in kind-integration_test.go

## Helm Unit test
The idea is to validate the generated helm template against a predefined golden file

Execute the test
```
cd k8s/tests
go test -v ./cluster_apps/unit/...
```

## Helm Integration test (Uses kind cluster for integration test)

Execute the test
```
cd k8s/tests
go test -v ./cluster_apps/integration/...
```

## Format all go test files
```
cd k8s/tests
go fmt ./...
```

## Terratest test file naming convention
* Name your test files with a _test.go suffix
* Test function names should start with Test followed by the name of the function being tested.