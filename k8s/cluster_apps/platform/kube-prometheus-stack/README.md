### Alertmanager
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
http://localhost:9093/#/status

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
    
    http://localhost:9093/#/alerts

