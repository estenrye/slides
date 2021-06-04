# packer-boxes

## Update vmid

increment `vmid` in `variables/ubuntu.20.04.json`

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

## create secrets.json

```json
{
  "ssh_password": "your_password"
}
```

## Building Ubuntu 20.04

```bash
packer build -var-file=secrets.json -var-file=variables/ubuntu.20.04.json ubuntu-20.04-amd64-proxmox.json
```

## If using default configuration:

```bash
packer build -var-file=variables/ubuntu.20.04.json ubuntu-20.04-amd64-proxmox.json
```

# after build is complete

- Add a cloud-init device
- Remove the cdrom.

# References

- https://www.burgundywall.com/post/using-cloud-init-to-set-static-ips-in-ubuntu-20-04
