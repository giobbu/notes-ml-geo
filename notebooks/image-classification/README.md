## Kubeflow Pipelines Setup on Kind Cluster

### 1. Start Docker
```bash
open -a Docker
```

### 2. Create a Kind cluster with a mounted local dataset

#### Configure environment variable
```bash
# In .env
DATASET_PATH=<path/to/local/dataset>
# Load variables
source .env
```

#### Create the cluster
```bash
envsubst < kind-config.yaml | kind create cluster --config=-
```

Verify volume is mounted:
```bash
KIND_NODE=$(docker ps --filter name=kind-control-plane --format "{{.Names}}")
docker exec -it $KIND_NODE ls /data/persistent
```
Reference: https://www.tutorialpedia.org/blog/how-to-reference-a-local-volume-in-kind-kubernetes-in-docker/

### 3. Install Kubeflow Pipelines
Follow the official guide:
https://www.kubeflow.org/docs/components/pipelines/operator-guides/installation/#deploying-kubeflow-pipelines-in-kubernetes-native-api-mode
```bash
export PIPELINE_VERSION=2.15.0
kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/cluster-scoped-resources?ref=$PIPELINE_VERSION"
kubectl wait --for condition=established --timeout=60s crd/applications.app.k8s.io
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/instance=cert-manager -n cert-manager --timeout=300s
kubectl apply -k "github.com/kubeflow/pipelines/manifests/kustomize/env/cert-manager/platform-agnostic-k8s-native?ref=$PIPELINE_VERSION"`
```

### 4. Verify pods are running
```bash
kubectl get pods -n kubeflow
```
Wait until all pods show `STATUS = Running`.

### 5. Configure persistent storage (PV & PVC)
```bash
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml

kubectl get pvc -n kubeflow
```

### 6. Access the services (port-forwarding) 
#### Kubeflow UI
```bash
kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80
```

#### Backeknd API
```bash
kubectl port-forward -n kubeflow svc/ml-pipeline 8888:8888
```

### 7. Open the UI
Go to:
```bash
http://localhost:8080
```

### Debugging
```bash
kubectl get pods -n kubeflow | grep etl
kubectl describe pod <pod-name> -n kubeflow
```
