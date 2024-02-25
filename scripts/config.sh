#!/bin/bash

executionDir='/var/lib/vz/template/iso/'
isoFileName='updated-jammy-server-cloudimg-amd64.img'
isoFileUrl='https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img'
# comment out vmRootPassword, if you dont update root password of the vm
vmRootPassword='pwd@123'
localSshKey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWmuxBWj5GebJtC5sp4kfUGdodLswXVxj9Vrzauf63B kannanmohanklm@gmail.com'

# comment out vmNewUser, if you dont want to create a new user in vm
vmNewUser='vmuser'
vmId='9000'
vmName='ubuntu-jammy-server'
vmMemeory='1024'
vmCore='1'
vmDiskSize='15G'
vmNetworkCardModel='virtio' #The virtio model provides the best performance with very low CPU overhead. If your guest does not support this driver, it is usually best to use e1000.
vmNetworkBridge='vmbr0' #Bridge to which the network device should be attached. The Proxmox VE standard bridge is called vmbr0
localDisk='local-lvm'


# terraform config
terraformRole=terraform-role
terraformUser=terraform@pve
terraformUserPwd=
