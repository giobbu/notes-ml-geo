# notes-ml-geo

## Image-wise Classification

* Starter notebook for image-wise classification tasks
* Feature engineering techniques to improve baseline models
* End-to-end pipeline using Kubeflow for scalable workflows

## GPS Analytics
* Starter notebook for generating GPS data sample and Polygons

## Setup Docker with Spark and Jupyter Notebook
You can find a detailed step-by-step guide in:

`notebooks/gps-analytics/README.md`

Otherwise, for one-shot deployment (from within `notebooks/gps-analytics`):
```bash
./deploy_docker_spark_jupyter.sh
```

## Setup kubeflow pipeline on kind cluster
You can find a detailed step-by-step guide in:

`notebooks/image-classification/README.md`

Otherwise, for one-shot deployment (from within `notebooks/image-classification`):
```bash
./deploy_kubeflow_pipeline.sh
```

Check pods status:
```bash
./check_pods_status.sh
```

Shutdown the cluster:
```bash
./shutdown_kind.sh
```
#### Notes
* Ensure Docker and Kind are installed and running
* Deployment may take a few minutes depending on your system
* Use the pod status script to wait until all services are ready





