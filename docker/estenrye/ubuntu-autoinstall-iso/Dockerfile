FROM ubuntu:focal-20220105

ENV VAULT_AUTH_METHOD="--vault-password-file=/secrets/secret.key" \
  VAULT_FILE="/secrets/creds.yml" \
  SSH_KEY=/home/automation-user/.ssh/id_rsa \
  ANSIBLE_CONFIG=/ansible/ansible.cfg
  # PATH=/home/automation-user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY requirements.txt requirements.txt
COPY requirements.yml requirements.yml
COPY etc/sudoers /etc/sudoers
COPY ansible /ansible

RUN apt update \
  && apt install -y --no-install-recommends \
    python3 \
    python3-apt \
    python3-pip \
  && pip3 install --no-warn-script-location -r requirements.txt \
  && mkdir -p /ansible_roles \
  && chmod 755 /ansible_roles \
  && ansible-galaxy install -r requirements.yml \
  && ansible-playbook -i localhost, /ansible/playbooks/_dockerfile/configure_image.yml

USER automation-user
WORKDIR /ansible
ENTRYPOINT ["ansible-playbook", "${VAULT_AUTH_METHOD}", "/ansible/playbooks/playbook.yml"]