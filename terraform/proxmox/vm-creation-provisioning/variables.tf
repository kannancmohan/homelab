# node variables
variable "proxmox_server_endpoint" {
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

# project variables
variable "cloud_image_iso_url" {
  type = string
}
variable "cloud_image_iso_checksum" {
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
variable "worker_vm_count" {
  type    = number
  default = 1
}
variable "worker_vm_cores" {
  type = number
}
variable "worker_vm_memory" {
  type = number
}

# controlplane vm variables
variable "cp_vm_name" {
  type = string
}
variable "cp_vm_id_prefix" {
  type = number
}
variable "cp_vm_ip_prefix" {
  type = string
}
variable "cp_vm_gateway_ip" {
  type = string
}
variable "cp_vm_count" {
  type    = number
  default = 1
}
variable "cp_vm_cores" {
  type = number
}
variable "cp_vm_memory" {
  type = number
}