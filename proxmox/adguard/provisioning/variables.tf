# vm variables
variable "proxmox_api_endpoint" {
  type        = string
  description = "set the value for this variable using environment variable TF_VAR_proxmox_api_endpoint"
}
variable "proxmox_node_name" {
  type = string
}
variable "proxmox_node_template_datastore_id" {
  type = string
}
variable "proxmox_node_default_datastore_id" {
  type = string
}
variable "ct_name" {
  type = string
}
variable "ct_ip_addr" {
  type = list(string)
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
variable "ct_tags" {
  type    = list(any)
  default = ["provisioner-tf"]
}
variable "ct_default_user_pwd" {
  type        = string
  description = "The default use password in vm. set the value using environment variable TF_VAR_ct_default_user_pwd"
}
variable "local_machine_ssh_key" {
  type        = string
  description = "The ssh public key of your local development machine. set the value using environment variable TF_VAR_local_machine_ssh_key"
}