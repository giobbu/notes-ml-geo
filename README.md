# notes-ml-geo

## Image-wise Classification

* [Starter notebook for image-wise classification tasks](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/image-classification/0_sentinel2_quick_ml_starter.ipynb)
* [Feature engineering techniques to improve baseline models](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/image-classification/1a_sentinel2_feature_engineering.ipynb)
* [Different flavours of global interpretability](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/image-classification/1b_global_interpretability.ipynb)
* [In-Depth Model Analysis and Debugging  (inprogess)](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/image-classification/1c_full_debuggability.ipynb)
* [End-to-end pipeline using Kubeflow for scalable workflows (inprogess)](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/image-classification/2_kfp_sentil_pipeline.ipynb)

## GPS Analytics
* [Starter notebook for GPS processing with Polygons broadcasting](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/gps-analytics/gps_sample_analytics.ipynb)
* [Streamline timeseries forecasting with Feast](https://github.com/giobbu/notes-ml-geo/blob/main/notebooks/gps-analytics/spark_feast_forecast_ml.ipynb)


## Setup Docker with Spark and Jupyter Notebook
You can find a detailed step-by-step guide in:

`notebooks/gps-analytics/README.md`

Otherwise, for one-shot deployment (from within `notebooks/gps-analytics`):
```bash
./deploy_docker_spark_jupyter.sh "$PWD"
```

accessing PySpark inside the container:
```bash
docker exec -i -t <name-container> /usr/local/spark/bin/pyspark
```

access Spark UI:
```bash
http://localhost:4040
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





