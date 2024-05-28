### To enable traefik access log 
uncomment the section under "uncomment to enable container tails access log" in values.yaml

### view access log using above container 
```
kubectl logs -f -l app.kubernetes.io/name=traefik -c tail-accesslogs -n traefik
```