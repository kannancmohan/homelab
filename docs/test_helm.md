# Helm Unit & Integration Test

## Prerequisite
1. Ensure you have Go installed and initialize a new Go module in your project root
Executing the following command will generate go.mod file
```
cd your-project
go mod init your-project
```
2. Edit go.mod to include Terratest dependency and execute "go mod tidy"
Eg:
```
module homelab

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

## Helm Unit test
The idea is to validate the generated helm template against a predefined golden file

Execute the test
```
go test -v ./k8s/tests/unit/...
```

## Helm Integration test

Execute the test
```
go test -v ./k8s/tests/integration/...
```

## Format go test files
```
go fmt ./k8s/tests/...
```


## Terratest test file naming convention
* Name your test files with a _test.go suffix
* Test function names should start with Test followed by the name of the function being tested.

