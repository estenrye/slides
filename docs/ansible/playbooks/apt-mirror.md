# Provisioning the apt-mirror

```bash
docker run --rm -it \
  --mount type=bind,source=`readlink -f ~/src/slides/ansible`,target=/ansible,readonly \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh`,target=/home/automation-user/.ssh \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/apt-mirror/inventory.yml \
    /ansible/playbooks/apt-mirror/playbook.yml
```
