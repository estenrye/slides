export REGISTRY="gcr.io/etcd-development/etcd"
export TAG="latest"
export CERT_DIR="/opt/etcd/certs"
export NODE_NAME="c.etcd.ryezone.com"

docker run --rm \
  -e ETCDCTL_API=3 \
  -v ${CERT_DIR}:/etcd-cert \
  ${REGISTRY}:${TAG} \
  /usr/local/bin/etcdctl \
    --debug \
    --endpoints https://${NODE_NAME}:2379 \
    --cert=/etcd-cert/etcd-client.crt \
    --key=/etcd-cert/etcd-client.key \
    --cacert=/etcd-cert/etcd-ca.crt \
    put bar foo