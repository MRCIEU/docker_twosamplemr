# syntax=docker/dockerfile:1.11
# enable docker linting
# check=error=true
FROM rocker/r-ver:4.6.1
WORKDIR /usr/local/src/myscripts
RUN printf '%s\n' \
        'Acquire::Retries "5";' \
        'Acquire::http::No-Cache "true";' \
        'Acquire::https::No-Cache "true";' \
        'Acquire::http::Pipeline-Depth "0";' \
        'Acquire::BrokenProxy "true";' \
        > /etc/apt/apt.conf.d/99harden && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
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

# Dependencies come from MRCIEU R-Universe and CRAN binaries, then TwoSampleMR
# itself is installed from source from its latest GitHub release (see build.R),
# so there is no need to wait for R-Universe to rebuild TwoSampleMR.
# I set the HTTPUserAgent option in order to obtain binary packages from the
# Public Posit Package Manager (otherwise source packages which will have to 
# be built will be obtained).

RUN --mount=type=bind,source=build.R,target=/tmp/build.R \
    --mount=type=secret,id=github_pat \
    GITHUB_PAT="$(cat /run/secrets/github_pat 2>/dev/null)" Rscript /tmp/build.R && \
    rm -rf /tmp/Rtmp*
