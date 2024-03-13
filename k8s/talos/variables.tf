# node variables
variable "proxmox_api_endpoint" {
  type        = string
  description = "set the value for this variable using environment variable TF_VAR_proxmox_api_endpoint"
}
variable "proxmox_node_name" {
  type    = string
  default = "node1-home-network"
}
variable "proxmox_node_iso_datastore_id" {
  type    = string
  default = "local"
}

# Kubernetes Cluster
variable "talos_version" {
  type    = string
  default = "v1.6.6"
}
variable "kubernetes_version" {
  type    = string
  default = "v1.29.2"
}
variable "qemu_guest_agent_version" {
  type        = string
  default     = "8.1.3"
  description = "based on talos gues-agent https://github.com/siderolabs/extensions/pkgs/container/qemu-guest-agent"
}
variable "kubernetes_cluster_name" {
  type        = string
  default     = "kubernetes"
  description = "Kubernetes cluster name"
}
variable "talos_virtual_ip" {
  type        = string
  default     = "192.168.0.20"
  description = "Virtual IP address you wish for Talos to use"
}
variable "talos_disable_flannel" {
  type        = bool
  default     = false
  description = "Whether to disable flannel CNI & Kube Proxy for cilium"
}

# controlplane variables
variable "controlplane_num" {
  type    = number
  default = 1
}
variable "controlplane_id_prefix" {
  type    = number
  default = 400
}
variable "controlplane_name_prefix" {
  type    = string
  default = "talos-cp-"
}
variable "controlplane_ip_prefix" {
  type    = string
  default = "192.168.0.4"
}
variable "controlplane_gateway_address" {
  type    = string
  default = "192.168.0.1"
}
variable "controlplane_tags" {
  type    = list(any)
  default = ["app-k8s", "type-cp", "provisioner-tf"]
}
variable "controlplane_cpu_cores" {
  type    = number
  default = 2
}
variable "controlplane_memory" {
  type    = number
  default = 4096
}
variable "controlplane_datastore" {
  type    = string
  default = "local-lvm"
}
variable "controlplane_disk_size" {
  type    = string
  default = "25"
}
variable "controlplane_network_device" {
  type    = string
  default = "vmbr0"
}
variable "controlplane_mac_address_prefix" {
  type    = string
  default = "00:00:00:00:00:1"
}
variable "controlplane_vlan_id" {
  type    = number
  default = null
}

# worker variables
variable "worker_num" {
  type    = number
  default = 2
}
variable "worker_id_prefix" {
  type    = number
  default = 500
}
variable "worker_name_prefix" {
  type    = string
  default = "talos-worker-"
}
variable "worker_ip_prefix" {
  type    = string
  default = "192.168.0.5"
}
variable "worker_gateway_address" {
  type    = string
  default = "192.168.0.1"
}
variable "worker_tags" {
  type    = list(any)
  default = ["app-k8s", "type-worker", "provisioner-tf"]
}
variable "worker_cpu_cores" {
  type    = number
  default = 1
}
variable "worker_memory" {
  type    = number
  default = 2048
}
variable "worker_datastore" {
  type        = string
  default     = "local-lvm"
  description = "Datastore used for the controlplane virtual machines"
}
variable "worker_disk_size" {
  type    = string
  default = "15"
}
variable "worker_network_device" {
  type        = string
  default     = "vmbr0"
  description = "Network device used for the controlplane virtual machines"
}
variable "worker_mac_address_prefix" {
  type    = string
  default = "00:00:00:00:00:2"
}
variable "worker_vlan_id" {
  type    = number
  default = null
}