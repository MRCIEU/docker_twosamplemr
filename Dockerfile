FROM rocker/r-ver:latest
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
        libtiff-dev \
        libstdc++6

# Wait until MRCIEU R-Universe has built latest version of the TwoSampleMR binary
# Should be 1 hour or maybe overnight
# Check https://mrcieu.r-universe.dev/TwoSampleMR
# I set the HTTPUserAgent option in order to obtain binary packages from the
# Public Posit Package Manager (otherwise source packages which will have to 
# be built will be obtained).

RUN R -e 'options( \
    repos = c(universe = "https://mrcieu.r-universe.dev/", \
        binaries = "https://p3m.dev/cran/__linux__/noble/latest", \
        CRAN = "https://cloud.r-project.org"), \
    HTTPUserAgent = sprintf( \
        "R/%s R (%s)", \
        getRversion(), \
        paste(getRversion(), \
          R.version["platform"], \
          R.version["arch"], \
          R.version["os"]))); \
    install.packages("TwoSampleMR", dependencies = TRUE); \
    # mr.raps Suggests; \
    install.packages(c("rsnps", "BiocManager")); \
    BiocManager::install(c("bumphunter", "TxDb.Hsapiens.UCSC.hg38.knownGene"))'
