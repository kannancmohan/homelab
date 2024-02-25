variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWmuxBWj5GebJtC5sp4kfUGdodLswXVxj9Vrzauf63B kannanmohanklm@gmail.com"
}
variable "proxmox_host" {
    default = "node1-home-network.io"
}
variable "template_name" {
    default = "ubuntu-jammy-server"
}