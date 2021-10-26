#!/bin/bash
kubectl proxy &
sleep 5
curl --header "Content-Type: application/json-patch+json" \
    --request PATCH \
    --data '[{"op": "add", "path": "/status/capacity/nitrokey.com~1hsm", "value": "2"}]' \
    http://localhost:8001/api/v1/nodes/${NODE}/status
