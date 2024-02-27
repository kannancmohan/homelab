#!/bin/bash
##### MAKE SURE TO RUN THIS SCRIPT WITH ROOT PRIVILEGE #####


# terraform config
terraformRole=terraform-role
terraformUser=terraform@pve

# Create a user
pveum user add $terraformUser

# create a role
pveum role add $terraformRole -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify"

# assign the role to user
pveum aclmod / -user $terraformUser -role $terraformRole

# generate api token for the user 
pveum user token add $terraformUser provider --privsep=0
