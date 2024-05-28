## Make sure a secret is created with the following keys
* admin-password --> keycloak admin user password
* postgres-password --> postgres admin user password
* password --> postgres user password

eg:
```
kubectl create secret generic keycloak-credentials-secret --from-literal=admin-password="identity@keycloak" --from-literal=postgres-password="identity@keycloak" --from-literal=password="identity@keycloak" --namespace keycloak
```