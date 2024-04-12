# node variables
variable "proxmox_api_endpoint" {
  type        = string
  description = "set the value for this variable using environment variable TF_VAR_proxmox_api_endpoint"
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
variable "worker_vm_disk_size" {
  type        = number
  description = "Disk size in GB"
}

# proxmox cloud-init 
variable "ubuntu_cloud_init_user_config_file" {
  type    = string
  default = "adguard-ubuntu-cloud-init-user-config.yaml"
}
variable "ubuntu_cloud_init_vendor_config_file" {
  type    = string
  default = "adguard-ubuntu-cloud-init-vendor-config.yaml"
}