#!/bin/bash

terraform -chdir=./vm_provisioning apply --auto-approve &&

# ansible-playbook -i ./configuration/inventories/proxmox-inventory.proxmox.yml ./configuration/main-playbook.yml
