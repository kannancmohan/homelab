## HomeLab
A project that utilizes IaC and GitOps practices for automating provisioning and operation of self-hosted services in Homelab.

<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="2">Self Hosted Services</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
    </tr>
    <tr>
        <td><a href="https://kubernetes.io/">Kubernetes</a></td>
        <td>Kubernetes is a container orchestration platform that automates many of the manual processes involved in deploying, managing and scaling containerized applications</td>
    </tr>
    <tr>
        <td><a href="https://github.com/AdguardTeam/AdGuardHome">AdGuard Home</a></td>
        <td>Adguard Home is a forwarding DNS server and DNS filtering server. It supports blocking ads & tracking</td>
    </tr>
    <tr>
        <td><a href="https://github.com/caddyserver/caddy">Caddy</a></td>
        <td>Reverse proxy with automatic HTTPS configuration</td>
    </tr>
    <tr>
        <td><a href="https://unbound.docs.nlnetlabs.nl/en/latest/">Unbound DNS</a></td>
        <td>Unbound is a validating, recursive, caching DNS resolver. Unbound supports DNS-over-TLS and DNS-over-HTTPS which allows clients to encrypt their communication</td>
    </tr>
    <tr>
        <td><a href="https://github.com/dani-garcia/vaultwarden">Vaultwarden</a></td>
        <td>Vaultwarden self-hosted password manager</td>
    </tr>
</table>


## Hardware spec
### Kubernetes Hardware requirement
| VM            | Cores         | Memory| Disk|
| ------------- |:-------------:| -----:| -----:|
| master        | 2             | 5120  | 25G   |
| worker1       | 1             | 3072  | 15G   |
| worker2       | 1             | 3072  | 15G   |

## Kubernetes Apps
### Monitoring
The software stack used for monitoring system and applications. These tools allow to analyze real-time metrics of containers and nodes
<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Monitoring Tools</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Installation</th>
    </tr>
    <tr>
        <td><a href="https://github.com/prometheus-operator/prometheus-operator">Prometheus Operator</a></td>
        <td>A kubernetes operator that automates the configuration and management of the Prometheus monitoring stack</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack">kube-prometheus-stack</a></td>
    </tr>
    <tr>
        <td><a href="https://prometheus.io/">Prometheus</a></td>
        <td>Monitoring & alerting solution that collects metrics data and stores that data in a time series database</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack">kube-prometheus-stack</a></td>
    </tr>
    <tr>
        <td><a href="https://github.com/prometheus/node_exporter">Prometheus Node Exporter</a></td>
        <td>Agent that gathers system(Hardware and OS) level metrics and exposes them in a format which can be ingested by Prometheus.</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack">kube-prometheus-stack</a></td>
    </tr>
    <tr>
        <td><a href="https://github.com/kubernetes/kube-state-metrics">kube-state-metrics</a></td>
        <td>Add-on that generates metrics about state of Kubernetes cluster objects. It listens to the Kubernetes API server and gathers information about resources and objects, such as Deployments, Pods, Services, and StatefulSets</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack">kube-prometheus-stack</a></td>
    </tr>
    <tr>
        <td><a href="https://prometheus.io/docs/alerting/latest/alertmanager/">Prometheus Alertmanager</a></td>
        <td>The Alertmanager handles alerts sent by client applications such as the Prometheus server. It takes care of deduplicating, grouping, and routing them to the correct receiver integrations such as email etc</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack">kube-prometheus-stack</a></td>
    </tr>
    <tr>
        <td><a href="https://grafana.com/">Grafana</a></td>
        <td>Allows to query, visualize, alert on, and explore metrics, logs, and traces no matter where it's stored.</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/grafana/grafana">Grafana helm chart</a></td>
    </tr>
</table>

### Logging
Loki, Promtail and Grafana is used for log aggregation and  visualization
<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Logging Tools</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Installation</th>
    </tr>
    <tr>
        <td><a href="https://github.com/grafana/loki">Loki</a></td>
        <td>Inspired from prometheus, Loki is a datastore optimized for efficiently holding log data. It is a TSDB (Time-series database), it stores logs as split and gzipped chunks of data</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/grafana/loki-distributed">loki-distributed</a></td>
    </tr>
    <tr>
        <td><a href="https://grafana.com/docs/loki/latest/send-data/promtail/">Promtail</a></td>
        <td>Promtail is a logs collector agent that collects, (re)labels and ships logs to Loki. </td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/grafana/promtail">promtail</a></td>
    </tr>
    <tr>
        <td><a href="https://grafana.com/">Grafana</a></td>
        <td>Allows to query and visualize logs</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/grafana/grafana">Grafana helm chart</a></td>
    </tr>
    <tr>
        <td>Thanos</td>
        <td>TODO</td>
        <td>TODO</td>
    </tr>
</table>

