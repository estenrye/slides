FROM ubuntu:focal-20220105

ENV VAULT_AUTH_METHOD="--vault-password-file=/secrets/secret.key" \
  VAULT_FILE="/secrets/creds.yml" \
  SSH_KEY=/home/automation-user/.ssh/id_rsa

RUN apt update \
  && apt install -y --no-install-recommends\
    apt-transport-https \
    ca-certificates \
    curl \
  && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    genisoimage \
    isolinux \
    mkisofs \
    python3 \
    python3-apt \
    python3-pip \
    p7zip-full \
    sudo \
    xorriso \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt clean \
  && groupadd --gid 1000 automation-user \
  && useradd --shell /bin/bash --home-dir /home/automation-user --create-home --groups sudo --gid 1000 --uid 1000 automation-user \
  && mkdir -p /ansible \
  && chown -R automation-user /ansible

COPY requirements.txt requirements.txt
RUN pip3 install --no-warn-script-location -r requirements.txt

COPY etc/sudoers /etc/sudoers
COPY ansible/templates /ansible/templates
COPY ansible/playbooks /ansible/playbooks

USER automation-user
ENV PATH /home/automation-user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /ansible
ENTRYPOINT ["ansible-playbook", "/ansible/playbooks/playbook.yml"]
