#!/bin/bash

echo "Deploying Kubeflow Pipeline..."

echo "-------------------------------"
echo "0. Start Docker "
open -a Docker

echo "-------------------------------"
echo "1. Configure env variables"
source .env

echo "-------------------------------"
echo "2. Create kind cluster"
kind delete cluster
envsubst < kind-config.yaml | kind create cluster --config=-

echo "-------------------------------"
echo "3. Check Volume is created"
KIND_NODE=$(docker ps --filter name=kind-control-plane --format "{{.Names}}")
docker exec -it $KIND_NODE ls /data/persistent

echo "-------------------------------"
echo "4. Install Kubeflow Pipelines"
export PIPELINE_VERSION=2.15.0
kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/cluster-scoped-resources?ref=$PIPELINE_VERSION"
kubectl wait --for condition=established --timeout=60s crd/applications.app.k8s.io
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/instance=cert-manager -n cert-manager --timeout=300s
kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/env/cert-manager/platform-agnostic-k8s-native?ref=$PIPELINE_VERSION"

echo "-------------------------------"
echo "5. Wait until all pods are running"
while true; do
  echo "Checking pod status..."
  # Remove header
  STATUSES=$(kubectl get pods -n kubeflow --no-headers)
  TOTAL=$(echo "$STATUSES" | wc -l)
  # Extract STATUS column (3rd column)
  RUNNING=$(echo "$STATUSES" | awk '{print $3}' | grep -c "^Running$")
  if [ "$TOTAL" -eq "$RUNNING" ] && [ "$TOTAL" -ne 0 ]; then
    echo "all pods are running"
    break
  else
    echo "$RUNNING / $TOTAL pods are running..."
  fi
  sleep 20
done

echo "-------------------------------"
echo "6. Create PV"
kubectl apply -f pv.yaml
kubectl get pv -n kubeflow

echo "-------------------------------"
echo "7. Create PVC"
kubectl apply -f pvc.yaml
kubectl get pvc -n kubeflow

echo "-------------------------------"
echo "Port forwarding Kubeflow Pipeline UI to localhost:8080..."
chmod +x port_ui.sh
nohup ./port_ui.sh > port_ui.log 2>&1 &

echo "-------------------------------"
echo "Port forwarding Kubeflow Pipeline Backend to localhost:8888..."
chmod +x port_backend.sh
nohup ./port_backend.sh > port_backend.log 2>&1 &


echo "-------------------------------"
echo "Kubeflow Pipeline deployed successfully!"
echo "Access the UI at http://localhost:8080"
