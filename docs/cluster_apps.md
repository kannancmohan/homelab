### All services
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