### Adding a new reverse proxy entry 
* add a new entry in configs/Caddyfile

Eg:
```
	@vault host vault.{$DOMAIN_NAME}
	handle @vault {
		reverse_proxy {$VAULT_IP_PORT} {
			import headers
		}
	}
```
* add the ip and port of the service in configs/caddy_env_variables.yaml

Eg:
```
VAULT_IP_PORT: 192.168.0.30:9202
```

* add an entry in configs/index.html

Eg:
```
<tr>
    <td><a href="https://vault.kcmeu.duckdns.org/" target="_blank">Vaultwarden</a></td>
    <td>Vaultwarden password manager</td>
</tr>
```

### Update dns entries to point to caddy server ip
Eg:
```
*.kcmeu.duckdns.org 192.168.0.30
kcmeu.duckdns.org 192.168.0.30
```

### Required environment variable 
```
TF_VAR_duckdns_token # the token from duckdns site
```