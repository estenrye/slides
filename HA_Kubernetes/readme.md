# Topology

[Options for HA Topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/)
[Options for Software Load Balancing](https://github.com/kubernetes/kubeadm/blob/master/docs/ha-considerations.md#options-for-software-load-balancing)

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