# syntax=docker/dockerfile:1.11
# enable docker linting
# check=error=true
FROM rocker/r-ver:4.6.0
WORKDIR /usr/local/src/myscripts
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
        -o Acquire::Retries=5 \
        -o Acquire::http::No-Cache=true \
        -o Acquire::https::No-Cache=true && \
    apt-get install -y --no-install-recommends \
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
        pandoc && \
    rm -rf /var/lib/apt/lists/*

# Wait until MRCIEU R-Universe has built latest version of the TwoSampleMR binary
# Should be 1 hour or maybe overnight
# Check https://mrcieu.r-universe.dev/TwoSampleMR
# I set the HTTPUserAgent option in order to obtain binary packages from the
# Public Posit Package Manager (otherwise source packages which will have to 
# be built will be obtained).

RUN --mount=type=bind,source=build.R,target=/tmp/build.R \
    Rscript /tmp/build.R
