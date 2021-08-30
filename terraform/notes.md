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
  --offer debian \
  --sku 11-gen2 \
  --all \
  --query '[].{URN:urn}' \
  --output table
```

I selected: `Debian:debian-11-daily:11-gen2:0.20210819.739`


# Proxmox Package Repositories

- https://pve.proxmox.com/wiki/Package_Repositories
