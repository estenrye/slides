# packer-boxes

## Provisioning a proxmox image

1. Update `proxmox_vm_id` to a new unique value in [/packer-boxes/ubuntu/20.04/ubuntu-20.04-amd64.proxmox.pkr.hcl](/packer-boxes/ubuntu/20.04/ubuntu-20.04-amd64.proxmox.pkr.hcl)
1. Update `vm_name` to a new unique value in [/packer-boxes/ubuntu/20.04/ubuntu-20.04-amd64.proxmox.pkr.hcl](/packer-boxes/ubuntu/20.04/ubuntu-20.04-amd64.proxmox.pkr.hcl)
1. Run packer.

```bash
PATH_TO_REPO=~/src/slides

docker run --rm \
  --mount type=bind,source=${PATH_TO_REPO}/packer-boxes/ubuntu/20.04,target=/ansible \
  estenrye/ansible:latest \
  ansible-playbook -i localhost, ansible/customize-iso.yml

docker run --rm \
  --mount type=bind,source=${PATH_TO_REPO}/packer-boxes/ubuntu/20.04,target=/ansible \
  estenrye/ansible:latest \
  ansible-playbook -i localhost, ansible/cidata-iso.yml

docker run --rm \
  --mount type=bind,source=${PATH_TO_REPO}/packer-boxes/ubuntu/20.04,target=/ansible \
  -e PKR_VAR_proxmox_username=${PROXMOX_USERNAME} \
  -e PKR_VAR_proxmox_password=${PROXMOX_PASSWORD} \
  -e PKR_VAR_proxmox_vm_id=516 \
  -e PKR_VAR_proxmox_vm_name=packer-ubuntu-2004-minimal-base-`date '+%Y%m%d'` \
  estenrye/ansible:latest \
  packer build \
    -var-file packer_cache/custom-ubuntu-20.04.2-live-server-amd64.iso.pkvars.hcl \
    -var-file packer_cache/cidata-proxmox.iso.pkvars.hcl \
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
