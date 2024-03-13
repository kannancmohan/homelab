provider "proxmox" {
  # make sure to set value for variable 'proxmox_api_endpoint' as environment variable using "TF_VAR_proxmox_api_endpoint=your-api-endpoint"
  endpoint = var.proxmox_api_endpoint

  ## api_token value is set using environment variable PROXMOX_VE_API_TOKEN
  #api_token = var.proxmox_api_token
  insecure = true
  ssh {
    agent = true
    # If we are authorizing via API Token, then 'username' is required. because the provider needs to know which PAM user to use for the SSH connection
    username = "root" # can be set via environment variable PROXMOX_VE_SSH_USERNAME
  }
}