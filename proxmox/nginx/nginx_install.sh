#!/bin/bash
# PROXMOX_NODE_NAME="node1-home-network"
# PROXMOX_NODE_TEMPLATE_DATASTORE_ID="local"
# PROXMOX_NODE_DEFAULT_DATASTORE_ID="local-lvm"
# CONTAINER_NAME="nginx-container"
# CONTAINER_IP="192.168.0.23"
# CONTAINER_GATEWAY_IP="192.168.0.1"

terraform -chdir=./container_provisioning apply --auto-approve &&

ansible-playbook -i ./configuration/inventories/proxmox-inventory.proxmox.yml ./configuration/main-playbook.yml
