# =============================================================================
# config.R — renv-based environment setup for scPred label transfer pipeline
# =============================================================================
# Usage:
#   source("config.R")           # defines functions + package lists
#   setup_environment()          # initialize renv + install all packages (first time)
#   load_packages()              # load all libraries into session
#
# On subsequent sessions, renv activates automatically via renv/activate.R.
# Just run: source("config.R"); load_packages()
# =============================================================================

# ---- Package registry ----
cran_packages <- list(
  remotes        = "2.5.0",
  Seurat         = "5.1.0",
  SeuratObject   = "5.0.2",
  ggplot2        = "3.5.1",
  dplyr          = "1.1.4",
  tidyverse      = "2.0.0",
  data.table     = "1.16.4",
  Matrix         = "1.7-1",
  svglite        = "2.1.3",
  pheatmap       = "1.0.12",
  patchwork      = "1.3.0",
  pROC           = "1.18.5",
  caret          = "6.0-94"
)

bioc_packages <- list(
  biomaRt        = "2.60.1",
  org.Mm.eg.db   = "3.19.1",
  AnnotationDbi  = "1.66.0"
)

github_packages <- list(
  scPred = "immunogenomics/scPred"
)

# =============================================================================
# setup_environment() — initialize renv and install all dependencies
# Run this ONCE when setting up the project for the first time.
# =============================================================================
setup_environment <- function() {
  # Install renv if not available
  if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv")
  }

  # Initialize renv project-local library (skips if already initialized)
  if (!file.exists("renv/activate.R")) {
    renv::init(bare = TRUE)
    message("renv initialized with project-local library.")
  } else {
    renv::activate()
    message("renv already initialized — activated.")
  }

  # Ensure remotes and BiocManager are available in the renv library
  if (!requireNamespace("remotes", quietly = TRUE)) {
    renv::install("remotes")
  }
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    renv::install("BiocManager")
  }

  # ---- CRAN packages ----
  for (pkg in names(cran_packages)) {
    ver <- cran_packages[[pkg]]
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " (", ver, ") ...")
      remotes::install_version(pkg, version = ver,
                               repos = "https://cloud.r-project.org",
                               upgrade = "never")
    } else {
      installed_ver <- as.character(packageVersion(pkg))
      if (installed_ver != ver) {
        message(pkg, " version mismatch: installed ", installed_ver,
                ", expected ", ver, ". Reinstalling ...")
        remotes::install_version(pkg, version = ver,
                                 repos = "https://cloud.r-project.org",
                                 upgrade = "never")
      } else {
        message(pkg, " (", ver, ") OK.")
      }
    }
  }

  # ---- Bioconductor packages ----
  for (pkg in names(bioc_packages)) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " from Bioconductor ...")
      BiocManager::install(pkg, update = FALSE, ask = FALSE)
    } else {
      message(pkg, " (", as.character(packageVersion(pkg)), ") OK.")
    }
  }

  # ---- GitHub packages ----
  for (pkg in names(github_packages)) {
    repo <- github_packages[[pkg]]
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " from GitHub (", repo, ") ...")
      remotes::install_github(repo, upgrade = "never")
    } else {
      message(pkg, " (", as.character(packageVersion(pkg)), ") OK.")
    }
  }

  # Snapshot the current state so others can restore with renv::restore()
  renv::snapshot(prompt = FALSE)
  message("\nEnvironment setup complete. Lockfile written to renv.lock.")
}

# =============================================================================
# load_packages() — load all required libraries
# =============================================================================
load_packages <- function() {
  # Activate renv if present (no-op if already active)
  if (file.exists("renv/activate.R")) {
    source("renv/activate.R")
  }

  suppressPackageStartupMessages({
    library(Seurat)
    library(SeuratObject)
    library(scPred)
    library(ggplot2)
    library(dplyr)
    library(data.table)
    library(Matrix)
    library(svglite)
    library(pheatmap)
    library(patchwork)
    library(pROC)
    library(caret)
    library(biomaRt)
    library(AnnotationDbi)
    library(org.Mm.eg.db)
  })
  message("All packages loaded.")
}
