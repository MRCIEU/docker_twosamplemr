# Dockerfile for TwoSampleMR

## Usage

This is the Dockerfile for the [TwoSampleMR dockerhub image](https://hub.docker.com/r/mrcieu/twosamplemr), which can be run with

```bash
docker run -it mrcieu/twosamplemr R
```

or run a specific tag with, e.g., 0.5.11

```bash
docker run -it mrcieu/twosamplemr:0.5.11 R
```

## Developers

If you are updating this and *don't* have access to the mrcieu dockerhub organization please send your dockerhub username to [@t0mrg](https://github.com/t0mrg).

Build the image (untagged/latest) and then add a version number tag as follows.

```bash
docker pull rocker/r-ver:latest
docker build --pull --no-cache --platform linux/amd64 -t mrcieu/twosamplemr .
docker tag mrcieu/twosamplemr mrcieu/twosamplemr:<version_no>
```

Then login to DockerHub, and push both the version numbered tag and the latest tag (this is necessary so that the mrcieu/twosamplemr image is the latest, but we also show version numbers in the tags).

```bash
docker login
docker push mrcieu/twosamplemr:<version_no>
docker push mrcieu/twosamplemr:latest
```

Then run the test script, which checks TwoSampleMR and its Imports and Suggests (i.e., hard and soft) dependency packages will load.

```bash
docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:latest /bin/bash -c "R --vanilla < test.R"
```
