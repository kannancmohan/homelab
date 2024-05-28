### View cluster details 
```
kubectl get cluster -n cloudnative-pg
```

### Test postgres connection
#### port forward the service
```
kubectl -n cloudnative-pg port-forward svc/cloudnative-pg-cluster-rw 5432:5432
```
#### test database using psql
```
psql "host=localhost port=5432 user=postgres password=your-admin-pwd"
OR
psql "host=localhost port=5432 dbname=app user=app password=your-user-pwd"
```

### CNPG kubectl plugin for managing cluster
https://cloudnative-pg.io/documentation/1.20/kubectl-plugin/