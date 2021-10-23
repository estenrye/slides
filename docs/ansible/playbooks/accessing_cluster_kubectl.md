# Activating a Cluster for Kubectl Access

## Pull latest docker image

```bash
docker pull estenrye/ansible:latest
```

## Get .kube/config File from Initial Controlplane

```bash
CLUSTER='common'

docker run --rm -it \
  --mount type=bind,source=`readlink -f ~/src/slides/ansible`,target=/ansible,readonly \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh/id_rsa`,target=/home/automation-user/.ssh/id_rsa,readonly \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  -e VAULT_FILE=/secrets/creds.yml \
  -e VAULT_AUTH_METHOD='--vault-password-file=/secrets/secret.key' \
  -e CLUSTER=${CLUSTER} \
  -e PROXMOX_USER="${PROXMOX_USERNAME}" \
  -e PROXMOX_PASSWORD="${PROXMOX_PASSWORD}" \
  -e PROXMOX_URL='https://proxmox01.ryezone.com:8006' \
  estenrye/ansible:latest \
  bash

/ansible/inventories/${CLUSTER}/activate.sh
```
