# node variables
variable "proxmox_node_name" {
  type = string
}
variable "proxmox_node_iso_datastore_id" {
  type = string
}

# project variables
variable "cloud_image_iso_url" {
  type    = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}
variable "proxmox_cloud_image_file_name" {
  type    = string
  default = "jammy-server-cloudimg-amd64-22-04.img"
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
variable "vm_timezone" {
  type        = string
  default     = "Europe/Berlin"
  description = "The timezone for the vm"
}


# worker vm variables
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
variable "vm_cpu_cores" {
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
