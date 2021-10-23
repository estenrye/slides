# truenas_container_storage_interface

This role automates the installation of the democratic-csi Container Storage
Interface for a Kubernetes cluster.  This role integrates my virtualized
TrueNAS instance with my RKE2 Kubernetes clusters.

## Related Helm Charts

- [democratic-csi/democratic-csi](https://github.com/democratic-csi/democratic-csi)

## Required Ansible Vault Keys

| Key Name | Description | Example |
| --- | --- | --- |
| truenas_url | This is the fully qualified uri to the TrueNAS Scale instance. | `https://nas.ryezone.com` |
| truenas_trust_cert | This tells ansible and the helm chart whether the TLS certificate should be validated. | `true` |
| truenas_api_key | This root api key authenticates the Container Storage Interface to TrueNAS Scale | `redacted` |

