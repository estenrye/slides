# Provisioning a Platform9 Cluster in Proxmox


## Set Environment Variables

```bash
export ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
export LAB_AUTOMATION_DIR=`realpath ~/src/slides`
export SSH_KEY_PATH=`realpath ~/.ssh/id_rsa`
export CLUSTER='esten-growth'
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
```

For instructions on how to create an Ansible Vault file, read this [tutorial](../../../docs/ansible/creating-an-ansible-vault-file.md).


## Build Custom ISO, CIDATA ISO and Packer VM Template

```bash
docker run --rm -it --platform linux/amd64 \
  --user 1000:$(id -u) \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
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

## Provision Virtual Machines

```bash
docker run --rm -it --platform linux/amd64 \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i /ansible/inventories/${CLUSTER}/infrastructure.yml \
    /ansible/playbooks/kubernetes/infrastructure_provision.yml
```
