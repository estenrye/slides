#!/bin/bash

# Gets status of all cluster nodes in an etcd cluster.
# RAFT TERM:  This is the current election term of the cluster.
#             The Raft Term increments when a leader election occurs.

# RAFT INDEX: This is the current committed raft entry index for the node.
#             The raft index increments when a new entry is committed to the node.

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
    endpoint status --cluster=true --write-out=table