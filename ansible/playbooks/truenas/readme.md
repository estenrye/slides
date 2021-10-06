# Configure TrueNAS VM with Passthrough HBA

## How to Provision a new TrueNAS VM

1. Run ansible playbook to create VM.

    ```bash
    ansible-playbook \
    -e @~/.ansible/secrets/creds.yml \
    -e kubernetes_zone=ryezone.com \
    -e truenas_iso=TrueNAS-SCALE-21.10-MASTER-20211004-015658.iso \
    --vault-password-file ~/.ansible/secrets/secret.key \
    -i localhost, \
    ~/src/slides/ansible/playbooks/truenas/provision_vm.yml
    ```

2. Start the VM

3. Install TrueNAS and configure root password.

4. Log into web interface.

5. Create an API key

6. Import pools manually.

7. Update your ansible vault.

## How to Configure a new TrueNAS VM

1. Run ansible playbook to configure services.

    ```bash
    ANSIBLE_CONFIG=~/src/slides/ansible/ansible-localhost.cfg \ 
    ansible-playbook \
      -e @~/.ansible/secrets/creds.yml \
      --vault-password-file ~/.ansible/secrets/secret.key \
      -i localhost, \
      ~/src/slides/ansible/playbooks/truenas/configure_truenas.yml
