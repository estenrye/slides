# Laptop Configuration

## For Surface Book, Install Custom Kernel

```bash
./prepare.sh
ANSIBLE_CONFIG=~/src/slides/ansible/ansible.cfg ansible-playbook \
  -e @~/.ansible/secrets/creds.yml \
  --vault-password-file ~/.ansible/secrets/secret.yml \
  --ask-become-pass \
  -i ~/src/slides/ansible/inventories/surface_book/inventory.yml \
  ~/src/slides/ansible/playbooks/laptop_config/install_surfacebook_kernel.yml
```

## Configure Laptop Software

```bash
ANSIBLE_CONFIG=~/src/slides/ansible/ansible.cfg ansible-playbook \
  -e @~/.ansible/secrets/creds.key \
  --vault-password-file ~/.ansible/secrets/secret.yml \
  --ask-become-pass \
  -i ~/src/slides/ansible/inventories/surface_book/inventory.yml \
  ~/src/slides/ansible/playbooks/laptop_config/configure.yml
```