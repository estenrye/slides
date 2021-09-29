#!/usr/bin/env bash
CLUSTER=common

ansible-playbook \
  -e @${VAULT_FILE} \
  -e @/ansible/playbooks/kubernetes/extra_vars/${CLUSTER}.yml \
  ${VAULT_AUTH_METHOD} \
  -i /ansible/inventories/${CLUSTER}/rke2.proxmox.yml \
  /ansible/playbooks/kubernetes/get_kube_config.yml
