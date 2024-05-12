terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.55.1"
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

module "container" {
  source                             = "../../container_provisioning/terraform_modules/proxmox_core_container"
  count                              = length(var.ct_ip_addr)
  proxmox_node_name                  = var.proxmox_node_name
  proxmox_node_template_datastore_id = var.proxmox_node_template_datastore_id
  proxmox_node_default_datastore_id  = var.proxmox_node_default_datastore_id
  local_machine_ssh_key              = var.local_machine_ssh_key
  ct_default_user_pwd                = var.ct_default_user_pwd
  ct_name                            = var.ct_name
  ct_ip_addr                         = var.ct_ip_addr[count.index]
  ct_gateway_ip                      = var.ct_gateway_ip
  ct_cpu_cores                       = var.ct_cpu_cores
  ct_memory                          = var.ct_memory
  ct_disk_size                       = var.ct_disk_size
  ct_tags                            = var.ct_tags
}

output "container_info" {
  value = module.container
}