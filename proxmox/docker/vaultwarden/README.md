## Admin page (this page is visible only if ADMIN_TOKEN set via environment variable)
https://vault.kcmeu.duckdns.org/admin

### Required environment variable 
```
TF_VAR_vault_admin_token # random generated token using cmd 'openssl rand -base64 48'
```

### Official vaultwarden environment variables
https://github.com/dani-garcia/vaultwarden/blob/main/.env.template

