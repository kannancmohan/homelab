# node variables
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
variable "proxmox_api_endpoint" {
  type        = string
  description = "set the value for this variable using environment variable TF_VAR_proxmox_api_endpoint"
}
variable "local_machine_ssh_key" {
  type        = string
  description = "The ssh public key of your local development machine. set the value using environment variable TF_VAR_local_machine_ssh_key"
}
variable "vm_default_user_name" {
  type        = string
  description = "The default use in vm. set the value using environment variable TF_VAR_vm_default_user_name"
}
variable "vm_default_user_pwd" {
  type        = string
  description = "The default use password in vm. set the value using environment variable TF_VAR_vm_default_user_pwd"
}

# vm variables
variable "vm_name" {
  type = string
}
variable "vm_id" {
  type = number
}
variable "vm_ip_addr" {
  type = string
}
variable "vm_gateway_ip" {
  type = string
}
variable "vm_cores" {
  type = number
}
variable "vm_memory" {
  type = number
}
variable "vm_disk_size" {
  type        = number
  description = "Disk size in GB"
}
variable "vm_tags" {
  type = list(any)
}
