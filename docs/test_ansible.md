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

### Tips
#### To ignore a specific ansible task from molecule test
use one of tags provided by molecule 
* notest
* molecule-notest
* molecule-idempotence-notest

eg:
```
    - name: Restart systemd-resolved service
      ansible.builtin.service:
        name: systemd-resolved
        state: restarted
      tags: molecule-notest
```
#### To login to test instance
```
cd to_project_directory
molecule converge # make sure the instance is created with all ansible tasks executed
molecule login
```

#### To verify 
```
cd to_project_directory
molecule converge # make sure the instance is created with all ansible tasks executed
molecule verify
```