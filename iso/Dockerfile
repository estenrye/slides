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

# RUN apt update \
#   && apt install -y --no-install-recommends\
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     gpg \
#     lsb-release \
#   && curl -fSl -o /tmp/hashicorp.gpg https://apt.releases.hashicorp.com/gpg \
#   && gpg --batch --yes --dearmor -o /etc/apt/hashicorp.gpg /tmp/hashicorp.gpg \
#   && echo "deb [signed-by=/etc/apt/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" >> /etc/apt/sources.list \
#   && apt update \
#   && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
#     genisoimage \
#     isolinux \
#     mkisofs \
#     packer \
#     python3 \
#     python3-apt \
#     python3-pip \
#     p7zip-full \
#     ssh \
#     sudo \
#     xorriso \
#   && rm -rf /var/lib/apt/lists/* \
#   && rm -rf /tmp/* \
#   && apt clean \
#   && groupadd --gid 1000 automation-user \
#   && useradd --shell /bin/bash --home-dir /home/automation-user --create-home --groups sudo --gid 1000 --uid 1000 automation-user \
#   && mkdir -p /ansible \
#   && chown -R automation-user /ansible

USER automation-user
WORKDIR /ansible
ENTRYPOINT ["ansible-playbook", "/ansible/playbooks/playbook.yml"]
