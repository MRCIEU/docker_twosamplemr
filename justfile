build:
  docker buildx build --pull --platform linux/arm64,linux/amd64 --no-cache --tag mrcieu/twosamplemr:multiarch .

test:
  docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH test.R test-amd64.Rout"
  docker run --platform linux/arm64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH test.R test-arm64.Rout"
