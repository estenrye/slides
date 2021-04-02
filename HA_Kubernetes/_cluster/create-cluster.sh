#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

kind create cluster --name local --config ${SCRIPT_DIR}/cluster.kind.yml
kubectl apply -f ${SCRIPT_DIR}/manifests/allow-kublet-server-csrs.yml --context kind-local
kubectl apply -f ${SCRIPT_DIR}/manifests/calico-cni.yml --context kind-local
kubectl apply -f ${SCRIPT_DIR}/manifests/kube-bench.yml --context kind-local
kubectl get job -w --context kind-local
