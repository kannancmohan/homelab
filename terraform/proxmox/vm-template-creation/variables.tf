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
variable "vm_default_user_pwd" {
  type = string
}
