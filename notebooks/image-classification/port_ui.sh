#!/bin/bash

echo "Port forwarding Kubeflow Pipeline UI to localhost:8080..."
kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80
