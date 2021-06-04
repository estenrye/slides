# Basic Architectural Components

- Identity Engine ==> SPIFFE/SPIRE
- Enforcement ==> load balancer, proxy, firewall, application
- Policy Engine  ==> OPA
- Data Stores ==> ?

# Identity Engine

- Need to understand the WHO in order to implement policy.
- SPIFFE is a framework for strong workload authentication.
- SPIRE is an implementation of SPIFFE.
- SPIRE agents expose a workload API for workloads to request an SVID
  (SPIFFE Identification Document)

# Implement Hashicorp Consul

- [Installing Consul on Kubernetes](https://www.consul.io/docs/k8s/installation/install), Hashicorp
- [Helm Chart Configuration](https://www.consul.io/docs/k8s/helm), Hashicorp

# Implement Hashicorp Vault

- [Announcing the HashiCorp Vault Helm Chart](https://www.hashicorp.com/blog/announcing-the-vault-helm-chart), Hashicorp, 2019-08-06
- [Vault on Kubernetes Reference Architecture](https://learn.hashicorp.com/tutorials/vault/kubernetes-reference-architecture?in=vault/kubernetes), Hashicorp
- [Vault on Kubernetes Deployment Guide](https://learn.hashicorp.com/tutorials/vault/kubernetes-raft-deployment-guide?in=vault/kubernetes), Hashicorp


# Implement an Intermediate Only Certificate Authority in Hashicorp Vault

- [Build Your Own Certificate Authority (CA)](https://learn.hashicorp.com/tutorials/vault/pki-engine), HashiCorp

# Deploying Postgres

- Use PostgreSQL 13.1
- [Getting Started with PostgreSQL Streaming Replication](https://scalegrid.io/blog/getting-started-with-postgresql-streaming-replication/), ScaleGrid, 2018-09-13
- [How to Set Up Streaming Replication in PostgreSQL 12](https://www.percona.com/blog/2019/10/11/how-to-set-up-streaming-replication-in-postgresql-12/), Percona, 2019-10-11
- [Streaming Replicaition on PostgresSQL wiki.](https://wiki.postgresql.org/wiki/Streaming_Replication), PostgresSQL, 2020-07-06
- [How To Configure PostgreSQL 12 Streaming Replication in CentOS 8](https://www.tecmint.com/configure-postgresql-streaming-replication-in-centos-8/), TecMint, 2020-06-20

# Deploying SPIRE in a Highly Available Configuration

- [Getting SPIRE](https://spiffe.io/docs/latest/spire/installing/using_spire/), spiffe.io
- [Quickstart for Kubernetes](https://spiffe.io/docs/latest/spire/installing/getting-started-k8s/), spiffe.io
- [SPIRE Tutorials](https://github.com/spiffe/spire-tutorials), spiffe.io

# References

- [Introduction to SPIFFE and SPIRE Projects (Lightboard)](https://youtu.be/Q2SiGeebRKY), Evan Gilman
- [OPA & SPIRE, Decoupled Authentication & Authorization for cloud native enterprises](https://youtu.be/atbjE2P0dtk), Ash Narkar, 2020-05-04