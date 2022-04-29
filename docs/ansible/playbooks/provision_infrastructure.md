# Provision Infrastructure for a Kubernetes Cluster

## Pull latest docker image

```bash
docker pull estenrye/ansible:latest
```

## Provision Machines

```bash
export ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
export LAB_AUTOMATION_DIR=`realpath ~/src/slides`
export SSH_KEY_PATH=`realpath ~/.ssh/id_rsa`
export CLUSTER='common'

docker run --rm -it --platform linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/${CLUSTER}/infrastructure.yml \
    /ansible/playbooks/kubernetes/infrastructure_provision.yml

docker run --rm -it \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  -e PROXMOX_PASSWORD="${PROXMOX_PASSWORD}" \
  -e PROXMOX_USER="${PROXMOX_USERNAME}" \
  -e PROXMOX_URL='https://proxmox01.ryezone.com:8006' \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa,readonly \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    -e @/ansible/playbooks/kubernetes/extra_vars/${CLUSTER}.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/${CLUSTER}/rke2.proxmox.yml \
    /ansible/playbooks/kubernetes/infrastructure_map_usb.yml
```
git
