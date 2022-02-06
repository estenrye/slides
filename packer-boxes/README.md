# packer-boxes

## Provisioning a proxmox image

1. Clone the Repository

```bash
git clone https://github.com/estenrye/slides.git
cd slides
```

2. Run packer.

```bash
# Customize the Ubuntu installer iso and generate cidata files.
ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
SSH_KEY_PATH=`realpath ~/.ssh/home_id_rsa`

mkdir -p ${LAB_AUTOMATION_DIR}/iso/.output ${LAB_AUTOMATION_DIR}/iso/.cidata

docker run --rm -it \
  # -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
  --user 1000:$(id -u) \
  --mount type=bind,source=${SSH_KEY_PATH},target=/home/automation-user/.ssh/id_rsa,readonly \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.output,target=/output \
  # --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/.cidata,target=/tmp/cidata \
  # --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/ansible/inventories,target=/inventories,readonly \
  # --mount type=bind,source=${LAB_AUTOMATION_DIR}/iso/ansible,target=/ansible,readonly \
  estenrye/ubuntu-autoinstall-iso \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i /inventories/inventory.yml  --skip-tags iso,cidata,packer


# Customize the ubuntu installer iso.
docker run --rm -it \
  --mount type=bind,source=`readlink -f ~/src/slides/packer-boxes/ubuntu/20.04`,target=/ansible \
  estenrye/ansible:latest \
  ansible-playbook -i localhost, ansible/customize-iso.yml

# Create a cidata iso.
docker run --rm -it \
  --mount type=bind,source=`readlink -f ~/src/slides/packer-boxes/ubuntu/20.04`,target=/ansible \
  estenrye/ansible:latest \
  ansible-playbook -i localhost, ansible/cidata-iso.yml

# Provision the template.
# Note that in this example we override the existing values for proxmox_vm_id and proxmox_vm_name
docker run --rm -it \
  --mount type=bind,source=`readlink -f ~/src/slides/packer-boxes/ubuntu/20.04`,target=/ansible \
  -e PKR_VAR_proxmox_username=${PROXMOX_USERNAME} \
  -e PKR_VAR_proxmox_password=${PROXMOX_PASSWORD} \
  -e PKR_VAR_proxmox_vm_id=516 \
  -e PKR_VAR_proxmox_vm_name=packer-ubuntu-2004-minimal-base-`date '+%Y%m%d'` \
  estenrye/ansible:latest \
  packer build \
    -var-file /ansible/packer_cache/custom-ubuntu-20.04.2-live-server-amd64.iso.pkvars.hcl \
    -var-file /ansible/packer_cache/cidata-proxmox.iso.pkvars.hcl \
    ubuntu-20.04-amd64.proxmox.pkr.hcl
```

## Generating password hash

```bash
openssl passwd -6 -salt your_salt your_password
```

## Set user-data with new hash

Update `ubuntu/http/20.04/user-data`

```yaml
autoinstall:
  # ...
  identity:
    # ...
    password: $6$your_salt$GZLxq4csSvLsH.1XWSYO4uQnta8O.PVW1sumNVktlnCeggJQJL5muU7RvDzbAZ/rF/oFxU8a/O0DZ9c7hx5yn.
  # ...
```

# after build is complete

- Add a cloud-init device
- Remove the cdrom.

# References

- https://www.burgundywall.com/post/using-cloud-init-to-set-static-ips-in-ubuntu-20-04
