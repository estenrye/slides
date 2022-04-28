FROM ubuntu:focal-20220105

ENV VAULT_AUTH_METHOD="--vault-password-file=/secrets/secret.key" \
  VAULT_FILE="/secrets/creds.yml" \
  SSH_KEY=/home/automation-user/.ssh/id_rsa \
  ANSIBLE_CONFIG=/ansible/ansible.cfg \
  PLAYBOOK_FILE=/ansible/playbooks/playbook.yml \
  INVENTORY_FILE=/ansible/inventories/inventory.yml \
  PACKER_LOG=1

COPY requirements.txt requirements.yml entrypoint.sh /
COPY etc/sudoers /etc/sudoers
COPY ansible /ansible

RUN apt update \
  && apt install -y --no-install-recommends \
    python3 \
    python3-apt \
    python3-pip \
  && pip3 install --no-warn-script-location -r /requirements.txt \
  && mkdir -p /ansible_roles \
  && chmod 755 /ansible_roles \
  && ansible-galaxy install -r /requirements.yml \
  && ansible-playbook -i localhost, /ansible/playbooks/_dockerfile/configure_image.yml

USER automation-user
WORKDIR /ansible
ENTRYPOINT ["/entrypoint.sh"]
