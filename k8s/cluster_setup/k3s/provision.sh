#!/bin/bash

export K3S_VERSION="v1.29.3-rc1+k3s1"
#terraform -chdir=./infra init
terraform -chdir=./vm_provisioning apply --auto-approve &&

ansible-playbook -i ./k8s_configuration/inventories/proxmox-inventory.proxmox.yml ./k8s_configuration/main-playbook.yml
