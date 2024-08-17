FROM ubuntu:jammy-20240808 as configbase

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gnupg \
        # gzip \
        jetring \
        python3-pip
        # unzip=6.0-26ubuntu3.1

WORKDIR /dependencies
COPY dependencies ./
RUN pip3 install -r requirements.txt

WORKDIR /apt-mirror.d
WORKDIR /debmirror.d
WORKDIR /gpg
WORKDIR /gnupg
WORKDIR /app
COPY ansible /app
RUN ansible-playbook -i inventory.yml playbook.yml --tags "aptmirror-conf"
RUN ansible-playbook -i inventory.yml playbook.yml --tags "debmirror-conf"
RUN ansible-playbook -i inventory.yml playbook.yml --tags "gpg-archive-trust"
RUN ansible-playbook -i inventory.yml playbook.yml --tags "gpg-key-trust"


# Copy the mirror configuration
FROM debian:stable-slim as artifact

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-mirror=0.5.4-2 \
        debmirror=1:2.37 \
        && \
    rm -rf /var/lib/apt/lists/*

COPY --from=configbase /apt-mirror.d/ /etc/apt-mirror.d
COPY --from=configbase /debmirror.d/ /etc/debmirror.d
COPY --from=configbase /gnupg/ /root/.gnupg/
COPY scripts /mirror/bin
COPY --from=configbase /gpg /mirror/gpg


VOLUME /mirror/mirror
