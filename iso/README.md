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
DOCKER_BUILDKIT=1 docker build -t estenrye/ubuntu-autoinstall-iso ~/src/slides/iso
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

The following code will execute the automation:

```bash
LAB_AUTOMATION_DIR=`realpath ~/src/slides`

mkdir -p ${LAB_AUTOMATION_DIR}/iso/.output

docker run --rm -it \
  --user 1000:$(id -u) \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/ansible/inventories,target=/inventories,readonly \
  estenrye/ubuntu-autoinstall-iso \
    -i /inventories/inventory.yml
```

## Local Testing of Ansible Playbook Changes

```bash
LAB_AUTOMATION_DIR=`realpath ~/src/slides`

mkdir -p ${LAB_AUTOMATION_DIR}/iso/.output ${LAB_AUTOMATION_DIR}/iso/.cidata ${LAB_AUTOMATION_DIR}/iso/.ubuntu-iso

docker run --rm -it \
  --user 1000:$(id -u) \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.cidata,target=/tmp/cidata \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.ubuntu-iso,target=/tmp/ubuntu-iso \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/ansible/inventories,target=/inventories,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/ansible,target=/ansible,readonly \
  estenrye/ubuntu-autoinstall-iso \
    -i /inventories/inventory.yml
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
