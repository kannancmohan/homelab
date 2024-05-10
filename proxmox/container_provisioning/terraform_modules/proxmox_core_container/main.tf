locals {
  split_ct_ip    = split(".", var.ct_ip_addr)
  last_ip_number = element(local.split_ct_ip, length(local.split_ct_ip) - 1) # To get the last element from ip
}

resource "proxmox_virtual_environment_container" "container" {
  node_name    = var.proxmox_node_name
  vm_id        = "1${local.last_ip_number}"
  description  = var.ct_description
  tags         = var.ct_tags
  unprivileged = true

  initialization {
    hostname = var.ct_name
    ip_config {
      ipv4 {
        address = "${var.ct_ip_addr}/24"
        gateway = var.ct_gateway_ip
      }
    }

    user_account {
      keys = [
        trimspace(var.local_machine_ssh_key)
      ]
      password = var.ct_default_user_pwd
    }
  }

  disk {
    datastore_id = var.proxmox_node_default_datastore_id
    size         = var.ct_disk_size
  }

  network_interface {
    name = var.ct_network_device
  }

  memory {
    dedicated = var.ct_memory
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.container_template_file.id
    type             = "ubuntu"
  }

  # mount_point {
  #   # bind mount, *requires* root@pam authentication
  #   volume = "/mnt/bindmounts/shared"
  #   path   = "/mnt/shared"
  # }

  # mount_point {
  #   # volume mount, a new volume will be created by PVE
  #   volume = "local-lvm"
  #   size   = "10G"
  #   path   = "/mnt/volume"
  # }

  startup {
    order      = var.ct_startup_order
    up_delay   = var.ct_startup_up_delay
    down_delay = var.ct_startup_down_delay
  }
}

resource "proxmox_virtual_environment_download_file" "container_template_file" {
  file_name           = var.proxmox_cloud_image_file_name
  content_type        = "vztmpl"
  datastore_id        = var.proxmox_node_template_datastore_id
  node_name           = var.proxmox_node_name
  url                 = var.container_template_url
  overwrite_unmanaged = true
}

output "container_info" {
  value = {
    "ct_id" : proxmox_virtual_environment_container.container.vm_id
  }
}