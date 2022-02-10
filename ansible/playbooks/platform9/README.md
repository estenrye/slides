# Platform9 Kubernetes Cluster Automation

This repo contains the automation required to build Platform9 Kubernetes clusters
in my home lab.

## Building Docker Image

To build autoinstall iso files, we need a consistent build environment.  This
build environment has been automated in [./Dockerfile](./Dockerfile) and includes
all of the applications required to unpack, modify and repack the Ubuntu Install
ISO.

To build the build environment, use the following command:

```bash
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
DOCKER_BUILDKIT=1 docker build -t estenrye/platform9-ansible ${LAB_AUTOMATION_DIR}/ansible/playbooks/platform9
```

## Running the image.

You will need to create an Ansible vault with the following variables:

```yaml
cloudflare_api_token: your-token-here
pihole_admin_password: your-password-here
```

For instructions on how to create an Ansible Vault file, read this [tutorial](../../../docs/ansible/creating-an-ansible-vault-file.md).

The following code will execute the automation:

```bash
ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
SSH_KEY_PATH=`realpath ~/.ssh/id_rsa`

docker run --rm -it \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible/playbooks/platform9,target=/ansible,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible/roles,target=/etc/ansible/roles,readonly \
  --mount type=bind,source=`realpath ~/.kube`,target=/home/automation-user/.kube,readonly \
  -e KUBECONFIG=/home/automation-user/.kube/home/ryezone-labs-prod.yaml \
  estenrye/platform9-ansible
```
