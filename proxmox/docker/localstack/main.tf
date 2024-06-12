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

resource "docker_image" "localstack" {
  name         = "localstack/localstack:latest"
  keep_locally = true
}

resource "docker_volume" "localstack_volume" {
  name = "${var.remote_username}_localstack_data"
}

resource "docker_container" "localstack" {
  image    = docker_image.localstack.image_id
  name     = "localstack"
  hostname = "localstack"
  env      = ["DEFAULT_REGION=${var.default_region}"]

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
    read_only      = true
  }

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.localstack_volume.name
    host_path      = "/home/${var.remote_username}/localstack_home"
  }

  ports {
    internal = 4566
    external = 4566
  }

  # ports {
  #   internal = 4510-4559
  #   external = 4510-4559
  # }

  restart = "unless-stopped"
}

output "container_info" {
  value = {
    "id" : docker_container.localstack.id,
    "name" : docker_container.localstack.name
  }
}