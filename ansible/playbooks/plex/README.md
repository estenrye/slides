# Plex Media Server Playbook

```bash
docker run --rm -it --platform=linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/playbooks/plex/plex.inventory.yml \
    /ansible/playbooks/plex/plex.playbook.yml
```
