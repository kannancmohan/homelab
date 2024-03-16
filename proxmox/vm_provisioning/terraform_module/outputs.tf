output "vm_info" {
  value = {
      "vm_id" : proxmox_virtual_environment_vm.proxmox_vm.vm_id,
      "name" : proxmox_virtual_environment_vm.proxmox_vm.name,
      #"ip": host.initialization.ip_config.ipv4.address
    }
}