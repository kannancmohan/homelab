resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = var.proxmox_node_iso_datastore_id
  node_name    = var.proxmox_node_name

  source_file {
    # you may download this image locally on your workstation and then use the local path instead of the remote URL
    path = var.cloud_image_iso_url

    # you may also use the SHA256 checksum of the image to verify its integrity
    checksum = var.cloud_image_iso_checksum
  }
}
