FROM alpine:3.16 AS download
RUN apk update \
  && apk add bash curl git openssl tar wget
RUN ( \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
)
RUN chmod 755 /kubectl
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
RUN ( \
  set -x; cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  KREW="krew-${OS}_${ARCH}" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
  tar zxvf "${KREW}.tar.gz" && \
  ./"${KREW}" install krew \
)

RUN /root/.krew/bin/kubectl-krew install cert-manager neat; \
  if [[ "$(uname -m)" == 'x86_64']] \
  then \
    /root/.krew/bin/kubectl-krew install minio \
  fi

FROM alpine:3.16
COPY --from=download /root/.krew /root/.krew
COPY --from=download \
  /usr/local/bin/helm \
  /kubectl \
  /usr/bin/
COPY .ansible.cfg .ashrc pre-requirements.txt requirements.txt requirements.yml /root/
# ENV ENV=/root/.ashrc
RUN apk update && apk upgrade \
  && apk add \
    git \
    gpg \
    jq \
    openssh-client \
    openssl \
    p7zip \
    py3-pip \
    wget \
  && echo "export PATH=/root/.krew/bin:${PATH}" >> /root/.bash \
  if [[ "$(uname -m)" == 'x86_64']] \
  then \
    echo https://downloads.1password.com/linux/alpinelinux/stable/ >> /etc/apk/repositories \
    && wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys \
    && apk update && apk add 1password-cli \
  fi \
  helm plugin install https://github.com/databus23/helm-diff
RUN  pip3 install -r /root/pre-requirements.txt \
  && pip3 install -r /root/requirements.txt \
  && ansible-galaxy install -r /root/requirements.yml
WORKDIR /ansible
ENTRYPOINT [ "ash", "--login" ]
