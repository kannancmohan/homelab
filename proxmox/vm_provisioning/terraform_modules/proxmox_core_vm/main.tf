resource "proxmox_virtual_environment_vm" "proxmox_vm" {
  node_name = var.vm_node
  vm_id     = var.vm_id
  name      = var.vm_name
  #pool_id   = proxmox_virtual_environment_pool.proxmox_resource_pool.id
  description = var.vm_description
  tags        = var.vm_tags

  cpu {
    cores = var.vm_cpu_cores
    type  = var.vm_cpu_type
    #numa  = true
    #limit = 64 # Limit of CPU usage, 0...128. (defaults to 0 -- no limit)
  }

  memory {
    dedicated = var.vm_memory
  }

  network_device {
    bridge = var.vm_network_device
    #mac_address = "${var.controlplane_mac_address_prefix}${count.index + 1}"
    #vlan_id     = var.controlplane_vlan_id
  }

  disk {
    datastore_id = var.vm_disk_datastore_id
    file_id      = var.vm_disk_file_id
    #file_format  = "raw"
    interface = "scsi0"
    discard   = "on"
    size      = var.vm_disk_size
    ssd       = var.vm_disk_ssd_enabled
  }

  initialization {
    # dns {
    #   domain  = local.domain
    #   servers = [local.gateway]
    # }

    ip_config {
      ipv4 {
        address = var.vm_cidr
        gateway = var.vm_gateway_ip
      }
    }

    # user_account {
    #   keys     = [trimspace("")]
    #   password = ""
    #   username = "ubuntu"
    # }

    user_data_file_id   = var.vm_cloudinit_user_data_file_id
    vendor_data_file_id = var.vm_cloudinit_vendor_data_file_id
    # meta_data_file_id   = proxmox_virtual_environment_file.ubuntu_cloud_init_metada_ta_config.id
    # network_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init_network_config.id
  }

  agent {
    enabled = var.vm_agent_enabled
    # immediatly timing out, rather than terraform waiting for agent to start 
    timeout = var.vm_agent_timeout
  }

  operating_system {
    type = "l26"
  }

  # Remove the node from Kubernetes on destroy
  #   provisioner "local-exec" {
  #     when    = destroy
  #     command = "./bin/manage_nodes remove ${self.name}"
  #   }

  startup {
    order      = var.vm_startup_order      # define the general startup order.
    up_delay   = var.vm_startup_up_delay   # delay in seconds before the next VM is started
    down_delay = var.vm_startup_down_delay # delay in seconds before the next VM is shut down
  }

  lifecycle {
    ignore_changes = [disk[0].file_id, tags]
  }
  # serial_device {}
  reboot = var.vm_reboot
}