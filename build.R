options(
  repos = c(
    universe = "https://mrcieu.r-universe.dev/",
    CRAN = "https://p3m.dev/cran/__linux__/noble/2025-03-24"
  ),
  pkg.sysreqs_db_update_timeout = as.difftime(59, units = "secs")
)

if (R.version["arch"] != "aarch64") {
  options(
    repos = c(universe = "https://mrcieu.r-universe.dev/bin/linux/noble/4.4/"),
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
