# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "worker-vm" {

  ## VM General Settings
  count       = 1                              # creates this no of vm's
  name        = "worker-vm-${count.index + 1}" #count.index starts at 0, so + 1 means this VM will be named test-vm-1 in proxmox
  desc        = "Worker vm"
  target_node = var.proxmox_node
  #vmid = "100"

  ## VM CPU and Memory Settings
  cores   = var.worker_vm_core_count
  sockets = 1
  cpu     = "host"
  memory  = var.worker_vm_memory

  ## VM OS Settings
  clone   = var.vm_template_name
  agent   = 1
  os_type = "cloud-init" #VM Cloud-Init Settings

  # Basic VM settings - these setting are already done in vm template, so it might no be necessary to define here [TBC]
  #scsihw = var.worker_vm_scsihw # The SCSI controller to emulate
  #bootdisk = var.worker_vm_bootdisk #Enable booting from specified disk

  # VM Advanced General Settings
  onboot = true # start thhis vm after the PVE node starts

  disk {
    size    = var.worker_vm_disk_size
    type    = var.worker_vm_disk_type
    storage = var.worker_vm_disk_storage
    #iothread = 1
    #discard = "on"
  }

  # VM Network Settings
  network {
    bridge = var.worker_vm_network_bridge
    model  = var.worker_vm_network_model
  }

  # Configure the display device
  #vga {
  #type = var.worker_vm_display_device
  #}


  # (Optional) IP Address and Gateway
  # ipconfig0 = "ip=0.0.0.0/0,gw=0.0.0.0"
  # OR
  # ipconfig0 = "ip=dhcp"
  # OR 
  ipconfig0 = "ip=${var.worker_vm_ipconfig_ip_prefix}${count.index + 1}/${var.worker_vm_ipconfig_ip_subnet_mask},gw=${var.worker_vm_ipconfig_gateway_ip}"

  # (Optional) Default User
  # ciuser = "your-username" #Override the default cloud-init user for provisioning.

  # (Optional) Add your local/developmet machines SSH KEY. This way you can access this vm without password
  sshkeys = <<EOF
    ${var.local_machine_ssh_key}
    EOF
}