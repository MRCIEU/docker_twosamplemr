# Amend pkgdepends sysreqs database timeout
options(
  pkg.sysreqs_db_update_timeout = as.difftime(59, units = "secs")
)

cran_bioc_date <- "2026-06-24"

# install prebuilt binary pak from pak repo
install.packages(
  "pak",
  repos = sprintf(
    "https://r-lib.github.io/p/pak/stable/%s/%s/%s",
    .Platform$pkgType,
    R.Version()$os,
    R.Version()$arch
  )
)

# Set the Bioconductor version to prevent defaulting to a newer version:
Sys.setenv("R_BIOC_VERSION" = "3.23")

# Binary CRAN packages from Posit Public Package Manager, pinned by date.
# The __linux__/noble form is what lets pak negotiate Ubuntu Noble binaries;
# a hardcoded /bin/linux/... path is served as SOURCE and silently defeats this.
# These URLs are architecture-agnostic: pak requests the correct binary for
# whichever platform (x86_64 or aarch64) the image is being built on.
pak::repo_add(CRAN = paste0("https://packagemanager.posit.co/cran/__linux__/noble/", cran_bioc_date))

# Prebuilt MRCIEU packages (TwoSampleMR, MRPRESSO, MRMix, RadialMR, ieugwasr, ...)
# come from R-universe, so installing TwoSampleMR by name below takes them as
# built packages rather than recompiling from GitHub source.
pak::repo_add(universe = "https://mrcieu.r-universe.dev")

options(
  BIOCONDUCTOR_CONFIG_FILE = paste0("https://packagemanager.posit.co/bioconductor/", cran_bioc_date, "/config.yaml")
)

# install TwoSampleMR and hard and soft deps (resolved from R-universe by name)
pak::pkg_install("TwoSampleMR", dependencies = TRUE)

# install mr.raps Suggests packages from BioConductor
pak::pkg_install(c("bumphunter", "TxDb.Hsapiens.UCSC.hg38.knownGene"))

# Uninstall pak
remove.packages("pak")
