# Module to provision necessary vm's in proxmox 

### Tools Version
| Tools                             | Version       |
| --------------------------------- |:-------------:|
| Proxmox VE                        | 8.1.4         |
| Terraform                         | 1.7.4         |
| Terraform provider 'bpg/proxmox'  | 0.47.0        |
| OS for vm                         | Ubuntu 22.04  |

### Executing the provisioning 

1. Initialize terraform(one time setup)

CD to proxmox/vm-provisioning and run 'terraform init' command
```
terraform init
```
2. [Optional] Run terraform formatting and validation command

```
terraform fmt && terraform validate
```

3. Run 'terraform plan' and 'terraform apply'command to provision the vm's
```
terraform apply
```