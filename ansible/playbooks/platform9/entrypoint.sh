#!/bin/sh
ansible-playbook ${VAULT_AUTH_METHOD} -e=@${VAULT_FILE} -i=${INVENTORY_FILE} /ansible/playbook.yml $@
