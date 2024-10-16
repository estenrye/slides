# Custom Ubuntu Autoinstall ISO

The purpose of this code is to automate the production of an Ubuntu Autoinstall
ISO and CIDATA ISOs for automatically installing Ubuntu Servers.

## Reference Documentation

- [Ubuntu Automated Server Installs Config File Reference](https://ubuntu.com/server/docs/install/autoinstall-reference)
- [Netplan Reference](https://netplan.io/reference/)
- [Curtin Reference](https://curtin.readthedocs.io/en/latest/)

## Building Docker Image

To build autoinstall iso files, we need a consistent build environment.  This
build environment has been automated in [./Dockerfile](./Dockerfile) and includes
all of the applications required to unpack, modify and repack the Ubuntu Install
ISO.

To build the build environment, use the following command:

```bash
LAB_AUTOMATION_DIR=`realpath ~/src/slides`

DOCKER_BUILDKIT=1 docker build -t estenrye/ubuntu-autoinstall-iso ${LAB_AUTOMATION_DIR}/docker/estenrye/ubuntu-autoinstall-iso
```

## Building Custom ISOs

This repository automates the process of extracting, modifying and repacking
Ubuntu ISOs using Ansible.  The entrypoint to this automation is
[./ansible/playbooks/playbook.yml](./ansible/playbooks/playbook.yml).
This playbook executes as two separate pieces.

The [first piece](./ansible/playbooks/customize-iso-uefi.yml) builds a uefi
compatible autoinstallation disc.  This playbook downloads the Ubuntu minimal
install ISO, extracts the contents of the ISO to a folder, configures the ISO
to automatically launch the autoinstaller, updates ISO integrity check md5sums,
repackages the ISO, and calculates an ISO checksum.

The [second piece](./ansible/playbooks/cidata-iso.yml) iterates over a list of
bare metal machine configurations to produce CIDATA ISOs.  This playbook creates
an output directory, generates a unique password for the automation-user, generates
a `meta-data` and `user-data` file, packages an iso and creates an iso checksum
for each bare metal machine in the inventory.

You will need to create an Ansible vault with the following variables:

```yaml
proxmox_host: proxmox01.ryezone.com
proxmox_user: root@pam
proxmox_pass: your-password-here
```

For instructions on how to create an Ansible Vault file, read this [tutorial](../docs/ansible/creating-an-ansible-vault-file.md).

The following code will execute the automation and do the following

- Download the Ubuntu Install ISO.
- Extract the Ubuntu Install ISO to a directory.
- Preconfigures the Ubuntu Install ISO to install without prompting.
- Updates the Ubuntu Install ISO checksum
- Generates CIDATA iso files for machines in inventory
- Publishes Ubuntu Install ISO and CIDATA iso files for proxmox hosts in inventory.

```bash
ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
SSH_KEY_PATH=`realpath ~/.ssh/home_id_rsa`

mkdir -p ${LAB_AUTOMATION_DIR}/iso/.output

docker run --rm -it \
  --mount type=bind,source=${SSH_KEY_PATH},target=/root/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  estenrye/ubuntu-autoinstall-iso
```

## Local Testing of Ansible Playbook Changes

```bash
ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
LAB_AUTOMATION_DIR=`realpath ~/src/estenrye/slides`
SSH_KEY_PATH=`realpath ~/.ssh/home_id_rsa`

mkdir -p ${LAB_AUTOMATION_DIR}/iso/.output ${LAB_AUTOMATION_DIR}/iso/.cidata ${LAB_AUTOMATION_DIR}/iso/.ubuntu-iso

docker run --rm -it \
  --mount type=bind,source=${SSH_KEY_PATH},target=/root/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.cidata,target=/tmp/cidata \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.ubuntu-iso,target=/tmp/ubuntu-iso \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/docker/estenrye/ubuntu-autoinstall-iso/ansible/inventories,target=/inventories,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/docker/estenrye/ubuntu-autoinstall-iso/ansible,target=/ansible,readonly \
  --entrypoint ansible-playbook \
  estenrye/ubuntu-autoinstall-iso \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i /inventories/inventory.yml \
    --limit bare_metal_ubuntu,ubuntu-autoinstall-iso
```

## Continuous Integration

The Docker image is continuously integrated using [this Github Workflow](../.github/workflows/CI-estenrye-ubuntu-autoinstall-iso.yml).

## Creating bootable USB media

```bash
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
TARGET_DEVICE='/dev/sda'

# Making an Ubuntu autoinstaller USB disk
sudo dd if=${LAB_AUTOMATION_DIR}/iso/.output/custom_ubuntu-20.04.3-live-server-amd64.iso of=${TARGET_DEVICE} bs=4M status=progress

# Making a cidata USB disk
sudo dd if=${LAB_AUTOMATION_DIR}/iso/.output/maas01/cidata.iso of=${TARGET_DEVICE} bs=4M status=progress
```

## Provision a Proxmox VM Template

```bash
# Provision the template.
# Note that in this example we override the existing values for proxmox_vm_id and proxmox_vm_name
docker run --rm -it \
  --mount type=bind,source=${SSH_KEY_PATH},target=/root/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  --entrypoint packer \
  estenrye/ubuntu-autoinstall-iso \
  build /output/packer_ubuntu_2004_proxmox/template.pkr.hcl
```
