#!/bin/bash

terraform -chdir=k8s/cluster_setup/k3s/vm_provisioning destroy --auto-approve
