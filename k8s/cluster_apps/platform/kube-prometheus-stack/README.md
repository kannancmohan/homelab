### Alertmanager

#### kube-prometheus-stack-alertmanager port-forward
```
kubectl port-forward svc/kube-prometheus-stack-alertmanager 9093:9093 -n kube-prometheus-stack
```
you can access gui http://localhost:9093

#### kube-prometheus-stack-alertmanager port-forward
```
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n kube-prometheus-stack
```
you can access gui http://localhost:9090

#### Gmail SMTP setting
* make sure your gmail account has 2FA enabled 
    https://myaccount.google.com/signinoptions/two-step-verification/enroll-welcome
* create an app-specific password
    https://myaccount.google.com/apppasswords
* Use the above sixteen digits password as your smtp_auth_password

#### view alertmanager configuration 
http://localhost:9093/#/status

#### Reload alertmanager configuration
curl -X POST http://localhost:9093/-/reload

#### view alertmanager routes  
go to http://localhost:9093/#/status  and search for 'routes'

#### view alertmanager rules  
go to http://localhost:9090/rules

via cli
```
amtool config show  --alertmanager.url=http://localhost:9093 
OR
amtool config routes show  --alertmanager.url=http://localhost:9093
```

#### Test route via cli
```
amtool config routes test --alertmanager.url=http://localhost:9093 
OR
amtool config routes test --alertmanager.url=http://localhost:9093 --tree
OR
amtool config routes test --alertmanager.url=http://localhost:9093 --tree severity=warning
```

#### view active alerts via cli or gui 
1. via amtool 
```
amtool alert --alertmanager.url=http://localhost:9093
OR
amtool alert --alertmanager.url=http://localhost:9093 -o extended 
```
2. via alertmanager gui 
    
    http://localhost:9093/alerts

#### Troubleshooting & Testing the prometheus metrics in prometheus ui

1. to verify if an app is available as a target for prometheus to scrap

```
login to prometheus ui http://localhost:9090 and navigate to Status>Targets
From dropdown select the app and click "show more" to check for status and for any error's
```

2. check service discovery if an app is present

```
login to prometheus ui http://localhost:9090 and navigate to Status> Service Discovery
Search the app and click "show more" to check for Discovered Labels and Target Labels
```

3. Check if metrics value using Graph Query

```
login to prometheus ui http://localhost:9090 and navigate to Graph
Use query one of the following query  and select Execute
    http_server_requests_seconds_count{application="your-app-name"}
    http_server_requests_seconds_count{application_name="your-app-name"}
You should see some result
```

### Check metrics in grafana ui

```
login to grafana ui select 'Explore' from main menu
select '' as the source 
In the label filters drope-down select 'application' 
After selecting 'application' the adjacent drope-down will list the available apps
select your app name and execute click 'Run Query' to see results  
```