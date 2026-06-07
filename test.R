# Test script

# Record date and time this was run
Sys.time()

# List all installed packages
installed.packages()[, c("Package", "Version")]

# Loads TwoSampleMR and all its dependency packages
library(TwoSampleMR)

packageVersion("TwoSampleMR")

# Programmatically determine the declared dependencies of TwoSampleMR and
# mr.raps directly from their installed DESCRIPTION files, so this test stays
# in sync automatically when the packages reorganize their dependencies.
#
# mr.raps is listed explicitly because the build installs its dependencies
# (rsnps, bumphunter, TxDb.Hsapiens.UCSC.hg38.knownGene) separately and we
# want them exercised here. recursive = FALSE keeps us to direct dependencies
# rather than descending into the full (partly uninstalled) Bioconductor tree.
root_pkgs <- c("TwoSampleMR", "mr.raps")
deps <- tools::package_dependencies(
  root_pkgs,
  which = c("Depends", "Imports", "Suggests"),
  recursive = FALSE
)
to_load <- sort(setdiff(
  unique(unlist(deps, use.names = FALSE)),
  c(root_pkgs, "R")
))

# Attempt to attach each declared dependency, collecting every failure so a
# single run reports all missing packages (not just the first).
failed <- character(0)
for (pkg in to_load) {
  ok <- tryCatch({
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    TRUE
  }, error = function(e) FALSE)
  message(sprintf("%-35s %s", pkg, if (ok) "OK" else "FAILED"))
  if (!ok) failed <- c(failed, pkg)
}

if (length(failed)) {
  stop(
    "Declared dependencies not installed: ",
    paste(failed, collapse = ", ")
  )
}
