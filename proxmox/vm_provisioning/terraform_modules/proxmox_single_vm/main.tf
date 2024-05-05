terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.47.0"
    }
  }
}

locals {
  vm_name_prefix = "${var.vm_name}-${var.vm_id}"
}

## TODO find a logic not to overwrite this resource when creating different vm's  when using this module
resource "proxmox_virtual_environment_download_file" "ubuntu-qcow2-img" {
  file_name    = var.proxmox_cloud_image_file_name
  content_type = "iso"
  datastore_id = var.proxmox_node_iso_datastore_id #the proxmox datastore if where iso are stored
  node_name    = var.proxmox_node_name
  url          = var.cloud_image_iso_url
  # overwrite = true # if true and size of uploaded file is different than size from url Content-Length header, file will be downloaded again
  overwrite_unmanaged = true #if file with the same name already exists in the datastore, it will be deleted and the new file will be downloaded. If false and the file already exists, an error will be returned
}

resource "proxmox_virtual_environment_file" "ubuntu-cloud-init-user-config" {
  content_type = "snippets"
  datastore_id = var.proxmox_node_iso_datastore_id
  node_name    = var.proxmox_node_name

  source_raw {
    data      = <<EOF
#cloud-config
chpasswd:
  list: |
    ${var.vm_default_user_name}:${var.vm_default_user_pwd}
  expire: false
hostname: ${var.vm_name}
preserve_hostname: true
timezone: ${var.vm_timezone}
write_files:
  - path: /etc/environment
    content: |
      SOME_ENV_VAR="test"
    append: true
users:
  - default
  - name: ${var.vm_default_user_name}
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${trimspace("${var.local_machine_ssh_key}")}
    sudo: ALL=(ALL) NOPASSWD:ALL
    EOF
    file_name = "${local.vm_name_prefix}-cloud-init-user-config.yaml"
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

    file_name = "${local.vm_name_prefix}-cloud-init-vendor-config.yaml"
  }
}

module "worker" {
  source                           = "../proxmox_core_vm"
  count                            = 1
  vm_id                            = var.vm_id
  vm_name                          = local.vm_name_prefix
  vm_node                          = var.proxmox_node_name
  vm_description                   = "Provisioned by terraform"
  vm_cidr                          = "${var.vm_ip_addr}/24"
  vm_gateway_ip                    = var.vm_gateway_ip
  vm_cpu_cores                     = var.vm_cpu_cores
  vm_memory                        = var.vm_memory
  vm_disk_file_id                  = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.id
  vm_disk_size                     = var.vm_disk_size
  vm_disk_ssd_enabled              = true
  vm_tags                          = var.vm_tags
  vm_agent_enabled                 = true
  vm_cloudinit_user_data_file_id   = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.id
  vm_cloudinit_vendor_data_file_id = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.id
  vm_startup_order                 = "1"
  vm_reboot                        = true
}


output "uploaded_image_file_name" {
  value = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.file_name
}
output "ubuntu_cloud_init_user_conf_file_name" {
  value = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.file_name
}
output "ubuntu_cloud_init_vendor_conf_file_name" {
  value = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.file_name
}

output "worker_vm_info" {
  value = module.worker
}