resource "proxmox_virtual_environment_container" "container" {

  node_name    = var.proxmox_node_name
  vm_id        = var.vm_id
  description  = var.vm_description
  tags         = var.vm_tags
  unprivileged = true

  initialization {
    hostname = var.vm_name
    ip_config {
      ipv4 {
        address = "${var.vm_ip_addr}/24"
        gateway = var.vm_gateway_ip
      }
    }

    user_account {
      keys = [
        trimspace(var.local_machine_ssh_key)
      ]
      password = var.vm_default_user_pwd
    }
  }

  disk {
    datastore_id = var.proxmox_node_default_datastore_id
    size         = var.vm_disk_size
  }

  network_interface {
    name = var.vm_network_device
  }

  memory {
    dedicated = var.vm_memory
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
    order      = var.vm_startup_order
    up_delay   = var.vm_startup_up_delay
    down_delay = var.vm_startup_down_delay
  }
}

resource "proxmox_virtual_environment_download_file" "container_template_file" {
  file_name    = var.proxmox_cloud_image_file_name
  content_type = "vztmpl"
  datastore_id = var.proxmox_node_template_datastore_id
  node_name    = var.proxmox_node_name
  url          = var.container_template_url
  overwrite_unmanaged    = true
}

output "container_info" {
  value = {
    "vm_id" : proxmox_virtual_environment_container.container.vm_id
  }
}