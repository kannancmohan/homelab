#!/bin/bash

executionDir="/var/lib/vz/template/iso/" # nodes(proxmox) storage folder
updatedIsoFileName="updated-jammy-server-cloudimg-amd64.img"
isoFileUrl="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
vmRootPassword="pwd@123"

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

#echo ">>>Update the machine-id in image<<<"
#virt-customize -a $updatedIsoFileName --run-command "echo -n > /etc/machine-id"


# not quite working yet. skip this and continue
#sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'useradd austin'
#sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'mkdir -p /home/austin/.ssh'
#sudo virt-customize -a focal-server-cloudimg-amd64.img --ssh-inject austin:file:/home/austin/.ssh/id_rsa.pub
#sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'chown -R austin:austin /home/austin'

# OR 
#sudo virt-sysprep -a CentOS-7-x86_64-GenericCloud.qcow2 --run-command 'useradd vivek' --ssh-inject vivek:file:/home/vivek/.ssh/id_rsa.pub


echo ">>>Updated image:$updatedIsoFileName available in $executionDir <<<"
