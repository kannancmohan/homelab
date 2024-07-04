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
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}
variable "cloud_image_iso_checksum" {
  type = string
  default = "1d465eadfecffd6dc4e7be02df925519e18df432d846c8001eb8bd3d1124373c"
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
  default = "k3s-worker-vm"
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
  default = 2
}
variable "worker_vm_cores" {
  type = number
  default = 1
}
variable "worker_vm_memory" {
  type = number
  default = 3072
}
variable "worker_vm_disk_size" {
  type        = number
  description = "Disk size in GB"
  default = 15
}


# controlplane vm variables
variable "cp_vm_name" {
  type = string
  default = "k3s-cp-vm"
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
  default = 3
}
variable "cp_vm_memory" {
  type = number
  default = 5120
}
variable "cp_vm_disk_size" {
  type        = number
  description = "Disk size in GB"
  default = 25
}

# proxmox cloud-init 
variable "ubuntu_cloud_init_user_config_file" {
  type    = string
  default = "ubuntu-cloud-init-user-config.yaml"
}
variable "ubuntu_cloud_init_vendor_config_file" {
  type    = string
  default = "ubuntu-cloud-init-vendor-config.yaml"
}