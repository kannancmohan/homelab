#!/bin/bash

terraform -chdir=./vm_provisioning apply --auto-approve &&

ansible-playbook -i ./adguard_configuration/inventories/proxmox-inventory.proxmox.yml ./adguard_configuration/main-playbook.yml
