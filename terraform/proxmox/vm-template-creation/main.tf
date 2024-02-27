
data "proxmox_virtual_environment_datastores" "proxmox_node" {
  node_name = var.proxmox_node_name
}

locals {
  datastore_id = element(data.proxmox_virtual_environment_datastores.proxmox_node.datastore_ids, index(data.proxmox_virtual_environment_datastores.proxmox_node.datastore_ids, "local-lvm"))
}


resource "proxmox_virtual_environment_download_file" "ubuntu_qcow2_img" {
  content_type = "iso"
  datastore_id = "local" #the proxmox datastore if where iso are stored
  node_name    = var.proxmox_node_name
  url          = var.cloud_image_iso_url
  #checksum     = var.cloud_image_iso_checksum
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<EOF
#cloud-config
# chpasswd:
#   list: |
#     ubuntu:ubuntu    
#   expire: false
packages:
  - qemu-guest-agent
#timezone: Europe/Oslo

# users:
#   - default
#   - name: ubuntu
#     groups: sudo
#     shell: /bin/bash
#     ssh-authorized-keys:
#       - ${trimspace("ssh-rsa <sha356> user@mail.com")}
#     sudo: ALL=(ALL) NOPASSWD:ALL

power_state:
    delay: now
    mode: reboot
    message: Rebooting after cloud-init completion
    condition: true

EOF

    file_name = "ubuntu.cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm_template" {

  name        = "ubuntu-vm-template"
  description = "VM template managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s"]
  node_name   = var.proxmox_node_name

  // use auto-generated vm_id, so comment it out
  #vm_id     = "100${count.index + 1}"
  #machine = "q35"
  #bios        = "ovmf"

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }

  cpu {
    cores = 1
    #numa  = true
    #limit = 64 # Limit of CPU usage, 0...128. (defaults to 0 -- no limit)
  }

  memory {
    dedicated = 1024
  }

  # smbios {
  #   manufacturer = "Terraform"
  #   product      = "Terraform Provider Proxmox"
  #   version      = "0.0.1"
  # }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  #The efi disk device (required if bios is set to ovmf)
  # efi_disk {
  #   datastore_id = local.datastore_id
  #   file_format  = "raw"
  #   type         = "4m"
  # }

  # tpm_state {
  #   datastore_id = local.datastore_id
  #   version      = "v2.0"
  # }

  #  disk {
  #    datastore_id = local.datastore_id
  #    file_id      = proxmox_virtual_environment_download_file.ubuntu_qcow2_img.id
  #    interface    = "virtio0"
  #    iothread     = true
  #  }

  # disk {
  #   datastore_id = "local-lvm"
  #   file_id      = proxmox_virtual_environment_file.ubuntu_qcow2_img.id
  #   interface    = "scsi0"
  # }

  disk {
    datastore_id = local.datastore_id
    file_id      = proxmox_virtual_environment_download_file.ubuntu_qcow2_img.id
    interface    = "scsi0"
    #interface = "virtio0"
    discard   = "on"
    cache        = "writeback"
    ssd          = true
  }

  #  disk {
  #    datastore_id = "nfs"
  #    interface    = "scsi1"
  #    discard      = "ignore"
  #    file_format  = "raw"
  #  }

  initialization {
    datastore_id = local.datastore_id
    #interface    = "scsi4"

    # dns {
    #   servers = ["1.1.1.1", "8.8.8.8"]
    # }

    # ip_config {
    #   ipv4 {
    #     address = "dhcp"
    #   }
    #   # ipv6 {
    #   #    address = "dhcp" 
    #   #}
    # }

    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
    #vendor_data_file_id = proxmox_virtual_environment_file.vendor_config.id
    #meta_data_file_id   = proxmox_virtual_environment_file.meta_config.id
  }

  # network_device {
  #   mtu    = 1450
  #   queues = 2
  # }

  # network_device {
  #   vlan_id = 1024
  # }
  network_device {
    bridge = "vmbr0"
    #vlan_id = "216"
  }

  operating_system {
    type = "l26" #Linux Kernel 2.6 - 5.X.
  }

  #pool_id = proxmox_virtual_environment_pool.example.id

  serial_device {}

  template = true

}
