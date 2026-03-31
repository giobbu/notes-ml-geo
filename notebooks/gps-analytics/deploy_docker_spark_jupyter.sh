#!/bin/bash

VOLUME_PATH=$1

echo "Deploying Jupyter Spark Notebook..."
docker run -p 8888:8888 -p 4040:4040 -v $VOLUME_PATH:/home/jovyan/work --name spark jupyter/pyspark-notebook
