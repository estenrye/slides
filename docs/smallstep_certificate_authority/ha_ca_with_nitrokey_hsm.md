# HA Smallstep Certificate Authority with HSM on Proxmox

## Hardware installation

### Materials
- 1 Dell R610 Server
- Proxmox 6.3-6
- 3 Nitrokey HSM2 hardware security modules
- 3 Virtual Machines running Ubuntu 20.04 running as a Kubernetes controlplane.
- 3 Virtual Machines running Ubuntu 20.04 running as Kubernetes worker nodes.

## Installing the HSM devices in the Dell R610

1. Label each HSM with a labeler.  I labeled each of my 3 keys CP01, CP02 and CP03 respectively.
2. I installed each key one at a time and then passed the USB port directly to the worker node I was mapping the HSM to.  For my environment:

| HSM Device | Proxmox USB Port | Virtual Machine | Key Serial |
| --- | --- | --- | --- |
| CP01 | host=2-1,usb3=1 | node01.common.ryezone.com |
| CP02 | host=5-1,usb3=1 | node02.common.ryezone.com | 
| CP03 | host=1-3.1,usb3=1 | node03.common.ryezone.com |

3. Reboot each node for the hardware changes to take effect.


## Initializing the HSM

https://raymii.org/s/articles/Get_Started_With_The_Nitrokey_HSM.html

### Manual Steps

1. On node01, create a dkek share.  Export to a safe location and copy to node02 and node03.

```bash
sc-hsm-tool --create-dkek-share dkek-share-1.pbe
openssl base64 -A -in dkek-share-1.pbe
```

2. On each node, initialize each HSM with a dkek share.  Note that this will wipe the HSM

```bash
HSM_SOPIN=3537363231383830
HSM_PIN=648219
sc-hsm-tool --initialize --so-pin="${HSM_SOPIN}" --pin="${HSM_PIN}" --dkek-shares=1 --label=lab-hsm

```

3. On each node, import the dkek share into each HSM.

```bash
sc-hsm-tool --so-pin="${HSM_SOPIN}" --pin="${HSM_PIN}" --import-dkek-share=/home/automation-user/.hsm/dkek-share-1.pbe
```

### The following steps can be automated

4. On node01, generate the RSA Key for Bitnami Bank Vaults

```bash
pkcs11-tool \
  --module opensc-pkcs11.so \
  --login \
  --pin ${HSM_PIN} \
  --keypairgen \
  --key-type rsa:2048 \
  --token-label lab-hsm \
  --label bank-vaults
```

5. Create an encrypted backup

```bash
mkdir -p /home/automation-user/.hsm
sc-hsm-tool --wrap-key=/home/automation-user/.hsm/wrap-key-1_bank-vaults.bin --key-reference=1 --pin=${HSM_PIN}
```

6. Copy encrpyted backup to nodes02 and 03

```bash
rm -rf /home/automation-user/.hsm
scp -r automation-user@node01.common.ryezone.com:/home/automation-user/.hsm
ssh automation-user@node02.common.ryezone.com -C rm -rf /home/automation-user/.hsm
ssh automation-user@node03.common.ryezone.com -C rm -rf /home/automation-user/.hsm
scp -r .hsm automation-user@node02.common.ryezone.com:/home/automation-user/.hsm
scp -r .hsm automation-user@node03.common.ryezone.com:/home/automation-user/.hsm
```

7. Initialize and restore on node02/node03

```bash
ssh automation-user@node02.common.ryezone.com
sc-hsm-tool --so-pin="${HSM_SOPIN}" --pin="${HSM_PIN}" --import-dkek-share=/home/automation-user/.hsm/dkek-share-1.pbe
sc-hsm-tool --unwrap-key=/home/automation-user/.hsm/wrap-key-1_bank-vaults.bin --key-reference=1 --pin=${HSM_PIN} --force
```