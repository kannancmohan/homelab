#!/bin/bash

ansible-playbook -i $PROXMOX_VE_ENDPOINT_IP, main-playbook.yml
