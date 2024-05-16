terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.47.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_endpoint
  insecure = true
  ssh {
    agent    = true
    username = "root" # can be set via environment variable PROXMOX_VE_SSH_USERNAME
  }
}

module "worker" {
  source                        = "../../../../commons/terraform/modules/proxmox/vm_provisioning/single_vm"
  proxmox_node_name             = var.proxmox_node_name
  proxmox_node_iso_datastore_id = var.proxmox_node_iso_datastore_id
  local_machine_ssh_key         = var.local_machine_ssh_key
  vm_default_user_name          = var.vm_default_user_name
  vm_default_user_pwd           = var.vm_default_user_pwd
  vm_id                         = var.vm_id
  vm_name                       = var.vm_name
  vm_ip_addr                    = var.vm_ip_addr
  vm_gateway_ip                 = var.vm_gateway_ip
  vm_cpu_cores                  = var.vm_cores
  vm_memory                     = var.vm_memory
  vm_disk_size                  = var.vm_disk_size
  vm_tags                       = var.vm_tags
}

output "worker_vm_info" {
  value = module.worker
}