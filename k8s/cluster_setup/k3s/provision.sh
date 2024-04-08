#!/bin/bash

#export K3S_VERSION="v1.29.3-rc1+k3s1"
export K3S_VERSION="v1.28.7+k3s1"

## set the following to either ngnix or traefik
export INGRESS_CONTROLLER="traefik"
## set the following to either flannel or calico
export CNI_PLUGIN="flannel"

ADDITIONAL_CONFIG="--write-kubeconfig-mode 644"

if [ "${CNI_PLUGIN}" = "calico" ]; then
    ADDITIONAL_CONFIG="${ADDITIONAL_CONFIG} --flannel-backend=none --disable-network-policy"
fi

## install calico and also disable traefik(ingress-controller)
if [ "${INGRESS_CONTROLLER}" = "ngnix" ]; then
    ADDITIONAL_CONFIG="${ADDITIONAL_CONFIG} --disable=traefik"
fi


export K3S_CP_ADDITIONAL_CONFIG="$ADDITIONAL_CONFIG"

terraform -chdir=./vm_provisioning apply --auto-approve &&

ansible-playbook -i ./k8s_configuration/inventories/proxmox-inventory.proxmox.yml ./k8s_configuration/main-playbook.yml
