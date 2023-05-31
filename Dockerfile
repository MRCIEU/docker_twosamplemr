FROM rocker/r-ver
WORKDIR /usr/local/src/myscripts
RUN apt-get update && apt-get install -yyy build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libgmp3-dev cmake libcairo2-dev libxt-dev libharfbuzz-dev libtiff-dev
RUN R -e 'install.packages("remotes"); remotes::install_github("MRCIEU/TwoSampleMR", dependencies = TRUE)'
