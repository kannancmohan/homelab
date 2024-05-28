#!/bin/bash

ansible-playbook -i k8s/cluster_setup/k3s/k8s_configuration/inventories/proxmox-inventory.proxmox.yml k8s/cluster_setup/k3s/k8s_configuration/k3s-uninstall.yml
