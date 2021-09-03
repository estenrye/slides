# Create an Azure Service Principal

- [Azure Documentation - Create a Service Principal](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#create-a-service-principal)

```bash
docker run --rm -it estenrye/ansible bash
az login
az ad sp create-for-rbac --name sp_proxmox_nested_virtualization_lab --role Contributor
exit
```

# Login as an Azure Service Principal

```bash
docker run --rm -it \
  -e AZ_TENNANT_ID=your-tennant-id-here \
  -e AZ_APP_ID=your-id-here \
  -e AZ_PASSWORD=your-password \
  estenrye/ansible \
  bash

az login --service-principal \
  --tennant  $AZ_TENNANT_ID \
  --username $AZ_APP_ID \
  --password $AZ_PASSWORD
```

# List Azure Regions

```bash
az account list-locations --query '[].{Location:displayName,Name:name}' --output table
```

I selected: `northcentralus`

# List VM Sizes with Nested Virtualization support in northcentralus

```bash
az vm list-sizes --location northcentralus --query '[].{Name:name,CPU:numberOfCores,Memory:memoryInMb}' --output table | grep _v3
```

I selected `Standard_D16_v3`

# List the images available in northcentralus

```bash
az vm image list \
  --location northcentralus \
  --publisher Debian \
  --offer debian-11-daily \
  --sku 11-gen2 \
  --all \
  --query '[].{URN:urn}' \
  --output table
```

I selected: `Debian:debian-11-daily:11-gen2:0.20210819.739`

# Running the terraform init

```bash
docker run --rm -t \
  --mount type=bind,source=`readlink -f ~/src/slides/terraform`,target=/ansible \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh`,target=/home/automation-user/.ssh \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i localhost, \
    /ansible/tf-init.yml
```

# Running the terraform plan

```bash
docker run --rm -t \
  --mount type=bind,source=`readlink -f ~/src/slides/terraform`,target=/ansible \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh`,target=/home/automation-user/.ssh \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i localhost, \
    /ansible/tf-plan.yml
```

# See the output of the terraform plan

```bash
docker run --rm -t \
  --mount type=bind,source=`readlink -f ~/src/slides/terraform`,target=/ansible \
  estenrye/ansible:latest \
  terraform show /ansible/tf.plan
```

# Running the terraform apply

```bash
docker run --rm -t \
  --mount type=bind,source=`readlink -f ~/src/slides/terraform`,target=/ansible \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh`,target=/home/automation-user/.ssh \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i localhost, \
    /ansible/tf-apply.yml
```

# Running the terraform destroy

```bash
docker run --rm \
  --mount type=bind,source=`readlink -f ~/src/slides/terraform`,target=/ansible \
  --mount type=bind,source=`readlink -f ~/.ansible/secrets`,target=/secrets \
  --mount type=bind,source=`readlink -f ~/.ssh`,target=/home/automation-user/.ssh \
  estenrye/ansible:latest \
  ansible-playbook \
    -e @/secrets/creds.yml \
    --vault-password-file /secrets/secret.key \
    -i localhost, \
    /ansible/tf-destroy.yml
```

# Install Proxmox

- https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_Buster
- https://pve.proxmox.com/wiki/Package_Repositories
