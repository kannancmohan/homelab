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

resource "proxmox_virtual_environment_vm" "controlplane" {
  for_each = { for item in local.controlplanes : item.name => item } # here 'item.name => item' is way of setting the "key" and "value" for the resource 
  vm_id    = each.value.id

  #pool_id   = proxmox_virtual_environment_pool.proxmox_resource_pool.id
  node_name = each.value.node

  name        = each.value.name
  description = "Talos Control plane manged by terraform"
  tags        = var.controlplane_tags

  cpu {
    cores = var.controlplane_cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.controlplane_memory
  }

  network_device {
    bridge = var.controlplane_network_device
    #mac_address = "${var.controlplane_mac_address_prefix}${count.index + 1}"
    #vlan_id     = var.controlplane_vlan_id
  }

  disk {
    datastore_id = var.controlplane_datastore
    file_id      = proxmox_virtual_environment_download_file.talos_image.id
    #file_format  = "raw"
    interface = "scsi0"
    discard   = "on"
    size      = var.controlplane_disk_size
  }

  initialization {
    # dns {
    #   domain  = local.domain
    #   servers = [local.gateway]
    # }

    ip_config {
      ipv4 {
        address = "${each.value.address}/24"
        gateway = each.value.gateway_address
      }
    }
  }

  # agent {
  #   enabled = true
  #   # immediatly timing out, rather than terraform waiting for agent to start 
  #   timeout = "1s"
  # }

  operating_system {
    type = "l26"
  }

  # Remove the node from Kubernetes on destroy
  #   provisioner "local-exec" {
  #     when    = destroy
  #     command = "./bin/manage_nodes remove ${self.name}"
  #   }

  lifecycle {
    //ignore_changes = [agent, disk[0].file_id, tags]
    ignore_changes = [disk[0].file_id]
  }
}

resource "proxmox_virtual_environment_vm" "worker" {
  for_each = { for item in local.workers : item.name => item } # here 'item.name => item' is way of setting the "key" and "value" for the resource 
  vm_id    = each.value.id

  #pool_id   = proxmox_virtual_environment_pool.proxmox_resource_pool.id
  node_name = each.value.node

  name        = each.value.name
  description = "Talos worker manged by terraform"
  tags        = var.worker_tags

  cpu {
    cores = var.worker_cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.worker_memory
  }

  network_device {
    bridge = var.worker_network_device
    #mac_address = "${var.controlplane_mac_address_prefix}${count.index + 1}"
    #vlan_id     = var.controlplane_vlan_id
  }

  disk {
    datastore_id = var.worker_datastore
    file_id      = proxmox_virtual_environment_download_file.talos_image.id
    #file_format  = "raw"
    interface = "scsi0"
    discard   = "on"
    size      = var.worker_disk_size
  }

  initialization {
    # dns {
    #   domain  = local.domain
    #   servers = [local.gateway]
    # }

    ip_config {
      ipv4 {
        address = "${each.value.address}/24"
        gateway = each.value.gateway_address
      }
    }
  }

  # agent {
  #   enabled = true
  #   # immediatly timing out, rather than terraform waiting for agent to start 
  #   timeout = "1s"
  # }

  operating_system {
    type = "l26"
  }

  # Remove the node from Kubernetes on destroy
  #   provisioner "local-exec" {
  #     when    = destroy
  #     command = "./bin/manage_nodes remove ${self.name}"
  #   }

  lifecycle {
    //ignore_changes = [agent, disk[0].file_id, tags]
    ignore_changes = [disk[0].file_id]
  }
}