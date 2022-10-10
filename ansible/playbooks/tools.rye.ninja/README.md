# Secrets

```yaml
# The SO-PIN must be composed of 16 hexadecimal characters.
# The value is internally converted into an 8 byte key value.
# The SO-PIN has a retry counter of 15 and can not be unblocked.
# Blocking the SO-PIN will prevent any further token initialization
# or PIN unblock.
nitrokey_hsm_sopin:

# while changing the PIN later is possible, changing its size (length) is not.
# Current card version 1.2 does not allow this without reinitializing the card.
# Nitrokey Pro's and Storage's PINs can be up to 20 digits long and can consist
# of numbers, characters and special characters. Note: When using GnuPG or
# OpenSC, 32 character long PINs can be used but aren't supported by Nitrokey
# App.
nitrokey_hsm_pin:

nitrokey_hsm_dkek_share_password:
nitrokey_hsm_dkek_share_b64:
```

# Running the playbook


```bash
docker run --rm -it \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible,target=/ansible \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets \
  --mount type=bind,source=${SSH_KEY_PATH},target=/root/.ssh/id_rsa \
  -e ANSIBLE_CONFIG=/ansible/ansible.cfg \
   estenrye/ansible:v0.2.15 \
  ansible-playbook \
    --ask-vault-password \
    -e @/secrets/cd-homelab.yml \
    -i /ansible/playbooks/tools.rye.ninja/inventory.yml \
    /ansible/playbooks/tools.rye.ninja/playbook.yml
```
