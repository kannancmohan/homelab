## Ansible testing

## Prerequisite
* Docker 

if you are using remote docker ,make sure the following environment variable is set (in shell.nix)
```
export DOCKER_HOST=ssh://ubuntu@192.168.0.30
```

### Dependencies
* molecule
* pytest-testinfra

### To create new molecule test
```
cd to_project_directory
molecule init scenario # this will create a new molecule folder with 'default' scenario folder
```
### For Testing proxmox container service
eg: for testing proxmox/adguard
```
cd proxmox/adguard
molecule test
```