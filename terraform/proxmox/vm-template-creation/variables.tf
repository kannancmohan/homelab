# variable's specific to provider
variable "proxmox_api_endpoint" {
  type        = string
  description = "Proxmox cluster API endpoint https://proxmox-01.my-domain.net:8006"
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
