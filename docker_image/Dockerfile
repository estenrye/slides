FROM ubuntu:focal

ENV VAULT_AUTH_METHOD="--vault-password-file=/secrets/secret.key" \
  VAULT_FILE="/secrets/creds.yml" \
  SSH_KEY=/home/automation-user/.ssh/id_rsa

COPY install /install

# Install Packages
RUN apt update \
  && apt install -y --no-install-recommends\
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
  && /install/add-repos.sh \
  && /install/get-helm-3.sh \
  && /install/get-cert-manager-plugin.sh \
  && /install/get-jq.sh \
  && apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    azure-cli \
    binutils \
    certbot \
    debootstrap \
    docker-ce-cli \
    genisoimage \
    grub-pc-bin \
    grub-efi-amd64-bin \
    kubectl \
    mkisofs \
    mtools \
    openssh-client \
    packer \
    python3 \
    python3-pip \
    p7zip-full \
    squashfs-tools \
    sudo \
    terraform \
    vim \
    xorriso \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt clean \
  && groupadd --gid 10000 docker \
  && groupadd --gid 1000 automation-user \
  && useradd --shell /bin/bash --home-dir /home/automation-user --create-home --groups docker --groups sudo --gid 1000 --uid 1000 automation-user \
  && mkdir -p /ansible \
  && chown -R automation-user /install /ansible

COPY sudoers /etc/sudoers

USER automation-user
ENV PATH /home/automation-user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /ansible

RUN pip3 install --no-warn-script-location -r /install/requirements.txt \
  && /home/automation-user/.local/bin/ansible-galaxy install -r /install/requirements.yml \
  && helm plugin install https://github.com/databus23/helm-diff
