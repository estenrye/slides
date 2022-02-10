FROM ubuntu:focal-20220105

ENV VAULT_AUTH_METHOD="--vault-password-file=/secrets/secret.key" \
  VAULT_FILE="/secrets/creds.yml" \
  ANSIBLE_CONFIG=/ansible/ansible.cfg \
  INVENTORY_FILE=/ansible/inventory.yml \
  KUBECONFIG=/home/automation-user/.kube/config

COPY . /ansible

RUN apt update \
  && apt install -y --no-install-recommends \
    python3 \
    python3-apt \
    python3-pip \
  && pip3 install --no-warn-script-location -r /ansible/requirements.txt \
  && mkdir -p /ansible_roles \
  && chmod 755 /ansible_roles \
  && ansible-playbook -i localhost, /ansible/docker_image/configure_image.yml

USER automation-user
RUN  ansible-galaxy role install -r /ansible/requirements.yml \
  && ansible-galaxy collection install -r /ansible/requirements.yml \
  && ansible-playbook -i localhost, /ansible/docker_image/configure_helm.yml

WORKDIR /ansible
ENTRYPOINT [ "/ansible/entrypoint.sh" ]
