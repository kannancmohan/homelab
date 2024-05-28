## vulnerability report
### View vulnerability report for a namespace
```
kubectl get vulnerabilityreports -n argocd -o wide

or 

kubectl describe vulnerabilityreports -n argocd
```  

### View vulnerability report for all namespace
```
kubectl get vulnerabilityreports --all-namespaces -o wide
```

## Compliance Reports

### list of supported compliance reports
```
kubectl get clustercompliancereports
```
### view config audit reports
```
kubectl describe configauditreports -n argocd
```

## Exposed Secrets Report
### view report
```
kubectl describe exposedsecretreport -n argocd
```

## RBAC Assessment Report
### view report
```
kubectl describe rbacassessmentreport --namespace argocd
```

## Cluster RBAC Assessment Report
### view report
```
kubectl describe clusterrbacassessmentreport clusterrole-wildcard-resource
```
```
kubectl get clusterrbacassessmentreport --all-namespaces --output=wide
```

## Cluster Infra Assessment Reports
### get report 
```
kubectl get clusterinfraassessmentreports -o wide
```
### details about node
```
NODE=$(kubectl get clusterinfraassessmentreports --no-headers=true -o custom-columns=":metadata.name" | head -1)
kubectl describe clusterinfraassessmentreports "${NODE}"
```
