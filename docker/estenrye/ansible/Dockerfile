FROM alpine:3.16
RUN apk update && apk upgrade \
  && apk add wget \
  && echo https://downloads.1password.com/linux/alpinelinux/stable/ >> /etc/apk/repositories \
  && wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys \
  && apk update \
  && apk add \
    1password-cli \
    ansible \
    gpg \
    # helm \
    jq \
    # kubectl \
    # krew \
    openssh-client \
    openssl \
    p7zip \
    zsh
