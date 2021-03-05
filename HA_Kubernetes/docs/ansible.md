# Ansible Collection Documentation

- [ansible.posix](https://docs.ansible.com/ansible/latest/collections/ansible/posix/)
- [community.crypto](https://docs.ansible.com/ansible/latest/collections/community/crypto/)
- [community.general](https://docs.ansible.com/ansible/latest/collections/community/general/)
- [community.kubernetes](https://docs.ansible.com/ansible/latest/collections/community/kubernetes/)

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

