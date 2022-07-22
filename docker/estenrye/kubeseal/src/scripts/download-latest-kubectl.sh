#!/bin/bash
export ARCH=`arch`
if [ "${ARCH}" == 'aarch64' ]; then
  export ARCH='arm64'
fi

KUBECTL_VERSION=`curl --fail -L -s https://dl.k8s.io/release/stable.txt`
KUBECTL_URL="https://dl.k8s.io/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl"

curl --fail -LO ${KUBECTL_URL} -o /app/kubectl
chmod 555 /app/kubectl
