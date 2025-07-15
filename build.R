# Amend pkgdepends sysreqs database timeout
options(
  pkg.sysreqs_db_update_timeout = as.difftime(59, units = "secs")
)

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
Sys.setenv("R_BIOC_VERSION" = "3.21")

# Setup package URLs for x86_64
if (R.Version()$arch == "x86_64") {
  # Linux binary package repos for x86_64
  pak::repo_add(universe = "https://mrcieu.r-universe.dev/bin/linux/noble-x86_64/4.5/")
  pak::repo_add(CRAN = "https://p3m.dev/cran/__linux__/noble/2025-07-14")
  pak::repo_add(BioCsoft = "https://packagemanager.posit.co/bioconductor/__linux__/noble/2025-07-14")
}

# Setup package URLs for ARM/AARCH64
if (R.Version()$arch == "aarch64") {
  pak::repo_add(universe = "https://mrcieu.r-universe.dev/bin/linux/noble-aarch64/4.5/")
  pak::repo_add(CRAN = "https://p3m.dev/cran/2025-06-20")
  pak::repo_add(BioCsoft = "https://packagemanager.posit.co/bioconductor/2025-07-14")
}

# Set HTTPUserAgent to obtain binary packages from Posit Public Package Manager on x86_64
options(
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

options(
  BIOCONDUCTOR_CONFIG_FILE = "https://packagemanager.posit.co/bioconductor/2025-07-14/config.yaml"
)

# install TwoSampleMR and hard and soft deps
pak::pkg_install("TwoSampleMR", dependencies = TRUE)

# install mr.raps Suggests packages from BioConductor
pak::pkg_install(c("bumphunter", "TxDb.Hsapiens.UCSC.hg38.knownGene"))

# Uninstall pak
remove.packages("pak")
