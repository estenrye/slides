#!/usr/bin/env bash
curl -L \
  -o /tmp/kubectl-cert-manager.tar.gz \
  https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-amd64.tar.gz
tar xzf /tmp/kubectl-cert-manager.tar.gz
rm /tmp/kubectl-cert-manager.tar.gz
mv kubectl-cert_manager /usr/local/bin
