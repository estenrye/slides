#!/bin/bash

# Explicitly moves the leader to the specified node.

export REGISTRY="gcr.io/etcd-development/etcd"
export TAG="latest"
export CERT_DIR="/opt/etcd/certs"
export SRV_RECORD="etcd.ryezone.com"
export NODE_ID="16be7b366a2c299f"

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
    move-leader ${NODE_ID}