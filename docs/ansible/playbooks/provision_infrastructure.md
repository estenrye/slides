# Provision Infrastructure for a Kubernetes Cluster

## Pull latest docker image

```bash
docker pull estenrye/ansible:latest
```

## Provision Machines

```bash
CLUSTER='common'

docker run --rm -t \
  --mount type=bind,source=`readlink -f ~/src/slides/ansible`,target=/ansible,readonly \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    -e @/ansible/playbooks/extra_vars/${CLUSTER}.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/${CLUSTER}/infrastructure.yml \
    /ansible/playbooks/kubernetes/infrastructure_provision.yml
```
