#!/bin/bash

## IMPORTANT: update vaultwarden docker-image version(vaultwarden_docker_image) in /configuration/vars/default.yaml

ansible-playbook -i ./configuration/inventories/proxmox-inventory.proxmox.yml ./configuration/main-playbook.yml
