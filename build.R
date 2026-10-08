# Amend pkgdepends sysreqs database timeout
options(
  pkg.sysreqs_db_update_timeout = as.difftime(59, units = "secs")
)

cran_bioc_date <- "2026-10-08"

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

# Binary Bioconductor packages from Posit Public Package Manager, pinned by date.
# pak builds its Bioconductor repo URLs from BioC_mirror (without it, it uses
# bioconductor.posit.co which serves source); BIOCONDUCTOR_CONFIG_FILE is only
# read by BiocManager.
options(
  BioC_mirror = paste0("https://packagemanager.posit.co/bioconductor/__linux__/noble/", cran_bioc_date),
  BIOCONDUCTOR_CONFIG_FILE = paste0("https://packagemanager.posit.co/bioconductor/", cran_bioc_date, "/config.yaml")
)

# install TwoSampleMR and hard and soft deps (resolved from R-universe by name)
pak::pkg_install("TwoSampleMR", dependencies = TRUE)

# install mr.raps Suggests packages from BioConductor
pak::pkg_install(c("bumphunter", "TxDb.Hsapiens.UCSC.hg38.knownGene"))

# Overwrite the R-universe TwoSampleMR with its latest GitHub release built
# from source, so we needn't wait for R-universe to rebuild. All dependencies
# are already installed above, and installing from a local tarball with
# repos = NULL ignores the Remotes field (which would otherwise make pak build
# MRMix, MRPRESSO, RadialMR, etc. from GitHub source).
gh_headers <- c(Accept = "application/vnd.github+json")
if (nzchar(Sys.getenv("GITHUB_PAT"))) {
  gh_headers <- c(gh_headers, Authorization = paste("token", Sys.getenv("GITHUB_PAT")))
}
release_json <- tempfile(fileext = ".json")
download.file(
  "https://api.github.com/repos/MRCIEU/TwoSampleMR/releases/latest",
  release_json,
  headers = gh_headers,
  quiet = TRUE
)
twosamplemr_tag <- jsonlite::fromJSON(release_json)$tag_name
message("Installing TwoSampleMR ", twosamplemr_tag, " from GitHub source")
twosamplemr_tarball <- file.path(tempdir(), paste0("TwoSampleMR_", twosamplemr_tag, ".tar.gz"))
download.file(
  sprintf("https://github.com/MRCIEU/TwoSampleMR/archive/refs/tags/%s.tar.gz", twosamplemr_tag),
  twosamplemr_tarball,
  quiet = TRUE
)
# R CMD build the GitHub archive so the vignettes are built (they use cached
# data in inst/extdata, so no OpenGWAS access is needed)
twosamplemr_src <- file.path(tempdir(), "twosamplemr_src")
untar(twosamplemr_tarball, exdir = twosamplemr_src)
owd <- setwd(tempdir())
build_status <- system2(
  file.path(R.home("bin"), "R"),
  c("CMD", "build", "--no-manual", list.dirs(twosamplemr_src, recursive = FALSE))
)
setwd(owd)
stopifnot(build_status == 0)
twosamplemr_built <- file.path(tempdir(), paste0("TwoSampleMR_", sub("^v", "", twosamplemr_tag), ".tar.gz"))
install.packages(twosamplemr_built, repos = NULL, type = "source")
stopifnot(packageVersion("TwoSampleMR") == sub("^v", "", twosamplemr_tag))

# Uninstall pak
remove.packages("pak")
