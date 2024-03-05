resource "proxmox_virtual_environment_download_file" "ubuntu-qcow2-img" {
  content_type        = "iso"
  datastore_id        = var.proxmox_node_iso_datastore_id #the proxmox datastore if where iso are stored
  node_name           = var.proxmox_node_name
  url                 = var.cloud_image_iso_url
  checksum            = var.cloud_image_iso_checksum
  checksum_algorithm  = "sha256"
  overwrite_unmanaged = true #if file with the same name already exists in the datastore, it will be deleted and the new file will be downloaded. If false and the file already exists, an error will be returned
}

resource "proxmox_virtual_environment_file" "ubuntu-cloud-init-user-config" {
  content_type = "snippets"
  datastore_id = var.proxmox_node_iso_datastore_id
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<EOF
#cloud-config
chpasswd:
  list: |
    ${var.vm_default_user_name}:${var.vm_default_user_pwd}
  expire: false
#hostname: ${var.worker_vm_name}
preserve_hostname: true
users:
  - default
  - name: ${var.vm_default_user_name}
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${trimspace("${var.local_machine_ssh_key}")}
    sudo: ALL=(ALL) NOPASSWD:ALL
    EOF

    file_name = "ubuntu-cloud-init-user-config.yaml"
  }
}

resource "proxmox_virtual_environment_file" "ubuntu-cloud-init-vendor-config" {
  content_type = "snippets"
  datastore_id = var.proxmox_node_iso_datastore_id
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<EOF
#cloud-config
runcmd:
    - apt update
    - apt install -y qemu-guest-agent
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
    - echo "done" > /tmp/vendor-cloud-init-done
    EOF

    file_name = "ubuntu-cloud-init-vendor-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "controlplane-ubuntu-vm" {

  count       = var.cp_vm_count
  vm_id       = "${var.cp_vm_id_prefix}${count.index + 1}"
  name        = "${var.cp_vm_name}-${count.index + 1}"
  description = "Ubuntu Controlplane VM managed by Terraform"
  tags        = var.cp_vm_tags
  node_name   = var.proxmox_node_name

  cpu {
    cores = var.cp_vm_cores
    #If you don’t care about live migration or have a homogeneous cluster where all nodes have the same CPU and same microcode version, set the CPU type to host, as in theory this will give your guests maximum performance
    type = "host" # default is "qemu64" . check https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#type
    #numa  = true
    #limit = 64 # Limit of CPU usage, 0...128. (defaults to 0 -- no limit)
  }

  memory {
    dedicated = var.cp_vm_memory
  }

  #The QEMU agent configuration
  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  startup {
    order      = "2"  #define the general startup order.
    up_delay   = "60" #delay in seconds before the next VM is started
    down_delay = "60" #delay in seconds before the next VM is shut down
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.proxmox_node_default_datastore_id
    file_id      = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.id
    interface    = "scsi0"
    ssd          = true #TBC
    file_format  = "raw"
    discard      = "on" #Whether to pass discard/trim requests to the underlying storage
    size         = var.cp_vm_disk_size
    #cache = "writeback" # Write to the host cache, but write back to the guest when possible
    #iothread = true #Whether to use iothreads for this disk
  }

  #The cloud-init configuration
  initialization {
    datastore_id = var.proxmox_node_default_datastore_id
    #interface    = "scsi0"

    # dns {
    #   servers = ["1.1.1.1", "8.8.8.8"]
    # }

    ip_config {
      ipv4 {
        address = "${var.cp_vm_ip_prefix}${count.index + 1}/24"
        gateway = var.cp_vm_gateway_ip
      }
    }

    # user_account {
    #   keys     = [trimspace("")]
    #   password = ""
    #   username = "ubuntu"
    # }

    user_data_file_id   = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.id
    vendor_data_file_id = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.id
    #meta_data_file_id   = proxmox_virtual_environment_file.ubuntu_cloud_init_metada_ta_config.id
    #network_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init_network_config.id
  }

  operating_system {
    type = "l26" #Linux Kernel 2.6 - 5.X.
  }

  serial_device {}
  reboot = true # Reboot the VM after initial creation

  # TODO check if there is any other option to update hostname
  provisioner "remote-exec" {
    inline = [
      "echo 'Updating hostname!'",
      "sudo hostnamectl set-hostname ${self.name}"
    ]
    connection {
      type     = "ssh"
      user     = var.vm_default_user_name
      password = var.vm_default_user_pwd
      #host     = element(element(self.ipv4_addresses, index(self.network_interface_names, "eth0")), 0)
      host = "${var.cp_vm_ip_prefix}${count.index + 1}"
    }
  }

}

resource "proxmox_virtual_environment_vm" "worker-ubuntu-vm" {

  count       = var.worker_vm_count
  vm_id       = "${var.worker_vm_id_prefix}${count.index + 1}"
  name        = "${var.worker_vm_name}-${count.index + 1}"
  description = "Ubuntu Worker VM managed by Terraform"
  tags        = var.worker_vm_tags
  node_name   = var.proxmox_node_name

  cpu {
    cores = var.worker_vm_cores
    #If you don’t care about live migration or have a homogeneous cluster where all nodes have the same CPU and same microcode version, set the CPU type to host, as in theory this will give your guests maximum performance
    type = "host" # default is "qemu64" . check https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#type
    #numa  = true
    #limit = 64 # Limit of CPU usage, 0...128. (defaults to 0 -- no limit)
  }

  memory {
    dedicated = var.worker_vm_memory
  }

  #The QEMU agent configuration
  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  startup {
    order      = "3"  #define the general startup order.
    up_delay   = "60" #delay in seconds before the next VM is started
    down_delay = "60" #delay in seconds before the next VM is shut down
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.proxmox_node_default_datastore_id
    file_id      = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.id
    interface    = "scsi0"
    ssd          = true #TBC
    file_format  = "raw"
    discard      = "on" #Whether to pass discard/trim requests to the underlying storage
    size         = var.worker_vm_disk_size
    #cache = "writeback" # Write to the host cache, but write back to the guest when possible
    #iothread = true #Whether to use iothreads for this disk
  }

  #The cloud-init configuration
  initialization {
    datastore_id = var.proxmox_node_default_datastore_id
    #interface    = "scsi0"

    # dns {
    #   servers = ["1.1.1.1", "8.8.8.8"]
    # }

    ip_config {
      ipv4 {
        address = "${var.worker_vm_ip_prefix}${count.index + 1}/24"
        gateway = var.worker_vm_gateway_ip
      }
    }

    # user_account {
    #   keys     = [trimspace("")]
    #   password = ""
    #   username = "ubuntu"
    # }

    user_data_file_id   = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.id
    vendor_data_file_id = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.id
    #meta_data_file_id   = proxmox_virtual_environment_file.ubuntu_cloud_init_metada_ta_config.id
    #network_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init_network_config.id
  }

  operating_system {
    type = "l26" #Linux Kernel 2.6 - 5.X.
  }

  serial_device {}
  reboot = true # Reboot the VM after initial creation

  # TODO check if there is any other option to update hostname
  provisioner "remote-exec" {
    inline = [
      "echo 'Updating hostname!'",
      "sudo hostnamectl set-hostname ${self.name}"
    ]
    connection {
      type     = "ssh"
      user     = var.vm_default_user_name
      password = var.vm_default_user_pwd
      #host     = element(element(self.ipv4_addresses, index(self.network_interface_names, "eth0")), 0)
      host = "${var.worker_vm_ip_prefix}${count.index + 1}"
    }
  }
}
