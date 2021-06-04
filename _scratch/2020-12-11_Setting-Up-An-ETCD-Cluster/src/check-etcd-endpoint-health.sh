#!/bin/bash

# Gets health of all cluster nodes in an etcd cluster.

export REGISTRY="gcr.io/etcd-development/etcd"
export TAG="latest"
export CERT_DIR="/opt/etcd/certs"
export SRV_RECORD="etcd.ryezone.com"

docker run \
  -e ETCDCTL_API=3 \
  -v ${CERT_DIR}:/etcd-cert \
  --rm \
  ${REGISTRY}:${TAG} \
  etcdctl \
    --endpoints=a.etcd.ryezone.com:2379,b.etcd.ryezone.com:2379,c.etcd.ryezone.com:2379 \
    --cert=/etcd-cert/etcd-client.crt \
    --key=/etcd-cert/etcd-client.key \
    --cacert=/etcd-cert/etcd-ca.crt \
    --debug \
    endpoint health --cluster=true