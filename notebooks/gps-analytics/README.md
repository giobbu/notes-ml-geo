## Start Docker with Apache Spark and Jupyter Notebooks

```bash
docker run -p 8888:8888 -p 4040:4040 -v "$PWD":/home/jovyan/work --name spark jupyter/pyspark-notebook
```

```bash
docker ps

CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS                   PORTS                                            NAMES
59609a4995d4   jupyter/pyspark-notebook   "tini -g -- start-no…"   2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:4040->4040/tcp, 0.0.0.0:8888->8888/tcp   spark
```
open jupyter notebook in `http://127.0.0.1:8888/lab?token=<token>`

debug docker container
```bash
docker exec -it 59609a4995d4 bash
```