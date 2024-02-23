#!/bin/bash

executionDir="/var/lib/vz/template/iso/" # nodes(proxmox) storage folder
updatedIsoFileName="updated-jammy-server-cloudimg-amd64.img"
isoFileUrl="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
vmRootPassword="pwd@123"
vmNewUser=vmuser

echo ">>>Preparing ubuntu cloud image" $isoFileUrl "<<<"

# CD to proxmox image storage folder 
cd $executionDir &&

# remove existing image in case last execution did not complete successfully
rm $updatedIsoFileName &&

echo ">>>Download iso image<<<"
wget -O $updatedIsoFileName $isoFileUrl &&

echo ">>>Install package "libguestfs-tools" for customising the downloaded image file<<<"
apt update -y && apt install libguestfs-tools -y &&

echo ">>>Install qemu-guest-agent to update image<<<" &&
virt-customize -a $updatedIsoFileName --install qemu-guest-agent &&

echo ">>>Update the root password in image<<<"
virt-customize -a $updatedIsoFileName --root-password password:$vmRootPassword &&

# [Optional step] - create a new user and import your local machine's ssh key, so that you can access this vm without password
echo ">>> creating a new user and import your local machines ssh public key to this image<<<"
virt-customize -a $updatedIsoFileName --run-command "useradd $vmNewUser" && 
virt-customize -a $updatedIsoFileName --run-command "mkdir -p /home/$vmNewUser/.ssh" && 

## inject your local ssh key directly from local folder ##
#virt-customize -a $updatedIsoFileName --ssh-inject $vmNewUser:file:$HOME/.ssh/id_rsa.pub &&
## OR inject your local ssh key directly as string ##
virt-customize -a $updatedIsoFileName --ssh-inject "$vmNewUser:string:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWmuxBWj5GebJtC5sp4kfUGdodLswXVxj9Vrzauf63B kannanmohanklm@gmail.com" &&

virt-customize -a $updatedIsoFileName --run-command "chown -R $vmNewUser:$vmNewUser /home/$vmNewUser" &&

#echo ">>>Update the machine-id in image<<<"
#virt-customize -a $updatedIsoFileName --run-command "echo -n > /etc/machine-id"

echo ">>>Updated image:$updatedIsoFileName available in $executionDir <<<"
