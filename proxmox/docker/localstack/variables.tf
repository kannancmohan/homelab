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

variable "default_region" {
  type    = string
  default = "us-east-2"
}