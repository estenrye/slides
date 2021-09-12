# Creating an ansible-vault file.

## with password prompt

```bash
mkdir -p ~/.ansible/secrets
ansible-vault create --vault-id creds@prompt ~/.ansible/secrets/creds.yml
```

## with password file

```bash
mkdir -p ~/.ansible/secrets
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 128 | head -n 1 > ~/.ansible/secrets/secret.key
ansible-vault create --vault-password-file=~/.ansible/secrets/secret.key ~/.ansible/secrets/creds.yml
```

# Add the following values

```yaml
proxmox_host: proxmox01.example.com
proxmox_user: root@pam
proxmox_pass: your-pass-here
cloudflare_api_token: your-token-here
azure-service_principal:
  appId: your-id-here
  displayName: sp_name_here
  name: your-id-here
  password: your-password-here
  tenant: your-tennant-here
common_cluster:
  join_token: join-token-here
truenas_api_key: your-api-key-here
cert_manager_acme_email: your-email-address-here
```
