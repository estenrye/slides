# Hashicorp Repository
helm repo add hashicorp https://helm.releases.hashicorp.com

# Host Consul locally.
helm install my-consul hashicorp/consul --version 0.28.0

# Host Vault locally.
helm install vault hashicorp/vault \
    --version 0.9.0 \
    --namespace vault \
    --set "server.ha.enabled=true" \
    --set "server.ha.replicas=5" \
    --dry-run

# Host Harbor locally.
# Need to figure out what config I want to change.
helm repo add harbor https://helm.goharbor.io
helm install my-harbor harbor/harbor --version 1.5.2

