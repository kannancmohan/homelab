# Proxmox Provider
terraform {

  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "= 3.0.1-rc1"
    }
  }
}

provider "proxmox" {

  pm_api_url = var.proxmox_api_url
  # pm_api_token_id and pm_api_token_secret is set via environment variables
  #pm_api_token_id = var.proxmox_api_token_id
  #pm_api_token_secret = var.proxmox_api_token_secret

  # (Optional) Skip TLS Verification
  # pm_tls_insecure = true

  ## For logging
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }

}