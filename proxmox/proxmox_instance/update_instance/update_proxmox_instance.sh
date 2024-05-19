#!/bin/bash

ansible-playbook -i $PROXMOX_VE_ENDPOINT_IP, main-playbook.yml --extra-vars "ansible_user=${PROXMOX_VE_SSH_USER}"
