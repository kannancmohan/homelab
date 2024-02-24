#!/bin/bash
##### MAKE SURE TO RUN THIS SCRIPT WITH ROOT PRIVILEGE #####

. $(dirname "$0")/config.sh

# for more options check https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
# create a new role in pve for terraform
pveum role add $terraformRole -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"


# There are 2 options to connect terraform to proxmox
if [ -n "$terraformUserPwd" ]; then
    # Option 1: Creating a user with password and connect terraform using this this username and password
    pveum user add $terraformUser --password $terraformUserPwd
    # add user to the role
    pveum aclmod / -user $terraformUser -role $terraformRole
else
    # Option 2: Creating a user and connect terraform using username and API token
    pveum user add $terraformUser
    # add user to the role
    pveum aclmod / -user $terraformUser -role $terraformRole
    # generate authentication token 
    pveum user token add $terraformUser terraform-token --privsep=0
fi
