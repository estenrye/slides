# Provisioning the apt-mirror

## Role Dependencies

- [certbot](../../../ansible/roles/certbot/)
- [cloudflare_dns_a_record](../../../ansible/roles/cloudflare_dns_a_record/)
- [debmirror](../../../ansible/roles/debmirror)
- [firewall](../../../ansible/roles/firewall/)

## Ansible Galaxy Dependencies

### Collections

- [nginxinc.nginx_core](https://galaxy.ansible.com/nginxinc/nginx_core)

## Inventories

- [inventory.yml](../../../ansible/inventories/apt-mirror/inventory.yml)

## Playbooks

- [playbook.yml](../../../ansible/playbooks/apt-mirror/playbook.yml)

## Ansible Vault Value Dependencies

To run this playbook you need values for the following ansible variables in an
encrypted vault file.

[How to create an Ansible Vault file.](../creating-an-ansible-vault-file.md)

```yaml
# This is the email that you will registered with ACME for expiration notices.
acme_account_email: <your email address here>

# This is the private key used to register your account with ACME.
# This is an X509 RSA Private key
acme_account_key: |
  -----BEGIN RSA PRIVATE KEY-----
  ...
  -----END RSA PRIVATE KEY-----

# This is the API Token used for DNS01 challenges and writing DNS A Records
# It should have edit permissions on the cloudflare zone that you will use
# for the DNS Record.
cloudflare_api_token: <your api token here>
```
## Example Execution

```bash
docker run --rm -it --platform=linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
   estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/apt-mirror.yml \
    --ask-vault-password \
    -i /ansible/inventories/apt-mirror/inventory.yml \
    /ansible/playbooks/apt-mirror/playbook.yml
```
