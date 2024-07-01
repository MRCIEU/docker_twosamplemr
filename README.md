# Dockerfile for TwoSampleMR

## Usage

This is the Dockerfile for the [TwoSampleMR dockerhub image](https://hub.docker.com/r/mrcieu/twosamplemr), which can be run with

```bash
docker run -it mrcieu/twosamplemr R
```

or run a specific tag with, e.g., 0.6.5

```bash
docker run -it mrcieu/twosamplemr:0.6.5 R
```

## Developers

If you are updating this and _don't_ have access to the mrcieu dockerhub organization please send your dockerhub username to [@t0mrg](https://github.com/t0mrg).

### Build the image

First check the current base of `rocker/r-ver:latest` with

```bash
docker run --platform linux/amd64 rocker/r-ver:latest cat /etc/lsb-release
```

Currently it uses Ubuntu Jammy Jellyfish 22.04.4 LTS. This tells you if you can use the Linux binaries from r-universe which are currently built on Ubuntu Noble Numbat - it's safest to only use the binaries if these Ubuntu versions match. There is likely to be at least a 90 day period after the release of Noble Numbat during which these versions do not match.

#### Building a solely amd64 architecture image

```bash
docker pull --platform linux/amd64 rocker/r-ver:latest
docker build --pull --no-cache --platform linux/amd64 -t mrcieu/twosamplemr -f jammy.Dockerfile .
docker tag mrcieu/twosamplemr mrcieu/twosamplemr:<version_no>
```

#### Building a multi-architecture image

For the multi-architecture image you must enable the containerd image store in Docker Desktop settings.

Build the image (untagged/latest) and then add a version number tag as follows.

```bash
docker buildx build --pull --platform linux/arm64,linux/amd64 --tag mrcieu/twosamplemr:multiarch .
```

### Run the test script

Then run the test script, which checks TwoSampleMR and its Imports and Suggests (i.e., hard and soft) dependency packages will load.

For the single architecture image run the following.

```bash
docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:latest /bin/bash -c "R CMD BATCH test.R test-amd64.Rout"
```

In the *test.Rout* file check that the version of TwoSampleMR is the latest one you expect.

#### Running the test script for the multiarch image

```bash
docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH test.R test-amd64.Rout"
docker run --platform linux/arm64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH test.R test-arm64.Rout"
```

In the *test-amd64.Rout* and *test-arm64.Rout* files check that the version of TwoSampleMR is the latest one you expect.

### Push to DockerHub

Then login to DockerHub, and push both the version numbered tag and the latest tag (this is necessary so that the mrcieu/twosamplemr image is the latest, but we also show version numbers in the tags).

Note this only applies to the single architecture image.

```bash
docker login
docker push mrcieu/twosamplemr:<version_no>
docker tag mrcieu/twosamplemr:<version_no> mrcieu/twosamplemr:latest
docker push mrcieu/twosamplemr:latest
```

Push the multiarchitecture image with

```bash
docker push mrcieu/twosamplemr:multiarch
```

And push it as latest and the tag as well

```bash
docker tag mrcieu/twosamplemr:multiarch mrcieu/twosamplemr:<version_no>
docker push mrcieu/twosamplemr:<version_no>

docker tag mrcieu/twosamplemr:multiarch mrcieu/twosamplemr:latest
docker push mrcieu/twosamplemr:latest
```