### Vulnerability & Dependency scanner
Trivy is used for security scanning and Grafana to visualize it
<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Security Tools</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Installation</th>
    </tr>
    <tr>
        <td><a href="https://github.com/aquasecurity/trivy">Trivy</a></td>
        <td>Trivy continuously scans Kubernetes cluster for security issues</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/trivy-operator/trivy-operator">trivy-operator</a></td>
    </tr>
    <tr>
        <td><a href="https://grafana.com/">Grafana</a></td>
        <td>Allows to visualize security vulnerabilities</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/grafana/grafana">Grafana helm chart</a></td>
    </tr>
</table>

### Identity provider and Manager
<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Identity provider and Manager</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Installation</th>
    </tr>
    <tr>
        <td><a href="https://github.com/aquasecurity/trivy">Zitadel</a></td>
        <td>Zitadel is an identity and access management solution</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/zitadel/zitadel">zitadel helm chart</a></td>
    </tr>
    <tr>
        <td><a href="https://github.com/dexidp/dex">Dex</a></td>
        <td>Dex is an identity provider that uses OpenID Connect to manage authentication for apps</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/dex/dex">Dex helm chart</a></td>
    </tr>
</table>

### Cluster management
<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Management Tools</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Installation</th>
    </tr>
    <tr>
        <td><a href="https://github.com/cert-manager/cert-manager">Cert-manager</a></td>
        <td>Automatically provision and manage TLS certificates</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/cert-manager/cert-manager">cert-manager</a></td>
    </tr>
    <tr>
        <td><a href="https://github.com/external-secrets/external-secrets">External-secrets</a></td>
        <td>Kubernetes operator that integrates external secret management systems like AWS Secrets Manager, HashiCorp Vault, Google Secrets Manager etc</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets">external-secrets</a></td>
    </tr>
    <tr>
        <td><a href="https://github.com/vmware-tanzu/velero">Velero</a></td>
        <td>To backup and migrate Kubernetes applications and their persistent volumes</td>
        <td>TODO</td>
    </tr>
</table>

### Ingress
<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Ingress Tools</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Installation</th>
    </tr>
    <tr>
        <td><a href="https://github.com/traefik/traefik">Traefik controller</a></td>
        <td>Kubernetes ingress controller</td>
        <td>Installed as part of <a href="https://artifacthub.io/packages/helm/traefik/traefik">traefik</a></td>
    </tr>
</table>

<table style='font-family:"Courier New", Courier, monospace; font-size:100%'>
    <tr>
        <th colspan="3">Cluster Services</th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Namespace</th>
        <th>Port forward</th>
    </tr>
    <tr>
        <td><a href="https://argocd.dev.local/">Argocd</a></td>
        <td>argocd</td>
        <td>kubectl -n argocd port-forward svc/argocd-server 8080:443</td>
    </tr>
    <tr>
        <td>Traefik</td>
        <td>traefik</td>
        <td>kubectl port-forward deployments/traefik 2900:9000 --namespace traefik</td>
    </tr>
    <tr>
        <td>Prometheus</td>
        <td>kube-prometheus-stack</td>
        <td>kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n kube-prometheus-stack</td>
    </tr>
    <tr>
        <td>Prometheus-alertmanager</td>
        <td>kube-prometheus-stack</td>
        <td>kubectl port-forward svc/kube-prometheus-stack-alertmanager 9093:9093 -n kube-prometheus-stack</td>
    </tr>
    <tr>
        <td>Prometheus-node-exporter</td>
        <td>kube-prometheus-stack</td>
        <td>kubectl port-forward svc/kube-prometheus-stack-prometheus-node-exporter 9100:9100 -n kube-prometheus-stack</td>
    </tr>
    <tr>
        <td>Kube-state-metrics</td>
        <td>kube-prometheus-stack</td>
        <td>kubectl port-forward svc/kube-prometheus-stack-kube-state-metrics 9808:8080 -n kube-prometheus-stack</td>
    </tr>
    <tr>
        <td><a href="https://grafana.dev.local/d/efa86fd1d0c121a26444b636a3f509a8/kubernetes-compute-resources-cluster?orgId=1&refresh=10s">Grafana dashboard</a></td>
        <td>grafana</td>
        <td>kubectl port-forward svc/grafana 3000:80 -n grafana</td>
    </tr>
    <tr>
        <td>Loki - no gui</td>
        <td>loki</td>
        <td>kubectl -n loki port-forward svc/loki-loki-distributed-gateway 9080:80</td>
    </tr>
    <tr>
        <td>Promtail</td>
        <td>promtail</td>
        <td>kubectl port-forward svc/promtail-metrics 3101:3101 -n promtail</td>
    </tr>
    <tr>
        <td><a href="https://grafana.dev.local/d/o6-BGgnnk/loki-kubernetes-logs?orgId=1">Grafana logger dashboard</a></td>
        <td>grafana</td>
        <td>kubectl port-forward svc/grafana 3000:80 -n grafana</td>
    </tr>
</table>

### Steps to run

1. To provision the vm, check steps mentioned [here](/proxmox/vm-provisioning/README.md#executing-the-provisioning) 

2. To configure vm, check steps mentioned [here](/proxmox/k8s-environment-setup/ansible/README.md#steps-to-execute) 

## Authors

* kannan

## Version History

* 0.1
    * Initial Release

## License

## Acknowledgments

* 
