locals {
  iso_image_file_name    = "nocloud-amd64.raw.xz-${var.talos_version}.img"
  iso_image_download_url = "https://github.com/siderolabs/talos/releases/download/${var.talos_version}/nocloud-amd64.raw.xz"

  proxmox_controlplanes = [
    for index in range(1, var.controlplane_num + 1) : {
      node            = var.proxmox_node_name
      id              = "${var.controlplane_id_prefix}${index}"
      name            = "${var.controlplane_name_prefix}${index}"
      address         = "${var.controlplane_ip_prefix}${index}"
      gateway_address = var.controlplane_gateway_address
    }
  ]
  controlplanes = setunion(local.proxmox_controlplanes)

  proxmox_workers = [
    for index in range(1, var.worker_num + 1) : {
      node            = var.proxmox_node_name
      id              = "${var.worker_id_prefix}${index}"
      name            = "${var.worker_name_prefix}${index}"
      address         = "${var.worker_ip_prefix}${index}"
      gateway_address = var.worker_gateway_address
    }
  ]
  workers = setunion(local.proxmox_workers)
}
