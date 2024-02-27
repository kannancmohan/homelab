# Proxmox Homelab Setup
Project to automatically create the following vm's in proxmox server 

| VM            | Cores         | Memory| Disk|
| ------------- |:-------------:| -----:| -----:|
| master        | 2             | 2048  | 50G   |
| worker1       | 1             | 1024  | 15G   |
| worker2       | 1             | 1024  | 15G   |

## Prerequisite:
* A running proxmox server. check [proxmox installation steps](proxmox_installation.md)
* ssh access to the proxmox server
* Enable snippet storage in proxmox server(Datacenter >> Storage >> select your storage(eg:local)>>click edit and include snippet)
* terraform installed in local/development machine . check [official site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 
* create a new user called "terraform" in proxmox - use this '[script](scripts/create_terraform_role_and_user.sh)'
    This user is required for the terraform provider
* Adding sudo privilege for the above user, so that the provider can seamlessly provision . check https://registry.terraform.io/providers/bpg/proxmox/latest/docs#ssh-user


## The automation process 
1. Automatically create a VM in proxmox and converting it to a template
    
    1.1 Download ubuntu-cloud image and modify it to include addition configuration

        1.1.1 Install qemu-guest-agent

        1.1.2 Update root password

        1.1.3 [Optional] Create a new user and import local ssh key

    1.2 Create a new vm in proxmox and convert it to a vm template 

2. Automatically create a terraform user in proxmox and generate api-token credentials

    2.1 create a new role for terraform in proxmox

    2.2 create a new user for terraform and assign it to the above role

    2.3 generate api-token credentials   

3. Automatically create the desired vm using the vm template 

## Steps to Build 

