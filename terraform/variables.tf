## variables for proxmox provider
variable "proxmox_api_url" {
  type = string
}


## project variables
variable "local_machine_ssh_key" {
  type        = string
  description = "The ssh public key of your local development machine"
}
variable "proxmox_node" {
  type = string
}
variable "vm_template_name" {
  type = string
}

# Worker node variables
variable "worker_vm_count" {
  type        = number
  description = "No of worker vm's to create"
}
variable "worker_vm_core_count" {
  type = number
}
variable "worker_vm_memory" {
  type = number
}
variable "worker_vm_scsihw" {
  type = string
}
variable "worker_vm_bootdisk" {
  type = string
}
variable "worker_vm_disk_size" {
  type = number
}
variable "worker_vm_disk_storage" {
  type        = string
  description = "The name of the proxmox storage pool on which to store the disk"
}
variable "worker_vm_network_bridge" {
  type = string
}
variable "worker_vm_network_model" {
  type = string
}
variable "worker_vm_ipconfig_ip_prefix" {
  type = string
}
variable "worker_vm_ipconfig_ip_subnet_mask" {
  type = number
}
variable "worker_vm_ipconfig_gateway_ip" {
  type = string
}
variable "worker_vm_display_device" {
  type = string
}
