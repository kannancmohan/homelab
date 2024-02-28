# Proxmox Homelab Setup
Project to automatically create virtual machine's in proxmox server.

## Description
Automatically provision 3 vm's in proxmox with the following configuration

| VM            | Cores         | Memory| Disk|
| ------------- |:-------------:| -----:| -----:|
| master        | 2             | 4096  | 25G   |
| worker1       | 1             | 2048  | 15G   |
| worker2       | 1             | 2048  | 15G   |

## Getting Started

### Prerequisite:
* A running proxmox server. check [proxmox installation steps](proxmox_installation.md)
* ssh access to the proxmox server
* Enable snippet storage in proxmox server

    (Datacenter >> Storage >> select your storage(eg:local)>>click edit and include snippet)

* terraform installed in local/development machine. check [official site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 
* create a new user called "terraform" in proxmox.

    Run [script](scripts/create_terraform_role_and_user.sh) in proxmox server to create terraform. This user is required for the terraform provider

* Add sudo privilege for the above user so that the provider can run seamlessly. [check](https://registry.terraform.io/providers/bpg/proxmox/latest/docs#ssh-user)

### Installing

### Executing program

* How to run the program
* Step-by-step bullets
```
code blocks for commands
```

## Authors

* kannan

## Version History

* 0.1
    * Initial Release

## License


## Acknowledgments

* [Inspiration](https://blog.andreasm.io/2024/01/15/proxmox-with-opentofu-kubespray-and-kubernetes/)


