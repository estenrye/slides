#!/bin/bash

set -e

ansible-playbook \
  ${VAULT_AUTH_METHOD} \
  -e @${VAULT_FILE} \
  -i ${INVENTORY_FILE} \
  ${PLAYBOOK_FILE}
