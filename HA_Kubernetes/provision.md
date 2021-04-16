# Setup:

1. Install python packages:  `pip install -r requirements.txt`

1. Install ansible galaxy roles: `ansible-galaxy install -r requirements.yml`

1. Provision machines:

    Proxmox:

    ```bash
    terraform init
    terraform apply -auto-approve terraform/
    ```

1. Provision Rancher Management Controlplane

    ```bash
    ansible-playbook -i rancher_inventory.yml rancher_01_dns.yml
    ansible-playbook -i rancher_inventory.yml rancher_02_haproxy.yml
    ansible-playbook -i rancher_inventory.yml rancher_03_rke2.yml
    ansible-playbook -i rancher_inventory.yml rancher_04_rke2_additional_nodes.yml
    ansible-playbook -i rancher_inventory.yml rancher_05_undrain-additional-controlplane-nodes.yml
    ansible-playbook -i rancher_inventory.yml rancher_06_install_apps.yml
    ```

1. Provision Rancher Dev Cluster

    ```bash
    ansible-playbook -i dev-cluster_inventory.yml rancher_01_dns.yml
    ansible-playbook -i dev-cluster_inventory.yml rancher_02_haproxy.yml
    ansible-playbook -i dev-cluster_inventory.yml rancher_03_rke2.yml
    ansible-playbook -i dev-cluster_inventory.yml rancher_04_rke2_additional_nodes.yml
    ansible-playbook -i dev-cluster_inventory.yml rancher_05_undrain-additional-controlplane-nodes.yml
    ansible-playbook -i dev-cluster_inventory.yml rancher_06_install_apps.yml
    ```
