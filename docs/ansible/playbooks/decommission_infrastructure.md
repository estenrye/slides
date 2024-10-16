# Decommission Infrastructure for a Kubernetes Cluster

## Pull latest docker image

```bash
docker pull estenrye/ansible:latest
```

## Decommission Machines

```bash
CLUSTER='common'

docker run --rm -it \
  --mount type=bind,source=`readlink -f ~/src/slides/ansible`,target=/ansible,readonly \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    -e @/ansible/playbooks/kubernetes/extra_vars/${CLUSTER}.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/${CLUSTER}/infrastructure.yml \
    /ansible/playbooks/kubernetes/infrastructure_decommission.yml
```
