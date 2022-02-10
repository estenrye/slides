#!/bin/bash
kubectl logs -n democratic-csi -l app.kubernetes.io/csi-role=controller $@
