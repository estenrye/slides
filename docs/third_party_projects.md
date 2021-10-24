# Helm Charts

## [democratic-csi/democratic-csi](https://github.com/democratic-csi/democratic-csi)

democratic-csi implements the csi (container storage interface) spec providing
storage for various container orchestration systems (ie: Kubernetes).  This
provides my longer term persistent storage using a virtualized TrueNAS Scale
instance.

Used in these Roles:
  - [truenas_container_storage_interface](../ansible/roles/truenas_container_storage_interface/readme.md)

## [banzaicloud/bank-vaults](https://github.com/banzaicloud/bank-vaults)

Bank-Vaults is an umbrella project which provides various tools for Vault to
make using and operating Hashicorp Vault easier. It's a wrapper for the official
Vault client with automatic token renewal and built-in Kubernetes support,
dynamic database credential provider for Golang database/sql based clients.
It has a CLI tool to automatically initialize, unseal, and configure Vault. It
also provides a Kubernetes operator for provisioning, and a mutating webhook for
injecting secrets.

In this project, bank-vaults is implemented on top of an RKE2 Kubernetes cluster

Related Projects:
  - [OpenSC/OpenSC](https://github.com/OpenSC/OpenSC)

Required Hardware:
  - [Nitrokey HSM2](https://shop.nitrokey.com/shop/product/nk-hsm-2-nitrokey-hsm-2-7)

Guides:
  - [Getting Started with the NitroKey HSM](https://raymii.org/s/articles/Get_Started_With_The_Nitrokey_HSM.html)
  - [SmartCardHSM Initialize the Device](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM#initialize-the-device)
  - [Banzai Cloud NitroKey HSM support](https://banzaicloud.com/docs/bank-vaults/hsm/nitrokey-opensc/)
