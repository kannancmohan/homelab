#!/bin/bash

#export K3S_VERSION="v1.29.3-rc1+k3s1"
export K3S_VERSION="v1.28.7+k3s1"

## set the following for enabling calico cni instead of ootb flannel
export INSTALL_CALICO=true
## install calico and also disable traefik(ingress-controller)
if [ "${INSTALL_CALICO}" = true ]; then
    export K3S_CP_ADDITIONAL_CONFIG="--write-kubeconfig-mode 644 --flannel-backend=none --disable-network-policy --disable=traefik"
fi

terraform -chdir=./vm_provisioning apply --auto-approve &&

ansible-playbook -i ./k8s_configuration/inventories/proxmox-inventory.proxmox.yml ./k8s_configuration/main-playbook.yml
