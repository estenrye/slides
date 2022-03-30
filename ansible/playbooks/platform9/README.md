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
truenas_api_key: your-trunas-scale-api-key-here
pf9_fqdn: https://pmkft-id-id.platform9.io
pf9_username: youremail@example.com
pf9_password: your-pf9-password
```

For instructions on how to create an Ansible Vault file, read this [tutorial](../../../docs/ansible/creating-an-ansible-vault-file.md).

The following code will execute the automation:

```bash
ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
SSH_KEY_PATH=`realpath ~/.ssh/id_rsa`

# temporarily mounting helm directories.
docker run --rm -it \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=`realpath ~/.ssh`,target=/ssh_keys \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible/playbooks/platform9,target=/ansible,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible/roles,target=/etc/ansible/roles,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/helm,target=/helm,readonly \
  --mount type=bind,source=`realpath ~/.kube/home`,target=/kube,readonly \
  estenrye/ansible --limit deployer
```
