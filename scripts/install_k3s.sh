#!/bin/bash

#export K3S_VERSION="v1.29.3-rc1+k3s1"
export K3S_VERSION="v1.28.7+k3s1"
## set the following to set flannel or calico
export CNI_PLUGIN="flannel"
## set the following to set nginx or traefik
export INGRESS_CONTROLLER="traefik"

DISABLE_K3S_OOTB_TRAEFIK=true
K3S_PROJECT_DIR="k8s/cluster_setup/k3s/vm_provisioning"
ADDITIONAL_CONFIG="--write-kubeconfig-mode 644"
EXPOSE_METRICS=false

## TODO for exposing metrics which prometheus could scrape
if [ "$EXPOSE_METRICS" == true ]; then
    ADDITIONAL_CONFIG="${ADDITIONAL_CONFIG} --etcd-expose-metrics \
    --kube-proxy-arg="metrics-bind-address=0.0.0.0" \
    --kube-controller-manager-arg="address=0.0.0.0" --kube-controller-manager-arg="bind-address=0.0.0.0" \
    --kube-scheduler-arg="bind-address=0.0.0.0" --kube-scheduler-arg="address=0.0.0.0""
fi

## if cni-plugin is calico then disable ootb flannel
if [ "${CNI_PLUGIN}" = "calico" ]; then
    ADDITIONAL_CONFIG="${ADDITIONAL_CONFIG} --flannel-backend=none --disable-network-policy"
fi

## if ingress is nginx then disable ootb traefik
if [ "${INGRESS_CONTROLLER}" = "nginx" ] || [ "$DISABLE_K3S_OOTB_TRAEFIK" == true ]; then
    ADDITIONAL_CONFIG="${ADDITIONAL_CONFIG} --disable=traefik --disable=metrics-server"
fi

export K3S_CP_ADDITIONAL_CONFIG="$ADDITIONAL_CONFIG"

## proxmox values
PROXMOX_NODE_NAME="node1-home-network"
PROXMOX_NODE_ISO_DATASOURCE_ID="local"
PROXMOX_NODE_DEFAULT_DATASOURCE_ID="local-lvm"
PROXMOX_K3S_CONTROL_PLANE_ID_PREFIX=200
PROXMOX_K3S_CONTROL_PLANE_IP_PREFIX="192.168.0.6"
PROXMOX_K3S_WORKER_VM_ID_PREFIX=300
PROXMOX_K3S_WORKER_VM_IP_PREFIX="192.168.0.8"
PROXMOX_K3S_GATEWAY_IP="192.168.0.1"


if [ ! -d "${K3S_PROJECT_DIR}/.terraform" ]; then
    terraform -chdir=$K3S_PROJECT_DIR init
fi
terraform -chdir=$K3S_PROJECT_DIR apply --auto-approve -var proxmox_node_name="${PROXMOX_NODE_NAME}" \
    -var proxmox_node_iso_datastore_id="${PROXMOX_NODE_ISO_DATASOURCE_ID}" \
    -var proxmox_node_default_datastore_id="${PROXMOX_NODE_DEFAULT_DATASOURCE_ID}" \
    -var cp_vm_id_prefix="${PROXMOX_K3S_CONTROL_PLANE_ID_PREFIX}" \
    -var worker_vm_id_prefix="${PROXMOX_K3S_WORKER_VM_ID_PREFIX}" \
    -var cp_vm_ip_prefix="${PROXMOX_K3S_CONTROL_PLANE_IP_PREFIX}" -var worker_vm_ip_prefix="${PROXMOX_K3S_WORKER_VM_IP_PREFIX}" \
    -var cp_vm_gateway_ip="${PROXMOX_K3S_GATEWAY_IP}" -var worker_vm_gateway_ip="${PROXMOX_K3S_GATEWAY_IP}" &&

ansible-playbook -i k8s/cluster_setup/k3s/k8s_configuration/inventories/proxmox-inventory.proxmox.yml k8s/cluster_setup/k3s/k8s_configuration/main-playbook.yml
