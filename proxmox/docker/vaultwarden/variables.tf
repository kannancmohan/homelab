# ssh 
variable "remote_username" {
  type = string
}
variable "remote_ssh_ip" {
  type = string
}
variable "remote_ssh_port" {
  type = number
}

variable "timezone" {
  type    = string
  default = "Europe/Berlin"
}

variable "signup_allowed" {
  type    = bool
  default = false
}
variable "vault_admin_token" {
  type    = string
  sensitive = true
}