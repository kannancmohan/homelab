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

resource "docker_image" "portainer" {
  name         = "portainer/portainer-ce:2.20.2"
  keep_locally = true
}

resource "docker_volume" "portainer_volume" {
  name = "${var.remote_username}_portainer_data"
}

resource "docker_container" "portainer" {
  image    = docker_image.portainer.image_id
  name     = "portainer"
  hostname = "portainer"
  # env      = ["TZ=${var.timezone}"]

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
    read_only      = true
  }
  volumes {
    container_path = "/data"
    volume_name    = docker_volume.portainer_volume.name
    host_path      = "/home/${var.remote_username}/portainer_home"
  }
  ports {
    internal = 9443
    external = 9443
  }
  restart = "unless-stopped"
}

output "container_info" {
  value = {
    "id" : docker_container.portainer.id,
    "name" : docker_container.portainer.name
  }
}