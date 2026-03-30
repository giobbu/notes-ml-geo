#!/bin/bash

echo "Port forwarding Kubeflow Pipeline Backend to localhost:8888..."
kubectl port-forward -n kubeflow svc/ml-pipeline 8888:8888