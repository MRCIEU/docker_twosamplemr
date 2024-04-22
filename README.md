# Dockerfile for TwoSampleMR

## Usage

This is the Dockerfile for the [TwoSampleMR dockerhub image](https://hub.docker.com/r/mrcieu/twosamplemr), which can be run with

```bash
docker run -it mrcieu/twosamplemr R
```

or run a specific tag with, e.g., 0.6.0

```bash
docker run -it mrcieu/twosamplemr:0.6.0 R
```

## Developers

If you are updating this and _don't_ have access to the mrcieu dockerhub organization please send your dockerhub username to [@t0mrg](https://github.com/t0mrg).

### Build the image

#### Building a solely amd64 architecture image

```bash
docker pull --platform linux/amd64 rocker/r-ver:latest
docker build --pull --no-cache --platform linux/amd64 -t mrcieu/twosamplemr .
docker tag mrcieu/twosamplemr mrcieu/twosamplemr:<version_no>
```

#### Building a multi-architecture image

For the multi-architecture image you must enable the containerd image store in Docker Desktop settings.

Build the image (untagged/latest) and then add a version number tag as follows.

```bash
docker buildx build --pull --platform linux/arm64,linux/amd64 --tag mrcieu/twosamplemr:<version_no> .
# docker buildx build --pull --push --platform linux/arm64,linux/amd64 --tag mrcieu/twosamplemr:multiarch .
```

### Run the test script

Then run the test script, which checks TwoSampleMR and its Imports and Suggests (i.e., hard and soft) dependency packages will load.

```bash
docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:latest /bin/bash -c "R CMD BATCH test.R"
```

And check the version of TwoSampleMR is the latest one you expect.

#### Running the test script for the arm64 image

```bash
docker run --platform linux/arm64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:latest /bin/bash -c "R CMD BATCH test.R test-arm64.Rout"
```

### Push to DockerHub

Then login to DockerHub, and push both the version numbered tag and the latest tag (this is necessary so that the mrcieu/twosamplemr image is the latest, but we also show version numbers in the tags).

Note this only applies to the single architecture image.

```bash
docker login
docker push mrcieu/twosamplemr:<version_no>
docker push mrcieu/twosamplemr:latest
```
