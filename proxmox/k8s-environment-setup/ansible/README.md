
### Setup 
1. Install ansible in your local development environment

    eg: for macos
    ```
    brew install ansible
    #verify installation using
    ansible --version
    ```
2. [Optional]Install ansible-lint and yaml lint in your local development environment

    eg: for macos
    ```
    brew install ansible-lint 
    brew install yamllint
    ```
3. Set necessary environment variable for the ansible [proxmox inventory plugin](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_inventory.html)

    eg: 
    ```
    # this is used by the proxmox inventory plugin
    export TOKEN_SECRET="<your-proxmox-user-api-token-value>"
    ```

### Steps to execute
1. [Optional] Ping to see if all vm hosts are accessible 
```
ansible  all -m ping
```
2. 
```
ansible-playbook main-playbook.yml
```

3. Run only a subset of host . In this example we are playbook only for host group 'k8s-worker-hosts'
```
ansible-playbook -l k8s-worker-hosts  main-playbook.yml
```
### [Optional] view inventory details

```
ansible-inventory -i inventories/development/proxmox-inventory.proxmox.yml --list
```
OR
```
ansible-inventory -i inventories/development/proxmox-inventory.proxmox.yml --graph
```

### [Optional] view ansible facts

eg: to view facts for host group 'all'
```
ansible all  -m setup
```

### [Optional] Linting and syntax check

1. yaml lint (need to install yamllint 'brew install yamllint')
    ```
	cd to project directory 
	yamllint .
    ```
2. syntax check
    ```
	ansible-playbook main-playbook.yml --syntax-check
    ```
3. ansible lint (need to install yamllint 'brew install ansible-lint')
    ```
	ansible-lint main-playbook.yml
    ```