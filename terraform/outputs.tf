output "worker_vm_proxmox_id" {
  value       = one(proxmox_vm_qemu.worker-vm[*].vmid)
  description = "VM's proxmox id"
}
output "worker_vm_proxmox_name" {
  value       = one(proxmox_vm_qemu.worker-vm[*].name)
  description = "VM's proxmox name"
}
