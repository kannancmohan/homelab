#!/bin/bash

## Create new namespace "argocd"
kubectl create namespace argocd --dry-run=client --output=yaml | kubectl apply -f - &&

## Install argocd
helm template \
        --dependency-update --include-crds --namespace argocd \
        argocd ./k8s/cluster_apps/bootstrap/argocd \
        | kubectl apply -n argocd -f - &&

## Wait for argocd server 
echo 'Waiting for argocd server to start..' 
kubectl wait -n argocd  --timeout=120s --for condition=Ready pod -l app.kubernetes.io/name=argocd-server &&

## create argocd resource Project and ApplicationSet
helm template --namespace argocd argocd ./k8s/cluster_apps/bootstrap/root | kubectl apply -n argocd -f - &&

# echo "Creating keycloak secret..."
# kubectl create secret generic keycloak-credentials-secret --from-literal=admin-password="identity@keycloak" --from-literal=postgres-password="identity@keycloak" --from-literal=password="identity@keycloak" --namespace keycloak


# TODO replace this
echo "Create bitwarden-cli namespace and secret " &&
kubectl create namespace bitwarden-cli --dry-run=client --output=yaml | kubectl apply -f - &&
kubectl create secret generic bitwarden-cli --from-literal=BW_HOST="${VAULTWARDEN_HOST_URl}" --from-literal=BW_USERNAME="${VAULTWARDEN_K8S_USER}" --from-literal=BW_PASSWORD="${VAULTWARDEN_K8S_PWD}" --namespace bitwarden-cli

# echo "Creating grafana-credential secret "
# kubectl create secret generic grafana-credential --from-literal=admin-user="admin@grafana.com" --from-literal=admin-password="Admin@grafana123.com" --from-literal=GRAFANA_SSO_CLIENT_SECRET="264760171249599008@testproject" --namespace grafana

# echo "Creating cloudnative-pg secret..."
# kubectl create secret generic cnpg-superuser-secret --namespace=cloudnative-pg --from-literal=username="postgres" --from-literal=password="postgres@adminz" --from-literal=pgpass="postgres@adminz"

# echo "Creating zitadel secret..."
# kubectl create secret generic zitadel-credential --namespace=zitadel --from-literal=masterkey="MasterkeyNeedsToHave32Characters" --from-literal=dbhost="cloudnative-pg-cluster-rw.cloudnative-pg.svc.cluster.local" --from-literal=dbport="5432" --from-literal=dbname="zitadel" --from-literal=dbuser="zitadel" --from-literal=dbadmin="postgres" --from-literal=dbuser_password="zitadel_app1@adminz" --from-literal=dbadmin_password="postgres@adminz" --from-literal=zitadel_first_user="admin@zitadellocal.com" --from-literal=zitadel_first_pwd="AdminPass@123"

# echo "Creating dex secret..."
# kubectl create secret generic dex-credential --namespace=dex --from-literal=ZITADEL_CLIENT_ID="265314121468149915@homelab" --from-literal=ZITADEL_CLIENT_SECRET="jaZO3kHqZiot2XExb1p3tnlCAbmC3d1NLQR7FnY40L7fdy0FLT0SvJcJqufUIc3W" --from-literal=GRAFANA_SSO_CLIENT_SECRET="264760171249599008@testproject" --from-literal=ARGOCD_SSO_CLIENT_SECRET="133880978119599112@argoproject"

# echo "Creating 'alertmanager-smtp-secret' secret..."
# kubectl create secret generic alertmanager-smtp-secret --from-literal=smtp_auth_password="$SMTP_AUTH_PWD" --namespace kube-prometheus-stack

# echo "Creating 'duckdns-credential' secret..."
# kubectl create secret generic duckdns-credential --from-literal=token="$TF_VAR_duckdns_token" --namespace cert-manager


