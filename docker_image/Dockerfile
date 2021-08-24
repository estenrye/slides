FROM ubuntu:focal

# Install Packages
RUN apt update \
  && apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
  && mkdir -p /usr/local/share/keyrings \
  && curl -fSl -o /tmp/docker.gpg https://download.docker.com/linux/ubuntu/gpg \
  && curl -fSl -o /tmp/hashicorp.gpg https://apt.releases.hashicorp.com/gpg \
  && gpg --batch --yes --dearmor -o /usr/local/share/keyrings/docker.gpg /tmp/docker.gpg \
  && gpg --batch --yes --dearmor -o /usr/local/share/keyrings/hashicorp.gpg /tmp/hashicorp.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/local/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list \
  && echo "deb [arch=amd64 signed-by=/usr/local/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" >> /etc/apt/sources.list \
  && apt update \
  && apt install -y \
    docker-ce-cli \
    genisoimage \
    mkisofs \
    packer \
    python3 \
    python3-pip \
    p7zip-full \
    sudo \
    xorriso \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && apt clean

RUN groupadd --gid 10000 docker \
  && groupadd --gid 1000 automation-user \
  && useradd --shell /bin/bash --home-dir /home/automation-user --create-home --groups docker --groups sudo --gid 1000 --uid 1000 automation-user \
  && mkdir -p /install /ansible \
  chown automation-user /install /ansible

COPY sudoers /etc/sudoers

USER automation-user
ENV PATH /home/automation-user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /ansible

COPY requirements.txt /install/requirements.txt

RUN pip3 install --no-warn-script-location -r /install/requirements.txt

COPY requirements.yml /install/requirements.yml

RUN /home/automation-user/.local/bin/ansible-galaxy install -r /install/requirements.yml
