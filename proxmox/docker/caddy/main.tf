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

locals {
  env_var_from_file  = yamldecode(file("${path.module}/configs/caddy_env_variables.yaml"))
  additional_env_var = ["DUCKDNS_API_TOKEN=${var.duckdns_token}"]
  env_var            = concat([for k, v in local.env_var_from_file : "${k}=${v}"], local.additional_env_var)
}


resource "docker_image" "caddy" {
  name         = "caddy"
  keep_locally = true
  build {
    context    = path.module
    dockerfile = "configs/Dockerfile"
  }
}

resource "docker_volume" "caddy_volume" {
  name = "${var.remote_username}_caddy_data"
}

resource "docker_container" "caddy" {
  image    = docker_image.caddy.image_id
  name     = "caddy"
  hostname = "caddy"

  upload {
    source = "${path.module}/configs/Caddyfile"
    file   = "/etc/caddy/Caddyfile"
  }

  upload {
    source = "${path.module}/configs/index.html"
    file   = "/etc/caddy/www/index.html"
  }


  # volumes {
  #   host_path      = "${path.module}/configs/Caddyfile"
  #   container_path = "/etc/caddy/Caddyfile"
  #   read_only      = true
  # }

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.caddy_volume.name
    host_path      = "/home/${var.remote_username}/caddy_home"
  }
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }
  env     = local.env_var
  restart = "unless-stopped"
}

output "container_info" {
  value = {
    "id" : docker_container.caddy.id,
    "name" : docker_container.caddy.name
  }
}