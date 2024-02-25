# variables for proxmox provider
variable "proxmox_api_url" {
  type = string
}


# project variables
variable "local_machine_ssh_key" {
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWmuxBWj5GebJtC5sp4kfUGdodLswXVxj9Vrzauf63B kannanmohanklm@gmail.com"
  description = "The ssh public key of your local development machine"
}
variable "proxmox_node" {
  default = "node1-home-network.io"
}
variable "vm_template_name" {
  default = "ubuntu-jammy-server"
}
variable "worker_vm_core_count" {
  type    = number
  default = 1
}
variable "worker_vm_memory" {
  type    = number
  default = 1024
}
variable "worker_vm_scsihw" {
  default = "virtio-scsi-pci"
}

variable "worker_vm_bootdisk" {
  default = "scsi0"
}

variable "worker_vm_disk_size" {
  default = "10G"
}

variable "worker_vm_disk_type" {
  default = "scsi"
}

variable "worker_vm_disk_storage" {
  default     = "lvlocal-lvmm"
  description = "The name of the proxmox storage pool on which to store the disk"
}

variable "worker_vm_network_bridge" {
  default = "vmbr0"
}

variable "worker_vm_network_model" {
  default = "virtio"
}

variable "worker_vm_ipconfig_ip_prefix" {
  default = "192.168.0.5"
}

variable "worker_vm_ipconfig_ip_subnet_mask" {
  default = "24"
}

variable "worker_vm_ipconfig_gateway_ip" {
  default = "192.168.0.1"
}

variable "worker_vm_display_device" {
  default = "serial0"
}
