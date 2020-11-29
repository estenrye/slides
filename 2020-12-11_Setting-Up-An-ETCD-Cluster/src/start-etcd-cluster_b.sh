export REGISTRY="gcr.io/etcd-development/etcd"
export TAG="latest"
export DATA_DIR="/opt/etcd/data/etcd-data"
export CERT_DIR="/opt/etcd/certs"
export NODE_NAME="b.etcd.ryezone.com"
export DISCOVERY_SRV_ZONE="etcd.ryezone.com"
export CLUSTER_TOKEN="etcd-ryezone-com"
export ALLOWED_CN="peer.etcd.ryezone.com"

docker run \
  --name etcd \
  --detach \
  --restart always \
  -p 2379:2379 -p 2380:2380 \
  -v ${DATA_DIR}:/etcd-data \
  -v ${CERT_DIR}:/etcd-cert \
  ${REGISTRY}:${TAG} \
  /usr/local/bin/etcd \
    --data-dir=/etcd-data \
    --name ${NODE_NAME} \
    --discovery-srv=${DISCOVERY_SRV_ZONE} \
    --initial-advertise-peer-urls https://${NODE_NAME}:2380 \
    --initial-cluster-token ${CLUSTER_TOKEN} \
    --initial-cluster-state new \
    --advertise-client-urls https://${NODE_NAME}:2379 \
    --listen-client-urls https://0.0.0.0:2379 \
    --listen-peer-urls https://0.0.0.0:2380 \
    --peer-cert-allowed-cn ${ALLOWED_CN} \
    --peer-cert-file=/etcd-cert/etcd-peer.crt \
    --peer-key-file=/etcd-cert/etcd-peer.key \
    --peer-trusted-ca-file=/etcd-cert/etcd-ca.crt \
    --peer-client-cert-auth \
    --client-cert-auth \
    --cert-file=/etcd-cert/etcd-server.crt \
    --key-file=/etcd-cert/etcd-server.key \
    --trusted-ca-file=/etcd-cert/etcd-ca.crt