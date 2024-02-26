output "worker_vm_info" {
  value = [
    for host in proxmox_vm_qemu.worker-vm : {
      "vm-id" : host.vmid,
      "name" : host.name,
      "ip0" : host.ipconfig0,
      "memory" : host.memory,
      "cores" : host.cores,
    }
  ]
}
