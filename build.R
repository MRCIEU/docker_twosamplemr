options(
  repos = c(
    universe = "https://mrcieu.r-universe.dev/",
    binaries = "https://p3m.dev/cran/__linux__/noble/2025-03-24"
  )
)

if (R.version["arch"] != "aarch64") {
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
}

install.packages("pak")

pak::pkg_install("TwoSampleMR", dependencies = TRUE)

# mr.raps suggests packages from BioConductor
pak::pkg_install(c("bumphunter", "TxDb.Hsapiens.UCSC.hg38.knownGene"))
