# Provisioning a Platform9 Cluster in Proxmox


## Set Environment Variables

```bash
export ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
export LAB_AUTOMATION_DIR=`realpath ~/src/slides`
export SSH_KEY_PATH=`realpath ~/.ssh/id_rsa`
export CLUSTER='esten-growth'
export PROXMOX_URL='https://your-proxmox-host-here:8006'
export PROXMOX_USER='root@pam'
export PROXMOX_PASSWORD='your-password-here'
```

## Create output directory

```bash
mkdir -p ${LAB_AUTOMATION_DIR}/iso/.output
```

## Create an Ansible Vault

You will need to create an Ansible vault with the following variables:

```yaml
proxmox_host: proxmox01.ryezone.com
proxmox_user: root@pam
proxmox_pass: your-password-here

cloudflare_zone: your-zone.tld
cloudflare_api_token: your-api-token-here
```

For instructions on how to create an Ansible Vault file, read this [tutorial](../../../docs/ansible/creating-an-ansible-vault-file.md).


## Build Custom ISO, CIDATA ISO and Packer VM Template

```bash
docker run --rm -it --platform linux/amd64 \
  --user 1000:$(id -u) \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  -e VAULT_FILE=/secrets/esten-growth.yml \
  -e VAULT_AUTH_METHOD=--ask-vault-password \
  estenrye/ubuntu-autoinstall-iso
```

## Build Proxmox Template VM

```bash
# Provision the template.
# Note that in this example we override the existing values for proxmox_vm_id and proxmox_vm_name
docker run --rm -it --platform linux/amd64 \
  --user 1000:$(id -u) \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  --entrypoint packer \
  estenrye/ubuntu-autoinstall-iso \
  build /output/packer_ubuntu_2004_proxmox/template.pkr.hcl
```

## Manually add a Cloud Init Drive to newly created template.

Browse to the vm template in the proxmox ui and add a Cloud Init drive to the template's Hardware.

## Provision Virtual Machines

```bash
docker run --rm -it --platform linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/esten-growth.yml \
    --ask-vault-password \
    -i /ansible/inventories/${CLUSTER}/infrastructure.yml \
    /ansible/playbooks/infrastructure/infrastructure_provision.yml
```

## Set Cloudflare DNS Entries

```bash
docker run --rm -it --platform linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  -e PROXMOX_URL=${PROXMOX_URL} \
  -e PROXMOX_USER=${PROXMOX_USER} \
  -e PROXMOX_PASSWORD=${PROXMOX_PASSWORD} \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/esten-growth.yml \
    --ask-vault-password \
    -i /ansible/inventories/${CLUSTER}/cluster.proxmox.yml \
    /ansible/playbooks/infrastructure/cloudflare_dns.yml
```

## Deploy Platform9 CLI

```bash
docker run --rm -it --platform linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa \
  -e PROXMOX_URL=${PROXMOX_URL} \
  -e PROXMOX_USER=${PROXMOX_USER} \
  -e PROXMOX_PASSWORD=${PROXMOX_PASSWORD} \
  -e ANSIBLE_CONFIG=/ansible \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/esten-growth.yml \
    --ask-vault-password \
    -i /ansible/inventories/${CLUSTER}/cluster.proxmox.yml \
    /ansible/playbooks/pf9-cluster/playbook.yml -e pf9_prep_node=true
```


## Decommission the infrastructure

```bash
docker run --rm -it --platform linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/esten-growth.yml \
    --ask-vault-password \
    -i /ansible/inventories/${CLUSTER}/infrastructure.yml \
    /ansible/playbooks/infrastructure/infrastructure_decommission.yml
```
