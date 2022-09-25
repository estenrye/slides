FROM alpine:3.16 AS download
RUN apk update \
  && apk add curl git tar wget
RUN wget https://get.helm.sh/helm-v3.10.0-linux-amd64.tar.gz --output-document=/helm.tar.gz
RUN wget https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl --output-document=/kubectl
RUN wget https://github.com/kubernetes-sigs/krew/releases/download/v0.4.3/krew-linux_amd64.tar.gz --output-document=/krew.tar.gz
RUN tar -xzvf /helm.tar.gz
RUN tar -xzvf /krew.tar.gz
RUN chmod 755 /kubectl
RUN ( \
  set -x; cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  KREW="krew-${OS}_${ARCH}" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
  tar zxvf "${KREW}.tar.gz" && \
  ./"${KREW}" install krew \
)

RUN /root/.krew/bin/kubectl-krew install \
  cert-manager \
  minio \
  neat

FROM alpine:3.16
COPY --from=download /root/.krew /root/.krew
COPY --from=download \
  /linux-amd64/helm \
  /kubectl \
  /usr/bin/
COPY .ansible.cfg requirements.txt requirements.yml /root/
RUN apk update && apk upgrade \
  && apk add wget \
  && echo https://downloads.1password.com/linux/alpinelinux/stable/ >> /etc/apk/repositories \
  && wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys \
  && apk update \
  && apk add \
    1password-cli \
    ansible \
    git \
    gpg \
    jq \
    openssh-client \
    openssl \
    p7zip \
    zsh\
  && echo "export PATH=/root/.krew/bin:${PATH}" >> /etc/zsh/zshenv \
  && helm plugin install https://github.com/databus23/helm-diff \
  && pip3 install --force -r /root/requirements.txt \
  && ansible-galaxy install -r /root/requirements.yml
ENTRYPOINT ["zsh"]
