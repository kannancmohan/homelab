# Proxmox homelab setup
Project to automatically create the following vm's in proxmox server 
| VM            | Cores         | Memory| Disk|
| ------------- |:-------------:| -----:| -----:|
| master        | 2             | 2gb   | 50    |
| worker1       | 1             | 1gb   | 15    |
| worker2       | 1             | 1gb   | 15    |
## Steps:
1. Download ubuntu cloud image server image 
2. Modify the downloaded image to include addition configuration
    1. Install qemu-guest-agent
    2. Update root password
    3. [Optional] Create a new user and import local ssh key
4. Create a new vm in proxmox 

    