#!/bin/bash

executionDir="/var/lib/vz/template/iso/" # nodes(proxmox) storage folder
updatedIsoFileName="updated-jammy-server-cloudimg-amd64.img"
isoFileUrl="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
vmRootPassword="pwd@dq3"

echo ">>>Preparing ubuntu cloud image" $isoFileUrl "<<<"

# CD to proxmox image storage folder 
cd $executionDir

echo ">>>Download iso image<<<"
wget -O $updatedIsoFileName $isoFileUrl &&

echo ">>>Install package "libguestfs-tools" for customising the downloaded image file<<<"
apt update -y && apt install libguestfs-tools -y &&

echo ">>>Install qemu-guest-agent to update image<<<"
virt-customize -a $updatedIsoFileName --install qemu-guest-agent

echo ">>>Update the root password in image<<<"
virt-customize -a $updatedIsoFileName --root-password password:$vmRootPassword &&

echo ">>>Update the machine-id in image<<<"
virt-customize -a $updatedIsoFileName --run-command "echo -n > /etc/machine-id"

echo ">>>Updated image:$updatedIsoFileName available in $executionDir <<<"
