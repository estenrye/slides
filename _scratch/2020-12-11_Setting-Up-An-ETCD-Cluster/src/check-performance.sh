#!/bin/bash

# Tests performance against expected performance profiles documnented at
# https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/hardware.md#example-hardware-configurations

export REGISTRY="gcr.io/etcd-development/etcd"
export TAG="latest"
export CERT_DIR="/opt/etcd/certs"
export SRV_RECORD="etcd.ryezone.com"
export CLUSTER_SIZE="m"

docker run \
  -e ETCDCTL_API=3 \
  -v ${CERT_DIR}:/etcd-cert \
  --rm \
  ${REGISTRY}:${TAG} \
  etcdctl \
    --discovery-srv ${SRV_RECORD} \
    --cert=/etcd-cert/etcd-client.crt \
    --key=/etcd-cert/etcd-client.key \
    --cacert=/etcd-cert/etcd-ca.crt \
    check perf --load=${CLUSTER_SIZE}