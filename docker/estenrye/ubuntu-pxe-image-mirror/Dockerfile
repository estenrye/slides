FROM debian:stable-slim
RUN apt update \
  && apt install -y \
    p7zip-full \
    rsync \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

VOLUME /tftp
COPY scripts /scripts

ENTRYPOINT ["bash", "/scripts/ubuntu.sh"]
