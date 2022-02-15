#!/bin/bash
kubectl logs -n csi-driver-nfs -l app=csi-nfs-controller $@
