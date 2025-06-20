build:
    docker buildx build --pull --platform linux/arm64,linux/amd64 --no-cache --tag mrcieu/twosamplemr:multiarch .

test:
    docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH test.R test-amd64.Rout"
    docker run --platform linux/arm64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH test.R test-arm64.Rout"

publish version:
    docker push mrcieu/twosamplemr:multiarch
    docker tag mrcieu/twosamplemr:multiarch mrcieu/twosamplemr:{{ version }}
    docker push mrcieu/twosamplemr:{{ version }}
    docker tag mrcieu/twosamplemr:multiarch mrcieu/twosamplemr:latest
    docker push mrcieu/twosamplemr:latest

check:
    docker pull --platform linux/amd64 rocker/r-ver:4.5.1
    docker run --platform linux/amd64 rocker/r-ver:4.5.1 cat /etc/lsb-release
    docker pull --platform linux/arm64 rocker/r-ver:4.5.1
    docker run --platform linux/arm64 rocker/r-ver:4.5.1 cat /etc/lsb-release

all version:
    {{ just_executable() }} check
    {{ just_executable() }} build
    {{ just_executable() }} test
    {{ just_executable() }} publish {{ version }}
