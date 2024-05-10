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
variable "ct_name" {
  type = string
}
variable "ct_ip_addr" {
  type = string
}
variable "ct_gateway_ip" {
  type = string
}
variable "ct_cpu_cores" {
  type = number
}
variable "ct_memory" {
  type = number
}
variable "ct_disk_size" {
  type        = number
  description = "Disk size in GB"
}
variable "ct_network_device" {
  type    = string
  default = "vmbr0"
}
variable "ct_description" {
  default = "Container Managed by terraform"
  type    = string
}
variable "ct_tags" {
  type    = list(any)
  default = ["provisioner-tf"]
}
variable "ct_startup_order" {
  type        = string
  default     = 0
  description = "define the general startup order"
}
variable "ct_startup_up_delay" {
  type        = string
  default     = 0
  description = "delay in seconds before the next container is started"
}
variable "ct_startup_down_delay" {
  type        = string
  default     = 0
  description = "delay in seconds before the next container is shut down"
}
variable "ct_default_user_pwd" {
  type        = string
  description = "The default use password in container. set the value using environment variable TF_VAR_ct_default_user_pwd"
}
variable "local_machine_ssh_key" {
  type        = string
  description = "The ssh public key of your local development machine. set the value using environment variable TF_VAR_local_machine_ssh_key"
}