# Proxmox installation steps

## Proxmox system requirement: 
|            |                                                                            |
|------------|----------------------------------------------------------------------------|
|CPU         | 64bit (Intel EMT64 or AMD64)                                               |
|Mother board| Intel VT/AMD-V capable CPU/motherboard for KVM full virtualization support |
|RAM         | 1 GB + additional RAM needed for guests                                    |
|Hard disk   | proxmox itself need around 8gb + additional for guest                       |
|Network     | 1 network card                                                             |

*check official [doc](https://pve.proxmox.com/wiki/System_Requirements)

## Steps:
1. Download the proxmox-ve iso file

    https://www.proxmox.com/en/downloads/proxmox-virtual-environment
2. Create a bootable usb using the above image file

    Mac users can use balena-etcher to burn bootable usb
3. Boot the system using the above bootable usb

    Restart the machine and hold F11(usually its F11) or F12 to access the boot menu
 4. When proxmox installation wizard starts, select the option "Install Proxmox VE (Graphical)" and fill the details 

    > [!NOTE]
    > Make sure to note down the user password provided during installation

    Sample configuration 
    |               |                        |
    | ------------- |:----------------------:|
    | Host name     | node1-home-network     |
    | Ip address    | 192.168.0.50           |
    | Gateway       | 192.168.0.1            |
    | DNS           | 192.168.0.1            |

    > [!NOTE]
    > Make sure to use an Ip address that is not taken. Login to your router ui to check which all ip's are taken
5. After installing proxmox, login to proxmox webui and install updates available for the node.

    5.1 Login to proxmox web-ui(https://192.168.0.50:8006)

    5.2 Disable (both) enterprise repos 
        From Datacenter>Node>Updates>Repositories, click both the Enterprise repos and Disable it

    5.3 Back in 'updates' tab >> select “refresh” button >> it will list all the updates available >> click the “Upgrade” button

    5.4 Reboot the node >> select the node and click the “reboot” button
6.  Try ssh to the newly created proxmox node

    ```    ssh root@192.168.0.50     ```

## Proxmox Upgrade 
Upgrade via gui(node > updates) or use the following command
```
apt update && apt dist-upgrade -y
```

