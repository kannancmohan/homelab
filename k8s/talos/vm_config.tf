resource "talos_machine_secrets" "secrets" {
  talos_version = var.talos_version
  #   lifecycle {
  #     prevent_destroy = true
  #     ignore_changes = [
  #       talos_version
  #     ]
  #   }
}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.kubernetes_cluster_name
  cluster_endpoint   = "https://${var.talos_virtual_ip}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.secrets.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.kubernetes_cluster_name
  cluster_endpoint   = "https://${var.talos_virtual_ip}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.secrets.machine_secrets
  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

data "talos_client_configuration" "client" {
  client_configuration = talos_machine_secrets.secrets.client_configuration
  cluster_name         = var.kubernetes_cluster_name
  endpoints            = setunion([var.talos_virtual_ip], local.controlplanes[*].address)
  nodes                = setunion(local.proxmox_controlplanes[*].address, local.proxmox_workers[*].address)
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each = {
    for index, item in local.proxmox_controlplanes :
    item.name => item
  }

  depends_on = [module.controlplane]

  endpoint                    = each.value.address
  node                        = each.value.name
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  client_configuration        = talos_machine_secrets.secrets.client_configuration

  config_patches = [
    templatefile("configs/global.yml", {
      qemu_guest_agent_version = var.qemu_guest_agent_version
    }),
    templatefile("configs/controlplane.yml", {
      talos_virtual_ip = var.talos_virtual_ip
    }),
    var.talos_disable_flannel ? templatefile("configs/disable_flannel.yml", {}) : null
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = {
    for index, item in local.proxmox_workers :
    item.name => item
  }

  depends_on = [module.worker]

  endpoint                    = each.value.address
  node                        = each.value.name
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  client_configuration        = talos_machine_secrets.secrets.client_configuration

  config_patches = [
    templatefile("configs/global.yml", {
      qemu_guest_agent_version = var.qemu_guest_agent_version
    })
  ]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.controlplane[0]]
  node                 = tolist(local.proxmox_controlplanes)[0].address
  endpoint             = tolist(local.proxmox_controlplanes)[0].address
  client_configuration = talos_machine_secrets.secrets.client_configuration
}

data "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap]
  client_configuration = talos_machine_secrets.secrets.client_configuration
  node                 = tolist(local.controlplanes)[0].address
}

output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}

output "talosconfig" {
  value     = data.talos_client_configuration.client.talos_config
  sensitive = true
}