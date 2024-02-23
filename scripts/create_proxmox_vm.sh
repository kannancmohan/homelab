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

### Create a new vm ###
qm create $vmId --name "$vmName" --memory $vmMemeory --cores $vmCore --net0 virtio,bridge=vmbr0 &&
# Import the downloaded Ubuntu disk to the correct storage:
qm importdisk $vmId $isoFileName $localDisk &&
# Attach the new disk as a SCSI drive on the SCSI Controller
qm set $vmId --scsihw virtio-scsi-pci --scsi0 $localDisk:vm-$vmId-disk-0 &&
# Make the could init drive bootable and restrict BIOS to boot from disk only:
qm set $vmId --boot c --bootdisk scsi0 &&
# Add cloud init drive:
qm set $vmId --ide2 $localDisk:cloudinit &&
# Add serial console
qm set $vmId --serial0 socket --vga serial0 &&
# Turn on guest agent
qm set $vmId --agent enabled=1 &&
# Resize disk
qm resize $vmId scsi0 +$vmDiskSize &&

echo ">>>Created vm:$vmName out of image" $updatedIsoFileName "<<<"
