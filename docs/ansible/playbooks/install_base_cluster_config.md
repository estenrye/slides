# Installing the base cluster configuration

```bash
CLUSTER='common'

docker run --rm -it \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  -e PROXMOX_PASSWORD="${PROXMOX_PASSWORD}" \
  -e PROXMOX_USER="${PROXMOX_USERNAME}" \
  -e PROXMOX_URL='https://proxmox01.ryezone.com:8006' \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  --mount type=bind,source=`readlink -f ~/src/slides/ansible`,target=/ansible,readonly \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh`,target=/home/automation-user/.ssh \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    -e @/ansible/playbooks/kubernetes/extra_vars/${CLUSTER}.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/${CLUSTER}/rke2.proxmox.yml \
    /ansible/playbooks/kubernetes/base_cluster_config.yml
```
