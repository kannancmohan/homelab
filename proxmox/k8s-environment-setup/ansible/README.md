

### Steps to execute
1. [Optional] Ping to see if all vm hosts are accessible 
```
ansible  all -m ping
```
2. 
```
ansible-playbook k8s-environment-setup.yml
```

3. Run only a subset of host . In this example we are playbook only for host group 'k8s-worker-hosts'
```
ansible-playbook -l k8s-worker-hosts  k8s-environment-setup.yml
```
