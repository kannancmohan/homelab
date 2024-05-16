#!/bin/bash

terraform -chdir=./dockerinstance/provisioning apply --auto-approve &&

ansible-playbook -i ./dockerinstance/configuration/inventories/proxmox-inventory.proxmox.yml ./dockerinstance/configuration/main-playbook.yml
