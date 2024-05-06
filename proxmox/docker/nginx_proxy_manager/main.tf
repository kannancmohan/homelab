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

resource "docker_image" "nginx_proxy_manager" {
  name         = "jc21/nginx-proxy-manager:latest"
  keep_locally = true
}

resource "docker_volume" "nginx_proxy_manager_volume" {
  name = "${var.remote_username}_nginx_proxy_manager_data"
}

resource "docker_container" "nginx_proxy_manager" {
  image    = docker_image.nginx_proxy_manager.image_id
  name     = "nginx_proxy_manager"
  hostname = "nginx_proxy_manager"
  # env      = ["TZ=${var.timezone}"]
  volumes {
    container_path = "/data"
    volume_name    = docker_volume.nginx_proxy_manager_volume.name
    host_path      = "/home/${var.remote_username}/nginx_proxy_manager_home"
  }
  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  ports {
    # Admin Web Port
    internal = 81
    external = 81
  }

  restart = "unless-stopped"
}

output "container_info" {
  value = {
    "id" : docker_container.nginx_proxy_manager.id,
    "name" : docker_container.nginx_proxy_manager.name
  }
}