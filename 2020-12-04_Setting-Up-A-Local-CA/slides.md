---
title: Setting Up a Local CA for etcd with cfssl
author: Esten Rye
date: Friday, December 4, 2020
---

# What is a Certificate Authority (CA)?

* A certificate authority (CA) is a trusted third party.
* A self-signed certificate that signs other certificates establishing a chain
  of trust.
* Systems that trust the CA certifiate will trust all certificates signed by it.

# What is the Difference Between a Root and Intermediate CA?

![Trust Chain](./images/root-certificate.png)
Image Credit: [DigiCert Blog, 2020-06-11](https://www.digicert.com/blog/impacts-of-root-certificate-expiration/#:~:text=Certificate%20authorities%20(CAs)%20adhere%20to,prepare%20for%20when%20they%20expire.)

# Root Certificate Authorities

* First link in the "trust chain".
  * A compromised Root CA, compromises the trust of all certificates behind it.
* Are typically used to sign Intermediate CAs.
  * Allows for stronger protection of the Root CA Certificate by delegating its
    trust to the Intermediate CA to sign certificates.
* Typically have long validity periods.
  * Usually 10 or 20 years.
  * Root CAs cannot sign Intermediate CAs for validity periods longer than their
    own.

# Intermediate Certificate Authorities

* Intermediate CAs are typically used to sign TLS Certificates.
* Intermediate CAs cannot be trusted without trusting the Root CA.
* A compromised Intermediate CA Certificate:
  * only compromises the trust of the certificates it signed.  
  * does not impact the trust of certificates signed by other Intermediate CAs 
    signed by the same Root CA.
* Typically have long validity periods.
  * Usually valid for half as long as the Issuing Root CA. Around 5-10 years.
  * Intermediate CAs cannot sign TLS Certificates for validity periods longer
    than their own.

# Validity Period Standard Practices

* Root and Intermediate CAs should renew their certificate values at half of
  their validity periods.
  * Ensures the same key pair is never used for a period longer than the
    intended original validity peropd.
  * Ensures the remaining validity period of the Issuing CA does not affect the
    validity of issued certificates.

| Certificate Type            | Validity Period | Renew At  |
| --------------------------- | --------------- | --------- |
| Root CA Certificate         | 20 years        | 10 years  |
| Intermediate CA Certificate | 10 years        | 5 years   |
| Issued TLS Certificate      | 5 years         | 2.5 years |

# Validity Period Suggested Practices

* Shortening the validity periods with automation enables Root CA Certificate
  to be reactive to changes in certificate standards.

| Certificate Type            | Validity Period | Renew At  |
| --------------------------- | --------------- | ----------- |
| Root CA Certificate         | 5 years         | 2.5 years   |
| Intermediate CA Certificate | 2.5 years       | 1.25 years  |
| Issued TLS Certificate      | 1 years         | 1 years     |

# Why not use LetsEncrypt for Peer TLS Certificates?

* etcd cluster would trust peers with any valid LetsEncrypt certificate.
* etcd peers are authenticated by certificate trust.
* Any host on the Internet could become a trusted peer.

# Why not use LetsEncrypt for Client TLS Certificates?

* etcd cluster would trust peers with any valid LetsEncrypt certificate.
* etcd clients are authenticated by certificate trust.
* etcd clients are mapped to users by the certificate's Common Name (CN)
* Any host on the Internet could become the root user.

# Install openssl and cfssl

* Install cfssl

  ```bash
  # update package cache
  sudo apt update

  # Install openssl and golang-cfssl packages.
  sudo apt install -y openssl golang-cfssl
  ```

# Create Root CA Certificate

* Create directory structure

  ```bash
  mkdir -p ca intermediate certificates
  mkdir -p intermediate/etcd intermediate/kubernetes intermediate/development
  mkdir -p certificates/etcd01 certificates/etcd02 certificates/etcd03
  ```

* Create a Root CA Certificate CSR
  `ca/ca-sr.json`

  ```json
  {
    "CN": "Ryezone Labs CA",
    "key": {
      "algo": "rsa",
      "size": 4096
    },
    "names": [
      {
        "C": "US",
        "L": "Bloomington",
        "O": "Ryezone Labs",
        "ST": "Minnesota"
      }
    ]
  }
  ```

* Generate Root CA Certificate

```bash
cfssl gencert -initca certificate_authority/ca/ca-sr.json \
  | cfssljson -bare certificate_authority/ca
```

# Create an Intermediate CA Certificate Signing Config File

* intermediate/config.json
  ```json
  {
    "signing": {
      "default": {
        "expiry": "21900h",
        "usages": [
          "signing",
          "key encipherment",
          "cert sign",
          "crl sign",
          "server auth",
          "client auth"
        ],
        "ca_constraint": {
          "is_ca": true
        }
      },
      "profiles": {
        "development": {
          "expiry":"21900h",
          "usages": [
            "signing",
            "key encipherment",
            "cert sign",
            "crl sign"
          ]
        }
      }
    }
  }
  ```

# Create Intermediate Certificate Signing Request

* intermediate/development/intermediate-ca-sr.json

  ```json
  {
    "CN": "Ryezone Labs Intermediate CA - Development",
    "key": {
      "algo": "rsa",
      "size": 4096
    },
    "names": [
      {
        "C": "US",
        "L": "Bloomington",
        "O": "Ryezone Labs",
        "ST": "Minnesota"
      }
    ]
  }
  ```
* Repeat for etcd and kubernetes

# Create the Intermediate Certificates

  ```bash
  cd intermediate/development
  # Generate CSR and Private Key
  cfssl genkey -initca intermediate-ca-sr.json | cfssljson -bare development
  # Sign Intermediate CA with Root CA and generate certificate
  cfssl sign -ca ../../ca/ca.pem -ca-key ../../ca/ca-key.pem \
    --config ../config.json -profile development development.csr \
    | cfssljson -bare development

  cd ../etcd
  # Generate CSR and Private Key
  cfssl genkey -initca intermediate-ca-sr.json | cfssljson -bare etcd
  # Sign Intermediate CA with Root CA and generate certificate
  cfssl sign -ca ../../ca/ca.pem -ca-key ../../ca/ca-key.pem \
    --config ../config.json etcd.csr \
    | cfssljson -bare etcd

  cd ../kubernetes
  # Generate CSR and Private Key
  cfssl genkey -initca intermediate-ca-sr.json | cfssljson -bare kubernetes
  # Sign Intermediate CA with Root CA and generate certificate
  cfssl sign -ca ../../ca/ca.pem -ca-key ../../ca/ca-key.pem \
    --config ../config.json kubernetes.csr \
    | cfssljson -bare kubernetes
  ```

# Create Certificate Signing Config File

* certificates/config.json

  ```json
  {
    "signing": {
      "profiles": {
        "server": {
          "expiry": "10950h",
          "usages": [
            "signing",
            "digital signing",
            "key encipherment",
            "server auth"
          ]
        },
        "peer": {
          "expiry": "10950h",
          "usages": [
            "signing",
            "digital signature",
            "key encipherment", 
            "client auth",
            "server auth"
          ]
        },
        "client": {
          "expiry": "10950h",
          "usages": [
            "signing",
            "digital signature",
            "key encipherment", 
            "client auth"
          ]
        }
      }
    }
  }
  ```

# Create etcd Server Certificate Signing Requests

```json
{
  "CN": "a.etcd.ryezone.com",
  "hosts": [
    "a.etcd.ryezone.com",
    "*.etcd.ryezone.com",
    "etcd.ryezone.com",
    "localhost",
    "127.0.0.1",
    "10.5.30.10"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Bloomington",
      "O": "Ryezone Labs",
      "ST": "Minnesota"
    }
  ]
}
```

Repeat for remaining servers in the cluster.

# Create etcd Peer Certificate Signing Requests

## Notes:

* When using the `--peer-cert-allowed-cn ${ALLOWED_CN}` flag, `CN` must match 
  the value of `${ALLOWED_CN}`.
* When using DNS Discovery using the `--discovery-srv ${CLUSTER_NAME}` flag,
  `hosts` must contain the value of `${CLUSTER_NAME}`.
* Peers will not be authenticated if the following are true:
  * No IP Addresses in the SAN field of the certificate match the remote IP.
  * Forward DNS Lookup does not match remote IP when only hostnames are present
    in the SAN field of the certificate.
  * Reverse lookup of remote IP returns no DNS names that match declared
    wildcard names in the SAN field of the certificate when peer certificate
    has only wildcard entries. 

```json
{
  "CN": "peer.etcd.ryezone.com",
  "hosts": [
    "a.etcd.ryezone.com",
    "*.etcd.ryezone.com",
    "etcd.ryezone.com",
    "10.5.30.10"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Bloomington",
      "O": "Ryezone Labs",
      "ST": "Minnesota"
    }
  ]
}
```

# Create etcd Server and Peer Certificates

```bash
export INTERMEDIATE_CA_CERT="../../intermediate/etcd/etcd.pem"
export INTERMEDIATE_CA_KEY="../../intermediate/etcd/etcd-key.pem"
export CERTIFICATE_CONFIG="../config.json"

cd certificates/a.etcd.ryezone.com
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=server certificate-sr.json \
  | cfssljson -bare server
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=peer peer-sr.json \
  | cfssljson -bare peer

cd ../b.etcd.ryezone.com
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=server certificate-sr.json \
  | cfssljson -bare server
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=peer peer-sr.json \
  | cfssljson -bare peer

cd ../c.etcd.ryezone.com
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=server certificate-sr.json \
  | cfssljson -bare server
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=peer peer-sr.json \
  | cfssljson -bare peer

cd ../root@etcd.ryezone.com
cfssl gencert -ca=${INTERMEDIATE_CA_CERT} -ca-key=${INTERMEDIATE_CA_KEY} \
  -config=${CERTIFICATE_CONFIG} -profile=client certificate-sr.json \
  | cfssljson -bare client
```

# Copy intermediate CA certificates and server/client/peer certificates to hosts.

```bash
export INTERMEDIATE_CA_PATH="intermediate/etcd/etcd.pem"
export TARGET_CA_CERT="/opt/etcd/certs/etcd-ca.crt"
export TARGET_SERVER_CERT="/opt/etcd/certs/etcd-server.crt"
export TARGET_SERVER_KEY="/opt/etcd/certs/etcd-server.key"
export TARGET_PEER_CERT="/opt/etcd/certs/etcd-peer.crt"
export TARGET_PEER_KEY="/opt/etcd/certs/etcd-peer.key"
export TARGET_CLIENT_CERT="/opt/etcd/certs/etcd-client.crt"
export TARGET_CLIENT_KEY="/opt/etcd/certs/etcd-client.key"

export USER="automation_user"
export TARGET="a.etcd.ryezone.com"

scp ${INTERMEDIATE_CA_PATH} ${USER}@${TARGET}:${TARGET_CA_CERT}
scp certificates/${TARGET}/server.pem ${USER}@${TARGET}:${TARGET_SERVER_CERT}
scp certificates/${TARGET}/server-key.pem ${USER}@${TARGET}:${TARGET_SERVER_KEY}
scp certificates/${TARGET}/peer.pem ${USER}@${TARGET}:${TARGET_PEER_CERT}
scp certificates/${TARGET}/peer-key.pem ${USER}@${TARGET}:${TARGET_PEER_KEY}
scp certificates/root@etcd.ryezone.com/client.pem ${USER}@${TARGET}:${TARGET_CLIENT_CERT}
scp certificates/root@etcd.ryezone.com/client-key.pem ${USER}@${TARGET}:${TARGET_CLIENT_KEY}
```

Repeat for remaining Hosts
# References

* [Certificate Authority with CFSSL](https://jite.eu/2019/2/6/ca-with-cfssl/)
* [The Impact of a Root Certificate Expiration](https://www.digicert.com/blog/impacts-of-root-certificate-expiration/#:~:text=Certificate%20authorities%20(CAs)%20adhere%20to,prepare%20for%20when%20they%20expire.)
* [CA Validity Period Extension and CA Certificate Renewal Process](https://www.experts-exchange.com/articles/32336/CA-Validity-Period-Extension-and-CA-Certificate-Renewal-Process.html)
* [Determining Certificate Validity Periods](https://www.serverbrain.org/certificate-security-2003/determining-certificate-validity-periods.html)
