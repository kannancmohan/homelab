terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.6"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_endpoint

  ## api_token value is set using environment variable PROXMOX_VE_API_TOKEN
  #api_token = var.proxmox_api_token

  insecure = true
  ssh {
    agent = true
    # If we are authorizing via API Token, then 'username' is required. because the provider needs to know which PAM user to use for the SSH connection
    username = var.provider_terraform_user_name
  }
}