# vm variables
# variable "proxmox_api_endpoint" {
#   type        = string
#   description = "set the value for this variable using environment variable TF_VAR_proxmox_api_endpoint"
# }
variable "proxmox_node_name" {
  type = string
}
variable "proxmox_node_template_datastore_id" {
  type = string
}
variable "proxmox_node_default_datastore_id" {
  type = string
}

# project variables
variable "container_template_url" {
  type    = string
  default = "http://download.proxmox.com/images/system/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}
variable "proxmox_cloud_image_file_name" {
  type    = string
  default = "ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "vm_id" {
  type = number
}
variable "vm_name" {
  type = string
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
variable "vm_network_device" {
  type    = string
  default = "vmbr0"
}
variable "vm_description" {
  default = "Container Managed by terraform"
  type    = string
}
variable "vm_tags" {
  type    = list(any)
  default = ["provisioner-tf"]
}
variable "vm_startup_order" {
  type        = string
  default     = 0
  description = "define the general startup order"
}
variable "vm_startup_up_delay" {
  type        = string
  default     = 0
  description = "delay in seconds before the next VM is started"
}
variable "vm_startup_down_delay" {
  type        = string
  default     = 0
  description = "delay in seconds before the next VM is shut down"
}
variable "vm_default_user_pwd" {
  type        = string
  description = "The default use password in vm. set the value using environment variable TF_VAR_vm_default_user_pwd"
}
variable "local_machine_ssh_key" {
  type        = string
  description = "The ssh public key of your local development machine. set the value using environment variable TF_VAR_local_machine_ssh_key"
}