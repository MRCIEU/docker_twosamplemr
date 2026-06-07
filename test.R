# Test script

# Record date and time this was run
Sys.time()

# List all installed packages
installed.packages()[, c("Package", "Version")]

# Loads TwoSampleMR and all its dependency packages
library(TwoSampleMR)

packageVersion("TwoSampleMR")

# Imports packages (from TwoSampleMR DESCRIPTION file)
library(cli)
library(cowplot)
library(data.table)
library(dplyr)
library(ggplot2)
library(glmnet)
library(gridExtra)
library(gtable)
library(ieugwasr)
library(jsonlite)
library(knitr)
library(lattice)
library(magrittr)
library(MASS)
library(MRMix)
library(MRPRESSO)
library(pbapply)
library(psych)
library(RadialMR)
library(rmarkdown)
library(tidyr)

# Suggests packages (from TwoSampleMR DESCRIPTION file)
library(Cairo)
library(car)
library(markdown)
library(MendelianRandomization)
library(meta)
library(mr.raps)
library(MRInstruments)
library(randomForest)
library(testthat)

# mr.raps Imports
library(rsnps)
# mr.raps Suggests
library(bumphunter)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
