FROM rocker/r-base
WORKDIR /usr/local/src/myscripts
RUN apt-get update && apt-get install -yyy build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libgmp3-dev cmake
RUN R -e 'install.packages("remotes"); remotes::install_github("MRCIEU/TwoSampleMR", dependencies = TRUE)'
