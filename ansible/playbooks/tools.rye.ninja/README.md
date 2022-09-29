```bash
docker run --rm -it \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  --mount type=bind,source=${SSH_KEY_PATH},target=/root/.ssh/id_rsa \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
   estenrye/ansible:latest \
  ansible-playbook \
    -i /ansible/playbooks/tools.rye.ninja/inventory.yml \
    /ansible/playbooks/tools.rye.ninja/playbook.yml
```
