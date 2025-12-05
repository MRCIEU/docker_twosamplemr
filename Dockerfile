# syntax=docker/dockerfile:1.11
# enable docker linting
# check=error=true
FROM rocker/r-ver:4.5.2
WORKDIR /usr/local/src/myscripts
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -yyy \
        build-essential \
        libcurl4-openssl-dev \
        libxml2-dev \
        libssl-dev \
        libgmp3-dev \
        cmake \
        libcairo2-dev \
        libxt-dev \
        libharfbuzz-dev \
        libtiff-dev \
        libstdc++6 \
        pandoc

# Wait until MRCIEU R-Universe has built latest version of the TwoSampleMR binary
# Should be 1 hour or maybe overnight
# Check https://mrcieu.r-universe.dev/TwoSampleMR
# I set the HTTPUserAgent option in order to obtain binary packages from the
# Public Posit Package Manager (otherwise source packages which will have to 
# be built will be obtained).

RUN --mount=type=bind,source=build.R,target=/tmp/build.R \
    Rscript /tmp/build.R
