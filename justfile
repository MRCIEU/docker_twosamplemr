build:
    GITHUB_PAT="$(gh auth token)" docker buildx build --pull --platform linux/arm64,linux/amd64 --no-cache --secret id=github_pat,env=GITHUB_PAT --tag mrcieu/twosamplemr:multiarch .

build-cached:
    GITHUB_PAT="$(gh auth token)" docker buildx build --pull --platform linux/arm64,linux/amd64 --secret id=github_pat,env=GITHUB_PAT --tag mrcieu/twosamplemr:multiarch .

test:
    rm -f .RData
    docker run --platform linux/amd64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH --no-save test.R test-amd64.Rout"
    rm -f .RData
    docker run --platform linux/arm64 -v /$PWD:/usr/local/src/myscripts mrcieu/twosamplemr:multiarch /bin/bash -c "R CMD BATCH --no-save test.R test-arm64.Rout"

publish version:
    docker push mrcieu/twosamplemr:multiarch
    docker tag mrcieu/twosamplemr:multiarch mrcieu/twosamplemr:{{ version }}
    docker push mrcieu/twosamplemr:{{ version }}
    docker tag mrcieu/twosamplemr:multiarch mrcieu/twosamplemr:latest
    docker push mrcieu/twosamplemr:latest

check:
    docker pull --platform linux/amd64 rocker/r-ver:4.6.0
    docker run --platform linux/amd64 rocker/r-ver:4.6.0 cat /etc/lsb-release
    docker pull --platform linux/arm64 rocker/r-ver:4.6.0
    docker run --platform linux/arm64 rocker/r-ver:4.6.0 cat /etc/lsb-release

all version:
    {{ just_executable() }} check
    {{ just_executable() }} build
    {{ just_executable() }} test
    {{ just_executable() }} publish {{ version }}

both:
    {{ just_executable() }} build
    {{ just_executable() }} test
