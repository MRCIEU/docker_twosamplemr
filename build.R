# source package repos for aarch64
options(
  repos = c(
    universe = "https://mrcieu.r-universe.dev/",
    CRAN = "https://p3m.dev/cran/2025-03-24"
  ),
  pkg.sysreqs_db_update_timeout = as.difftime(59, units = "secs")
)

# Set the Bioconductor version to prevent defaulting to a newer version:
Sys.setenv("R_BIOC_VERSION" = "3.20")

if (R.Version()$arch == "x86_64") {
  # Linux binary package repos for x86_64
  options(
    repos = c(
      universe = "https://mrcieu.r-universe.dev/bin/linux/noble/4.4/",
      CRAN = "https://p3m.dev/cran/__linux__/noble/2025-03-24",
      BioCsoft = "https://packagemanager.posit.co/bioconductor/__linux__/noble/2025-03-21"
    ),
    BIOCONDUCTOR_CONFIG_FILE = "https://packagemanager.posit.co/bioconductor/2025-03-21/config.yaml",
    HTTPUserAgent = sprintf(
      'R/%s R (%s)',
      getRversion(),
      paste(
        getRversion(),
        R.version['platform'],
        R.version['arch'],
        R.version['os']
      )
    )
  )
}

# install prebuilt binary pak from their repo
install.packages(
  "pak",
  repos = sprintf(
    "https://r-lib.github.io/p/pak/stable/%s/%s/%s",
    .Platform$pkgType,
    R.Version()$os,
    R.Version()$arch
  )
)

# install TwoSampleMR and hard and soft deps
pak::pkg_install("TwoSampleMR", dependencies = TRUE)

# mr.raps suggests packages from BioConductor
pak::pkg_install(c("bumphunter", "TxDb.Hsapiens.UCSC.hg38.knownGene"))

remove.packages("pak")
