FROM alpine:3.16
RUN apk update && apk upgrade && apk add curl \
  && curl -o cdrkit.apk https://dl-cdn.alpinelinux.org/alpine/v3.12/main/$(uname -m)/cdrkit-1.1.11-r2.apk \
  && curl -o xorriso.apk https://dl-cdn.alpinelinux.org/alpine/v3.12/main/$(uname -m)/xorriso-1.5.2-r0.apk \
  && apk add cdrkit.apk \
  && apk add xorriso.apk \
  && apk add \
    ansible \
    gpg \
    packer \
    openssl \
    p7zip \
    zsh


ENV VAULT_AUTH_METHOD="--vault-password-file=/secrets/secret.key" \
  VAULT_FILE="/secrets/creds.yml" \
  SSH_KEY=/root/.ssh/id_rsa \
  ANSIBLE_CONFIG=/ansible/ansible.cfg \
  PLAYBOOK_FILE=/ansible/playbooks/playbook.yml \
  INVENTORY_FILE=/ansible/inventories/inventory.yml \
  PACKER_LOG=1

COPY requirements.yml entrypoint.sh  ansible /

RUN mkdir -p /ansible_roles \
  && ansible-galaxy install -r /requirements.yml

WORKDIR /ansible
ENTRYPOINT ["/entrypoint.sh"]
