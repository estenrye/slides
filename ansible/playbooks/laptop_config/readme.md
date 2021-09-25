# Laptop Configuration

## For Surface Book, Install Custom Kernel

```bash
./prepare.sh
ANSIBLE_CONFIG=~/src/slides/ansible/ansible-localhost.cfg ansible-playbook \
  -e @~/.ansible/secrets/creds.yml \
  --vault-password-file ~/.ansible/secrets/secret.key \
  --ask-become-pass \
  -i ~/src/slides/ansible/inventories/surface_book/inventory.yml \
  ~/src/slides/ansible/playbooks/laptop_config/install_surfacebook_kernel.yml
```

The secure-boot certificate has been installed to

```text
/usr/share/linux-surface-secureboot/surface.cer
```

It will now be automatically enrolled for you and guarded with the password

```text
surface
```

To finish the enrollment process you need to reboot, where you will then be
asked to enroll the certificate. During the import, you will be prompted for
the password mentioned above. Please make sure that you are indeed adding
the right key and confirm by entering 'surface'.

Note that you can always manage your secure-boot keys, including the one
just enrolled, from inside Linux via the 'mokutil' tool.

## Configure Laptop Software

```bash
ANSIBLE_CONFIG=~/src/slides/ansible/ansible-localhost.cfg ansible-playbook \
  -e @~/.ansible/secrets/creds.yml \
  --vault-password-file ~/.ansible/secrets/secret.key \
  --ask-become-pass \
  -i ~/src/slides/ansible/inventories/surface_book/inventory.yml \
  ~/src/slides/ansible/playbooks/laptop_config/configure.yml
```