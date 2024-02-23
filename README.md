# Proxmox homelab setup
Project to automatically create the following vm's in proxmox server 
| VM            | Cores         | Memory| Disk|
| ------------- |:-------------:| -----:| -----:|
| master        | 2             | 2048  | 50G   |
| worker1       | 1             | 1024  | 15G   |
| worker2       | 1             | 1024  | 15G   |

## Prerequisite:
* A running proxmox server. check [proxmox installation steps](proxmox_installation.md)
* ssh access to the proxmox server

## Objectiv:
1. Download ubuntu cloud image server image 
2. Modify the downloaded image to include addition configuration
    1. Install qemu-guest-agent
    2. Update root password
    3. [Optional] Create a new user and import local ssh key
4. Create a new vm in proxmox 
