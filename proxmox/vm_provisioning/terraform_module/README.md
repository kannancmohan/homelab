## terraform module to create proxmox vm

### Example usage
```
module "my_proxmox_vm" {
  source                           = "../../../proxmox/vm_provisioning/terraform_module"
  count                            = 1
  vm_id                            = "100"
  vm_name                          = "my_proxmox_vm"
  vm_node                          = "<proxmox_node_name>"
  vm_cidr                          = "<your-vm-ip-address>/24"
  vm_gateway_ip                    = "<your-network-gateway>"
  vm_cpu_cores                     = 1
  vm_memory                        = 1024
  vm_disk_file_id                  = <downloaded-os-iso-file-id>
  vm_disk_size                     = 10
}
```