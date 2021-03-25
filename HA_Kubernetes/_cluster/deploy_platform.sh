#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ansible-playbook ${SCRIPT_DIR}/../03_install_prometheus_stack.yml
ansible-playbook ${SCRIPT_DIR}/../04_install_ingress.yml
ansible-playbook ${SCRIPT_DIR}/../05_install_cert_manager.yml
ansible-playbook ${SCRIPT_DIR}/../06_install_kube_dashboard.yml