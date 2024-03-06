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

### Tools Version
| Tools                             | Version       |
| --------------------------------- |:-------------:|
| Proxmox VE                        | 8.1.4         |
| Terraform                         | 1.7.4         |
| Terraform provider 'bpg/proxmox'  | 0.47.0        |
| OS for vm                         | Ubuntu 22.04  |

### Prerequisite:
* A running proxmox server. check [proxmox installation steps](proxmox_installation.md)
* ssh access to the proxmox server
* terraform installed in local/development machine. check [official site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 

### Project setup //TODO add steps for environment variable 
1. Setup new user in proxmox for the terraform [provider](https://registry.terraform.io/providers/bpg/proxmox)

    1.1 Execute the [script](scripts/create_role_and_user_in_proxmox.sh) in proxmox server using a sudo user . 

    Important*: please note down the api-token generated after running the above script.

    Alternately you could use the proxmox gui to create a user with necessary role mentioned [here](https://registry.terraform.io/providers/bpg/proxmox/latest/docs#api-token-authentication)

    1.2 set environment variable PROXMOX_VE_API_TOKEN using the api-token from above step

    eg:
    ```
    export PROXMOX_VE_API_TOKEN="provisioner@pve!provider=c97a9b12-80b6-4193-8baa-9991a23084d9"
    ```

    1.3 Configure ssh connection for terraform provider
    The bpg terraform provider requires a ssh connection to the target proxmox node without the need to pass in the password. For this you need copy your local machine's ssh pub key(ssh public key of the machine from where you run the terraform script) to a sudo privilege user in the target node. 

    To copy local ssh key to proxmox you can use the ssh-copy-id command ``ssh-copy-id -i  <location-to-the-pub-file> <proxmox_server_user@1proxmox_server_ip>``
    
    eg:
    ```
    ssh-copy-id -i  ~/.ssh/id_ed25519.pub root@192.168.0.50
    ```
    When using a non-root user for the SSH connection, the user must have the sudo privilege on the target node without requiring a password. Check the steps mentioned [here](https://registry.terraform.io/providers/bpg/proxmox/latest/docs#ssh-user)

2. Enable snippet storage in proxmox server
    log into the proxmox server and add the snippet option to the list 
    Datacenter >> Storage >> select your storage(eg:local)>>click edit and include snippet in the dropdown named 'Content'

3. Setup for ansible:  check setup section in ansible [readme](proxmox/k8s-environment-setup/ansible/README.md) file 

4. [Optional] Update your local/development machines '~/.ssh/config' file to skip ssh strong checks on local ip's

    ```
    Host 192.168.*.*
    #suppresses warnings about spoofing and stops the long pause when there's no host file
    CheckHostIP no
    #skip prompt about connecting anyway if the authenticity of the remote machine is in question
    StrictHostKeyChecking no
    #removes the annoying message about adding the host to the list of known hosts
    #LogLevel=quiet
    #stops the creation of a known_hosts file
    UserKnownHostsFile=/dev/null
    ```

### Executing the provisioning 

1. Execute terraform script for provision the vm's . 

check execution steps mentioned [here](/proxmox/vm-provisioning/README.md#executing-the-provisioning) 

## Authors

* kannan

## Version History

* 0.1
    * Initial Release

## License


## Acknowledgments

* [Inspiration](https://blog.andreasm.io/2024/01/15/proxmox-with-opentofu-kubespray-and-kubernetes/)
