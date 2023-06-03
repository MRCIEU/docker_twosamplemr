FROM rocker/r-ver
WORKDIR /usr/local/src/myscripts
RUN apt-get update && \
    apt-get install -yyy \
        build-essential \
        libcurl4-gnutls-dev \
        libxml2-dev \
        libssl-dev \
        libgmp3-dev \
        cmake \
        libcairo2-dev \
        libxt-dev \
        libharfbuzz-dev \
        libtiff-dev
RUN R -e 'options(\
    repos = c(universe = "https://mrcieu.r-universe.dev/bin/linux/jammy/4.3/", \
        CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest")); \
    install.packages(c("MRMix", "RadialMR", "MRInstruments", "ieugwasr", "MRPRESSO", "remotes")); \
    remotes::install_github("MRCIEU/TwoSampleMR", dependencies = TRUE)'
