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

| URL | Description | Username | Password |
| --- | --- | --- | --- |
| https://alertmanager.dev.ryezone.com | Alertmanager Dashboard | | |
| https://grafana.dev.ryezone.com | Grafana Dashboard | admin | `kubectl get secret -n monitoring kube-prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo` |
| http://kube-api.dev.ryezone.com:8000 | HAProxy Stats Page | | |
| https://prometheus.dev.ryezone.com | Prometheus Dashboard | | |

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
- What service mesh should we do?

# Decisions Made

- Note about Ansible Variables
- Operating System
- Container Runtime
- Topology
- Ingress Controller
- Certificate Manager

# What is Kubernetes

## Videos

- [Kubernetes Deconstructed: Undedrstanding Kubernetes by Breaking it Down (abridged)](https://www.youtube.com/watch?v=90kZRyPcRZw), Carson Anderson, DOMO, Dec 15, 2017
- [Kubernetes Deconstructed: Undedrstanding Kubernetes by Breaking it Down (full)](https://vimeo.com/245778144/4d1d597c5e)

## Blog Posts

- [Your instant Kubernetes cluster](https://blog.alexellis.io/your-instant-kubernetes-cluster/), Alex Ellis, Jan 27, 2018

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

# Ingress Controller

- Selected the Kubernetes ingress-nginx project as the ingress controller.
- Created a custom ingress default backend container.
- Configured Node Ports 32080 for HTTP and 32443 for HTTPS

# Certificate Manager

# Service Mesh

