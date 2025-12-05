# Dockerfile for TwoSampleMR

## Usage

This is the Dockerfile for the [TwoSampleMR dockerhub image](https://hub.docker.com/r/mrcieu/twosamplemr), which can be run with

```bash
docker run -it mrcieu/twosamplemr R
```

or run a specific tag with, e.g., 0.6.15

```bash
docker run -it mrcieu/twosamplemr:0.6.15 R
```

## Developers

If you are updating this and _don't_ have access to the mrcieu dockerhub organization please send your dockerhub username to [@t0mrg](https://github.com/t0mrg).

### Things to check to update on every build

* Check if the version of R needs updating: look in the code - if it needs updating, update the version in the _Dockerfile_, _justfile_, and _README.md_.
* Check if the version of Bioconductor needs to be updated in _build.R_.
* Update the PPPM snapshot dates in _build.R_.

### Build the image

First go through the _Dockerfile_ and _build.R_ to check whether the versions of R, Bioconductor, and the Posit Public Package Manager CRAN and Bioconductor snapshot date URLs are up to date (`cran_bioc_date`) - you can check those dates at

* <https://packagemanager.posit.co/client/#/repos/cran/setup>
* <https://packagemanager.posit.co/client/#/repos/bioconductor/setup>

Then check the current base of `rocker/r-ver:4.5.2` with

```bash
docker pull --platform linux/amd64 rocker/r-ver:4.5.2
docker run --platform linux/amd64 rocker/r-ver:4.5.2 cat /etc/lsb-release
```

And if building the multiple architecture image check

```bash
just check
```

Currently it uses Ubuntu Noble Numbat 24.04.2 LTS. This tells you if you can use the Linux binaries from r-universe which are currently built on Ubuntu Noble Numbat - it's safest to only use the binaries if these Ubuntu versions match. There is likely to be at least a 90 day period after the release of of an Ubuntu LTS during which these versions do not match, i.e., r-universe moves to the new LTS straight away but rocker takes longer to use the new LTS.

If the bases do not match then you must only use source package URLs within _build.R_ (you will need to edit the file).

#### Building a solely amd64 architecture image

```bash
docker pull --platform linux/amd64 rocker/r-ver:4.5.2
docker build --pull --no-cache --platform linux/amd64 -t mrcieu/twosamplemr .
```

#### Building a multi-architecture image

For the multi-architecture image you must enable the containerd image store in Docker Desktop settings.

Build the image (untagged/latest) and then add a version number tag as follows.

```bash
just build
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
just test
```

In the *test-amd64.Rout* and *test-arm64.Rout* files check that the version of TwoSampleMR is the latest one you expect.

### Push to DockerHub

Then login to DockerHub, and push both the version numbered tag and the latest tag (this is necessary so that the mrcieu/twosamplemr image is the latest, but we also show version numbers in the tags).

#### Pushing the single architecture image

```bash
docker login
docker tag mrcieu/twosamplemr mrcieu/twosamplemr:<version_no>
docker push mrcieu/twosamplemr:<version_no>
docker tag mrcieu/twosamplemr:<version_no> mrcieu/twosamplemr:latest
docker push mrcieu/twosamplemr:latest
```

#### Pushing the multiarchitecture image

```bash
just publish VERSION
```
