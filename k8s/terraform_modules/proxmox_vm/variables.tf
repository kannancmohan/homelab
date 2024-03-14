# vm variables
variable "vm_node" {
  type    = string
}
variable "vm_id" {
  type    = number
}
variable "vm_name" {
  type    = string
}
variable "vm_description" {
  default = "VM Managed by terraform"
  type    = string
}
variable "vm_tags" {
  type    = list(any)
  default = ["provisioner-tf"]
}


variable "vm_cpu_cores" {
  type    = number
  default = 1
}
variable "vm_cpu_type" {
  type    = string
  default = "host"
}
variable "vm_memory" {
  type    = number
  default = 1024
}
variable "vm_network_device" {
  type        = string
  default     = "vmbr0"
}
variable "vm_disk_datastore_id" {
  type        = string
  default     = "local-lvm"
}
variable "vm_disk_file_id" {
  type        = string
}
variable "vm_disk_size" {
  type    = string
  default = "10"
}
variable "vm_cidr" {
  type    = string
}
variable "vm_gateway_ip" {
  type    = string
}
variable "vm_agent_enabled" {
  type    = bool
  default = false
}
variable "vm_agent_timeout" {
  type    = string
  default = "1s"
}
variable "vm_reboot" {
  type    = bool
  default = false
}
variable "cloudinit_user_data_file_id" {
  type        = string
  default = null
}
variable "cloudinit_vendor_data_file_id" {
  type        = string
  default = null
}