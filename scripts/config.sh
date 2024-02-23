#!/bin/bash

executionDir='/var/lib/vz/template/iso/'
isoFileName='updated-jammy-server-cloudimg-amd64.img'
isoFileUrl='https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img'
vmRootPassword='pwd@123'
# comment out vmNewUser, if you dont want to create a new user in vm
vmNewUser='vmuser'
vmId='9000'
vmName='ubuntu-jammy-server'
vmMemeory='1024'
vmCore='1'
vmDiskSize='15G'
localDisk='local-lvm'
