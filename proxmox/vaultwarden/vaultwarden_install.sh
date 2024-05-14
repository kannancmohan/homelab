#!/bin/bash

terraform -chdir=./container_provisioning apply --auto-approve &&

ansible-playbook -i ./configuration/inventories/proxmox-inventory.proxmox.yml ./configuration/main-playbook.yml
