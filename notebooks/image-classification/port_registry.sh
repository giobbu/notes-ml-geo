#!/bin/bash

echo "Port forwarding Model Registry"
kubectl port-forward -n kubeflow svc/model-registry-service 3000:8080




