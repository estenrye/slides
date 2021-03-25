#!/bin/bash
kind create cluster --name local --config cluster.kind.yml
kubectl apply -f manifests/calico-cni.yml --context kind-local
