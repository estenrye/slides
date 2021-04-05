# Setup:

1. Install python packages:  `pip install -r requirements.txt`

1. Install ansible galaxy roles: `ansible-galaxy install -r requirements.yml`

1. Provision machines:

    Proxmox:

    ```bash
    terraform init
    terraform apply -auto-approve terraform/
    ```

1. Provision DNS Entries

    ```bash
    ansible-playbook rancher_01_dns.yml
    ansible-playbook rancher_02_haproxy.yml
    ansible-playbook 01_dns.yml
    ```

1. Provision Rancher RKE2 Cluster

