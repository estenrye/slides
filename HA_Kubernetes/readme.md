# Setup:

1. Install python packages:  `pip install -r requirements.txt`

1. Install ansible galaxy roles: `ansible-galaxy install -r requirements.yml`

1. Provision machines:

   | machine name | IPv4 Address | Sizing |
   | --- | --- | --- |
   | haproxy01.dev.ryezone.com      | 10.5.99.18 | 2 cores x 2 GB memory |
   | haproxy02.dev.ryezone.com      | 10.5.99.19 | 2 cores x 2 GB memory |
   | kube-api.dev.ryezone.com       | 10.5.99.20 | N/A.  Virtual IP      |
   | controlplane01.dev.ryezone.com | 10.5.99.21 | 4 cores x 4 GB memory |
   | controlplane02.dev.ryezone.com | 10.5.99.22 | 4 cores x 4 GB memory |
   | controlplane03.dev.ryezone.com | 10.5.99.23 | 4 cores x 4 GB memory |
   | node01.dev.ryezone.com         | 10.5.99.31 | 8 cores x 8 GB memory |
   | node02.dev.ryezone.com         | 10.5.99.32 | 8 cores x 8 GB memory |
   | node03.dev.ryezone.com         | 10.5.99.33 | 8 cores x 8 GB memory |

1. Run Ansible: `ansible-playbook inventory.yml 02_initialize_cluster.yml`

# Useful Pages in the Lab

| URL | Description |
| --- | --- |
| kube-api.dev.ryezone.com:8000 | HAProxy Stats Page |

# Useful tips and tricks:

## Connect to monitoring dashboards without an ingress controller

### Connect to Grafana

```bash
kubectl get secret -n monitoring kube-prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl port-forward deployment/kube-prometheus-grafana 20080:3000 -n monitoring
```

# Tools to Consider:

- [Flux | GitOps Toolkit](https://toolkit.fluxcd.io/)

# Decisions Open

- Ubuntu Disk Encryption
  - Can it boot without user intervention?
  - How does this work with templates?
- Partition Strategy
  - Good Candidates
    - /
    - /var
    - /home
    - /swap partitions are unnecessary, these are replaced with /swapfile
- should we put files in /etc/skel to build a consitent terminal experience on servers.
  - include read only kube config?
  - install zsh?

# Decisions Made

- Note about Ansible Variables
- Operating System
- Container Runtime
- Topology

# Note about Ansible Variables

Whereever possible, keep the structure of variables as flat as possible.
Maps in variables inevitably cause problems.  Take this example:

In `group_vars/all.yml`:

```yaml
com:
  ryezone:
    node:
      ip_advertise_address: "{{ ansible_all_ipv4_addresses[0] }}"
    platform:
      environment: dev
      cloudflare:
        api_token: "{{ lookup ('env', 'CLOUDFLARE_API_TOKEN') }}"
        zone: ryezone.com
      keepalived:
        virtual_router_id: 50
        auth_pass: 42
        vip: 10.5.99.20

```

In `host_vars/controlplane01.yml`:

```yaml
---
com:
  ryezone:
    node:
      ip_advertise_address: 10.5.99.21
    platform:
      k8s:
        kube_api_server:
          keepalived:
            state: MASTER
            priority: 100
```

The default variable precedence behaviour will not merge these maps.
The host variables will clobber the group variables and tasks like the one below will fail:

```yaml
- name: echo vars
  hosts: initial_controlplane
  tasks:
    - name: echo vars
      debug:
        msg: "{{ com.ryezone.platform.environment }}.{{ com.ryezone.platform.cloudflare.zone }}"
```

Resulting in an error like this one:

```text
TASK [echo vars] ********************************************************************************************************************************************************************
task path: /home/esten/src/slides/HA_Kubernetes/cluster.yml:25
fatal: [controlplane01]: FAILED! => {
    "msg": "The task includes an option with an undefined variable. The error was: 'dict object' has no attribute 'environment'\n\nThe error appears to be in '/home/esten/src/slides/HA_Kubernetes/cluster.yml': line 25, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n        msg: \"{{ com }}\"\n    - name: echo vars\n      ^ here\n"
}
```

# Operating System

- Ubuntu 20.04

# Container Runtime

- Using CRI-O as the kubernetes runtime.
- Designed to 100% support the Kubernetes Container Runtime Interface
- Kubernetes support for dockershim deprecated in 1.20.  To be removed in 1.23.

# Topology

- [Options for HA Topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/)
- [Options for Software Load Balancing](https://github.com/kubernetes/kubeadm/blob/master/docs/ha-considerations.md#options-for-software-load-balancing)
- Selected a Stacked Topology for the Control Plane
- Stacked Topology
  - reduces the number of machines to provision
  - enables management of all controlplane components through Kubernetes

# Control Plane Nodes

| machine name | ip address | ports |
| --- | --- | --- |
| controlplane01.dev.ryezone.com | 10.5.50.1 | 6443, 64443 |
| controlplane02.dev.ryezone.com | 10.5.50.2 | 6443, 64443 |
| controlplane03.dev.ryezone.com | 10.5.50.3 | 6443, 64443 |

# Provision Machines

## HAProxy Load Balancers

###

### Configuration
- frontendName: kube-api.dev.ryezone.com
- port: 6443
- backendServers:
  - controlplane01.dev.ryezone.com
  - controlplane02.dev.ryezone.com
  - controlplane03.dev.ryezone.com
