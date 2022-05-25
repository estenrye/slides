# Platform9 Kubernetes Cluster Automation

This repo contains the automation required to build Platform9 Kubernetes clusters
in my home lab.

## Building Docker Image

To build autoinstall iso files, we need a consistent build environment.  This
build environment has been automated in [./Dockerfile](./Dockerfile) and includes
all of the applications required to unpack, modify and repack the Ubuntu Install
ISO.

To build the build environment, use the following command:

```bash
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
DOCKER_BUILDKIT=1 docker build -t estenrye/platform9-ansible ${LAB_AUTOMATION_DIR}/ansible/playbooks/platform9
```

## Running the image.

You will need to create an Ansible vault with the following variables:

```yaml
cloudflare_api_token: your-token-here
pihole_admin_password: your-password-here
truenas_api_key: your-trunas-scale-api-key-here
pf9_fqdn: https://pmkft-id-id.platform9.io
pf9_username: youremail@example.com
pf9_password: your-pf9-password
```

For instructions on how to create an Ansible Vault file, read this [tutorial](../../../docs/ansible/creating-an-ansible-vault-file.md).

The following code will execute the automation:

```bash
ANSIBLE_SECRETS_DIR=`realpath ~/.ansible/secrets`
LAB_AUTOMATION_DIR=`realpath ~/src/slides`
SSH_KEY_PATH=`realpath ~/.ssh/id_rsa`
CLUSTER='esten-growth'

# temporarily mounting helm directories.
docker run --rm -it --platform=linux/amd64 \
  --mount type=bind,source=${ANSIBLE_SECRETS_DIR},target=/secrets,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible/playbooks/platform9,target=/ansible,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/ansible/roles,target=/etc/ansible/roles,readonly \
  --mount type=bind,source=${LAB_AUTOMATION_DIR}/helm,target=/helm,readonly \
  --mount type=bind,source=`realpath ~/.kube/home`,target=/kube,readonly \
  estenrye/ansible \
  ansible-playbook \
    -e @/secrets/${CLUSTER}.yml \
    -i /ansible/inventory.yml \
    --ask-vault-password \
    --limit deployer \
    playbook.yml
```


# Core Components

## Install a Load Balancer Plugin: Metal LB

This is included in my Platform9 Kubernetes cluster.

## Install an Ingress Controller  ingress-nginx

## Install a Storage Class: nfs-csi

Open Source Software that explicitly takes a dependency:

- Cloudnative-PG Operator
- Redis Operator
- Harbor

Open Source Software that implicitly takes a dependency:

- LDAP Server
- OIDC Provider

## Install an RDBMS Operator: Adding the CloudNative-pg Operator

PostgreSQL is an open source database that enjoys wide support from common
DevOps tools.  the CloudNative-PG operator was originally built by EDB, then
released open source unde the Apache License 2.0 and submitted for CNCF
Sandbox in April 2022.

Postgres will form one of the core tenants of my home-lab platform and
provide the majority of my RDBMS needs.

OpenSource software that explicitly takes a dependency:

- Harbor
- LDAP Server
- Smallstep Certificates

OpenSource software that implicitly takes a dependency:

- OIDC Provider

Links:

- [CloudNativePG Documentation: v1.15.0](https://cloudnative-pg.io/documentation/1.15.0/)
- [CloudNativePG Installation on Kubernetes](https://cloudnative-pg.io/documentation/1.15.0/installation_upgrade/)
- [CloudNativePG Helm Chart](https://github.com/cloudnative-pg/charts)

Future Project Ideas

- Build an OpenLDAP container that can connect to a highly available
  PostgresSQL backend.

## Install an LDAP Server

## Install an OIDC Provider

## Install SmallStep Certificates CA

## Install an In-Memory data store: Redis-Operator

Redis is an open source, in-memory data store used by millions of developers
as a database, cache, streaming engine, and message broker.  It is often used
as a real-time data store for applications that require low-latency and high
throughput.  It is often the open source solution for caching and session
storage, and can be used for streaming and messaging to enable high-speed
data ingestion, messaging, event-sourcing and notification use cases.

OpenSource software that explicitly takes Redis as a dependency:

- Harbor

Links:

- [Redis Documentation](https://redis.io/docs/)
  - [High Availability](https://redis.io/docs/manual/sentinel/)
  - [Security](https://redis.io/docs/manual/security/)
    - [TLS](https://redis.io/docs/manual/security/encryption/)
      - Can I use SmallStep as the CA to manage certificate rotation with ACME?
      - Do I need a dedicated Smallstep CA for Redis Client TLS Authentication?
      - Do I need a dedicated Smallstep CA for Redis Server TLS?
  - [Persistence](https://redis.io/docs/manual/persistence/)

Three Operators to Evaluate:

- [Github: spotahome/redis-operator](https://github.com/spotahome/redis-operator)
- [Github: ot-container-kit/redis-operator](https://github.com/ot-container-kit/redis-operator)
  - [Documentation](https://ot-container-kit.github.io/redis-operator/)
  - [OperatorHub](https://operatorhub.io/operator/redis-operator)
- [Github: ucloud/redis-operator](https://github.com/ucloud/redis-operator)

## Install a Cloud Native Repository: Harbor, Notary

Harbor is an open source registry that secures artifacts with policies and
role-based access control, ensures images are scanned and free from
vulnerabilities, and signs images as trusted. Harbor, a CNCF Graduated
project, delivers compliance, performance, and interoperability to help you
consistently and securely manage artifacts across cloud native compute
platforms like Kubernetes and Docker.

[Install Harbor HA on Kubernetes](https://goharbor.io/docs/2.5.0/install-config/harbor-ha-helm/)

Ways to use Smallstep to secure Harbor

- [Configure HTTPS Access to Harbor](https://goharbor.io/docs/2.5.0/install-config/configure-https/)
- [Configure Internal TLS communication between Harbor Component](https://goharbor.io/docs/2.5.0/install-config/configure-internal-tls/)

## Install Cert-Manager

## Install a DNS Server: PiHole
