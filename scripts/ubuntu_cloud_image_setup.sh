#!/bin/bash
##### MAKE SURE TO RUN THIS SCRIPT WITH ROOT PRIVILEGE #####

. $(dirname "$0")/config.sh


echo ">>>Preparing ubuntu cloud image" $isoFileUrl "<<<"

# CD to proxmox image storage folder 
cd $executionDir &&

# remove existing image in case last execution did not complete successfully
rm $isoFileName &&

echo ">>>Downloading iso image<<<"
wget -O $isoFileName $isoFileUrl &&

echo ">>>Installing package "libguestfs-tools" for customising the downloaded image file<<<"
apt update -y && apt install libguestfs-tools -y &&

echo ">>>Installing qemu-guest-agent to update image<<<" &&
virt-customize -a $isoFileName --install qemu-guest-agent &&

if [ -n "$vmRootPassword" ]; then
    echo ">>>Updating the root password in image<<<"
    virt-customize -a $isoFileName --root-password password:$vmRootPassword
fi

# [Optional step] - create a new user and import your local machine's ssh key, so that you can access this vm without password
if [ -n "$vmNewUser" ]; then
    echo ">>> creating a new user and import your local machines ssh public key to this image<<<"
    virt-customize -a $isoFileName --run-command "useradd $vmNewUser" && 
    virt-customize -a $isoFileName --run-command "mkdir -p /home/$vmNewUser/.ssh" && 

    ## inject your local ssh key directly from local folder ##
    #virt-customize -a $isoFileName --ssh-inject $vmNewUser:file:$HOME/.ssh/id_rsa.pub &&
    ## OR inject your local ssh key directly as string ##
    virt-customize -a $isoFileName --ssh-inject "$vmNewUser:string:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWmuxBWj5GebJtC5sp4kfUGdodLswXVxj9Vrzauf63B kannanmohanklm@gmail.com" &&

    virt-customize -a $isoFileName --run-command "chown -R $vmNewUser:$vmNewUser /home/$vmNewUser"
fi


#echo ">>>Update the machine-id in image<<<"
#virt-customize -a $isoFileName --run-command "echo -n > /etc/machine-id"

echo ">>>Updated image:$isoFileName available in $executionDir <<<"
