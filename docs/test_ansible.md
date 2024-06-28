## Ansible testing

## Prerequisite
* Docker 

if you are using remote docker ,make sure the following environment variable is set 
```
export DOCKER_HOST=ssh://ubuntu@192.168.0.30
```

### Dependencies
* molecule
* pytest-testinfra

### creating new molecule scenario
```
cd to_project_directory
molecule init scenario
```
### Test 
```
molecule test
```