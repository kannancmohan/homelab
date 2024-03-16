resource "proxmox_virtual_environment_download_file" "ubuntu-qcow2-img" {
  content_type       = "iso"
  datastore_id       = var.proxmox_node_iso_datastore_id #the proxmox datastore if where iso are stored
  node_name          = var.proxmox_node_name
  url                = var.cloud_image_iso_url
  checksum           = var.cloud_image_iso_checksum
  checksum_algorithm = "sha256"
  overwrite          = true
  #overwrite_unmanaged = true #if file with the same name already exists in the datastore, it will be deleted and the new file will be downloaded. If false and the file already exists, an error will be returned
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

module "controlplane" {
  source                           = "../../../proxmox/vm_provisioning/terraform_module"
  count                            = var.cp_vm_count
  vm_id                            = "${var.cp_vm_id_prefix}${count.index + 1}"
  vm_name                          = "${var.cp_vm_name}-${count.index + 1}"
  vm_node                          = var.proxmox_node_name
  vm_description                   = "k8s controlplane provisioned by terraform"
  vm_cidr                          = "${var.cp_vm_ip_prefix}${count.index + 1}/24"
  vm_gateway_ip                    = var.cp_vm_gateway_ip
  vm_cpu_cores                     = var.cp_vm_cores
  vm_memory                        = var.cp_vm_memory
  vm_disk_file_id                  = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.id
  vm_disk_size                     = var.cp_vm_disk_size
  vm_disk_ssd_enabled              = true
  vm_tags                          = var.cp_vm_tags
  vm_agent_enabled                 = true
  vm_cloudinit_user_data_file_id   = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.id
  vm_cloudinit_vendor_data_file_id = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.id
  vm_reboot                        = true
}

module "worker" {
  source                           = "../../../proxmox/vm_provisioning/terraform_module"
  count                            = var.worker_vm_count
  vm_id                            = "${var.worker_vm_id_prefix}${count.index + 1}"
  vm_name                          = "${var.worker_vm_name}-${count.index + 1}"
  vm_node                          = var.proxmox_node_name
  vm_description                   = "k8s worker provisioned by terraform"
  vm_cidr                          = "${var.worker_vm_ip_prefix}${count.index + 1}/24"
  vm_gateway_ip                    = var.worker_vm_gateway_ip
  vm_cpu_cores                     = var.worker_vm_cores
  vm_memory                        = var.worker_vm_memory
  vm_disk_file_id                  = proxmox_virtual_environment_download_file.ubuntu-qcow2-img.id
  vm_disk_size                     = var.worker_vm_disk_size
  vm_disk_ssd_enabled              = true
  vm_tags                          = var.worker_vm_tags
  vm_agent_enabled                 = true
  vm_cloudinit_user_data_file_id   = proxmox_virtual_environment_file.ubuntu-cloud-init-user-config.id
  vm_cloudinit_vendor_data_file_id = proxmox_virtual_environment_file.ubuntu-cloud-init-vendor-config.id
  vm_reboot                        = true
}
