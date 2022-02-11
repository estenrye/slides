#!/bin/bash
kubectl get pod -o jsonpath='{.metadata.finalizers}' $@
