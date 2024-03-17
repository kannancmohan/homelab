resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type            = "iso"
  datastore_id            = var.proxmox_node_iso_datastore_id #the proxmox datastore where iso are stored(default is local)
  node_name               = var.proxmox_node_name
  file_name               = local.iso_image_file_name
  url                     = local.iso_image_download_url
  decompression_algorithm = "zst"
  overwrite               = false
  #overwrite_unmanaged = true #if file with the same name already exists in the datastore, it will be deleted and the new file will be downloaded. If false and the file already exists, an error will be returned
}

module "controlplane" {
  source          = "../../../proxmox/vm_provisioning/terraform_module"
  for_each        = { for item in local.controlplanes : item.name => item }
  vm_id           = each.value.id
  vm_name         = each.value.name
  vm_node         = each.value.node
  vm_description  = "Talos controlplane provisioned by terraform"
  vm_cidr         = "${each.value.address}/24"
  vm_gateway_ip   = each.value.gateway_address
  vm_cpu_cores    = var.controlplane_cpu_cores
  vm_memory       = var.controlplane_memory
  vm_disk_file_id = proxmox_virtual_environment_download_file.talos_image.id
  vm_disk_size    = var.controlplane_disk_size
  vm_tags         = var.controlplane_tags
}

module "worker" {
  source          = "../../../proxmox/vm_provisioning/terraform_module"
  for_each        = { for item in local.workers : item.name => item }
  vm_id           = each.value.id
  vm_name         = each.value.name
  vm_node         = each.value.node
  vm_description  = "Talos worker provisioned by terraform"
  vm_cidr         = "${each.value.address}/24"
  vm_gateway_ip   = each.value.gateway_address
  vm_cpu_cores    = var.worker_cpu_cores
  vm_memory       = var.worker_memory
  vm_disk_file_id = proxmox_virtual_environment_download_file.talos_image.id
  vm_disk_size    = var.worker_disk_size
  vm_tags         = var.worker_tags
}