# Test script

# List all installed packages
installed.packages()[, c("Package", "Version")]

# Loads TwoSampleMR and all its dependency packages
library(TwoSampleMR)

packageVersion("TwoSampleMR")

# Imports packages (from TwoSampleMR DESCRIPTION file)
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
library(meta)
library(MRMix)
library(MRPRESSO)
library(pbapply)
library(plyr)
library(psych)
library(RadialMR)
library(reshape2)
library(rmarkdown)

# Suggests packages (from TwoSampleMR DESCRIPTION file)
library(Cairo)
library(car)
library(markdown)
library(MendelianRandomization)
library(mr.raps)
library(MRInstruments)
library(randomForest)
library(testthat)
library(tidyr)

# mr.raps Imports
library(rsnps)
# mr.raps Suggests
library(bumphunter)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
