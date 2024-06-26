#!/bin/bash
##### MAKE SURE TO RUN THIS SCRIPT WITH ROOT PRIVILEGE #####
## This script will create a new user with necessary roles in proxmox-ve and also generates an api token
## Make sure to copy down the api-token generated by this script


# provider your variable
newRoleName=provisioner-role
newRoles="Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify"
newUser=provisioner@pve

# create a role
pveum role add $newRoleName -privs "$newRoles"


# Create a user
pveum user add $newUser


# assign the role to user
pveum aclmod / -user $newUser -role $newRoleName

# generate api token for the user 
pveum user token add $newUser provider --privsep=0
