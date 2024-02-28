# variable's specific to provider
variable "proxmox_server_endpoint" {
  type = string
}

# project variables
variable "cloud_image_iso_url" {
  type = string
}
variable "cloud_image_iso_checksum" {
  type = string
}
variable "proxmox_node_name" {
  type = string
}
variable "proxmox_node_iso_datastore_id" {
  type = string
}
variable "proxmox_node_default_datastore_id" {
  type = string
}
variable "vm_default_user_pwd" {
  type = string
}
variable "local_machine_ssh_key" {
  type        = string
  description = "The ssh public key of your local development machine"
}

# worker vm variables
variable "worker_vm_name" {
  type = string
}
variable "worker_vm_id_prefix" {
  type = number
}
variable "worker_vm_ip_prefix" {
  type = string
}
variable "worker_vm_gateway_ip" {
  type = string
}
variable "worker_vm_ubuntu_user_pwd" {
  type = string
}
variable "worker_vm_cores" {
  type = number
}
variable "worker_vm_memory" {
  type = number
}