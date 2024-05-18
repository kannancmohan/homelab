# Module to provision necessary vm's in proxmox 

### Tools Version
| Tools                             | Version       |
| --------------------------------- |:-------------:|
| Proxmox VE                        | 8.2.2         |
| Terraform                         | 1.7.4         |
| Terraform provider 'bpg/proxmox'  | 0.47.0        |
| OS for vm                         | Ubuntu 22.04  |

### Prerequisite
Make sure the following environment variables are set. 
```
export TF_VAR_proxmox_api_endpoint="<your-proxmox-server-api-endpoint>"
export PROXMOX_VE_API_TOKEN="<proxmox-user-token-id>=<proxmox-user-token-secret>"
```

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