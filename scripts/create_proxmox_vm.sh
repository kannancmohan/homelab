#!/bin/bash

executionDir="/var/lib/vz/template/iso/" # nodes(proxmox) storage folder
isoFileName="updated-jammy-server-cloudimg-amd64.img"
vmId=9000
vmName=ubuntu-jammy-server
vmMemeory=2048
vmCore=2
vmDiskSize=50G
localDisk=local-lvm


echo ">>>Creating vm out of image" $updatedIsoFileName "<<<"

# CD to proxmox image storage folder 
cd $executionDir &&

# create a new vm
qm create $vmId --name "$vmName" --memory $vmMemeory --cores $vmCore --net0 virtio,bridge=vmbr0 &&
qm importdisk $vmId $isoFileName $localDisk &&
qm set $vmId --scsihw virtio-scsi-pci --scsi0 $localDisk:vm-$vmId-disk-0 &&
qm set $vmId --boot c --bootdisk scsi0 &&
qm set $vmId --ide2 $localDisk:cloudinit &&
qm set $vmId --serial0 socket --vga serial0 &&
qm set $vmId --agent enabled=1 &&
qm resize $vmId scsi0 +$vmDiskSize &&

echo ">>>Created vm:$vmName out of image" $updatedIsoFileName "<<<"
#qm resize 9000 scsi0 +50G &&
#qm template 9000