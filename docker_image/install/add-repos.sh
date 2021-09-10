#!/usr/bin/env bash
mkdir -p /usr/local/share/keyrings

curl -fSl -o /tmp/docker.gpg https://download.docker.com/linux/ubuntu/gpg
gpg --batch --yes --dearmor -o /usr/local/share/keyrings/docker.gpg /tmp/docker.gpg
echo "deb [arch=amd64 signed-by=/usr/local/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list

curl -fSl -o /tmp/hashicorp.gpg https://apt.releases.hashicorp.com/gpg
gpg --batch --yes --dearmor -o /usr/local/share/keyrings/hashicorp.gpg /tmp/hashicorp.gpg
echo "deb [arch=amd64 signed-by=/usr/local/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" >> /etc/apt/sources.list

curl -fSl -o /tmp/microsoft.gpg https://packages.microsoft.com/keys/microsoft.asc
gpg --batch --yes --dearmor -o /usr/local/share/keyrings/microsoft.gpg /tmp/microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/local/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" >> /etc/apt/sources.list

curl -fsSLo /tmp/kubernetes.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
gpg --batch --yes --dearmor -o /usr/local/share/keyrings/kubernetes.gpg /tmp/kubernetes.gpg
echo "deb [signed-by=/usr/local/share/keyrings/kubernetes.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list

rm /tmp/*.gpg
