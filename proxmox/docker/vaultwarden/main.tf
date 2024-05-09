terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host     = "ssh://${var.remote_username}@${var.remote_ssh_ip}:${var.remote_ssh_port}"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "docker_image" "vaultwarden" {
  name         = "vaultwarden/server:latest"
  keep_locally = true
}

resource "docker_volume" "vaultwarden_volume" {
  name = "${var.remote_username}_vaultwarden_data"
}

resource "docker_container" "vaultwarden" {
  image    = docker_image.vaultwarden.image_id
  name     = "vaultwarden"
  hostname = "vaultwarden"
  env      = ["TZ=${var.timezone}","SIGNUPS_ALLOWED=${var.signup_allowed}","ADMIN_TOKEN=${var.vault_admin_token}"]
  volumes {
    container_path = "/data"
    volume_name    = docker_volume.vaultwarden_volume.name
    host_path      = "/home/${var.remote_username}/vaultwarden_home"
  }
  ports {
    internal = 80
    external = 9202
  }
  restart = "unless-stopped"
}

output "container_info" {
  value = {
    "id" : docker_container.vaultwarden.id,
    "name" : docker_container.vaultwarden.name
  }
}