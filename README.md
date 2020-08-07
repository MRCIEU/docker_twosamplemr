# Dockerfile for TwoSampleMR

Build the image (untagged/latest) and then add a version number tag

```bash
docker build -t mrcieu/twosamplemr .
docker tag mrcieu/twosamplemr mrcieu/twosamplemr:<version_no>
```

Login to DockerHub, then push both the version numbered tag and the latest tag (this is necessary so that the mrcieu/twosamplemr image is the latest, but we also show version numbers in the tags)

```bash
docker login
docker push mrcieu/twosamplemr:<version_no>
docker push mrcieu/twosamplemr:latest
```
