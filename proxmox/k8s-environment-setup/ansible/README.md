

### Steps to execute
1. [Optional] Ping to see if all vm hosts are accessible 
```
ansible  all -m ping
```
2. 
```
ansible-playbook -i inventory/hosts k8s-environment-setup.yml
```