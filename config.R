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
# Version pinning removed — renv.lock tracks exact installed versions for
# reproducibility.  Using flexible install avoids forced reinstalls that
# trigger mid-setup R session restarts.

cran_packages <- c(
  "remotes",
  "devtools",
  "yaml",
  "rmarkdown",
  "Seurat",
  "SeuratObject",
  "ggplot2",
  "dplyr",
  "tidyverse",
  "data.table",
  "Matrix",
  "svglite",
  "pheatmap",
  "patchwork",
  "pROC",
  "caret",
  "rsvd",
  "ggridges",
  "clustree",
  "openxlsx",
  "harmony",
  "BioVenn",
  "tidyquant",
  "scCustomize"
)

bioc_packages <- c(
  "biomaRt",
  "org.Mm.eg.db",
  "AnnotationDbi",
  "GEOquery",
  "clusterProfiler",
  "enrichplot",
  "Nebulosa",
  "slingshot",
  "tradeSeq"
)

github_packages <- c(
  scPred         = "immunogenomics/scPred",
  SeuratWrappers = "satijalab/seurat-wrappers",
  monocle3       = "cole-trapnell-lab/monocle3"
)

# NOTE: "GSEAplot" is referenced in IL9-project_code_hamey.Rmd and
# IL9_tauber.Rmd but does not appear to be a standard CRAN/Bioconductor
# package.  If you have a specific GitHub repo for it, add it to
# github_packages above and to load_packages() below.
# The enrichplot package (included above) provides gseaplot() / gseaplot2().

# =============================================================================
# setup_environment() — initialize renv and install all dependencies
# Run this ONCE when setting up the project for the first time.
# =============================================================================
setup_environment <- function() {

  # ---- 0) Bootstrap renv ----
  if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv")
  }

  if (!file.exists("renv/activate.R")) {
    renv::init(bare = TRUE)
    message("renv initialized with project-local library.")
  } else {
    renv::activate()
    message("renv already initialized \u2014 activated.")
  }

  # Helper: check the renv *project* library specifically.
  # requireNamespace() also sees the global library, which causes setup to
  # skip packages that aren't actually in the project library yet.
  in_project_lib <- function(pkg) {
    lib <- .libPaths()[1]
    nzchar(system.file(package = pkg, lib.loc = lib))
  }

  # ---- 1) Install tooling first (BiocManager + remotes) ----
  for (pkg in c("BiocManager", "remotes", "devtools", "yaml", "rmarkdown")) {
    if (in_project_lib(pkg)) {
      message(pkg, " (", as.character(packageVersion(pkg)), ") OK.")
    } else {
      message("Installing ", pkg, " ...")
      renv::install(pkg)
    }
  }

  # ---- 2) CRAN packages ----
  for (pkg in cran_packages) {
    if (in_project_lib(pkg)) {
      message(pkg, " (", as.character(packageVersion(pkg)), ") OK.")
    } else {
      message("Installing ", pkg, " from CRAN ...")
      renv::install(pkg)
    }
  }

  # ---- 3) Bioconductor packages ----
  # Use renv::install("bioc::pkg") so packages land in the project library.
  for (pkg in bioc_packages) {
    if (in_project_lib(pkg)) {
      message(pkg, " (", as.character(packageVersion(pkg)), ") OK.")
    } else {
      message("Installing ", pkg, " from Bioconductor ...")
      renv::install(paste0("bioc::", pkg))
    }
  }

  # ---- 4) GitHub packages ----
  # Use renv::install("user/repo") so packages land in the project library.
  for (pkg in names(github_packages)) {
    repo <- github_packages[[pkg]]
    if (in_project_lib(pkg)) {
      message(pkg, " (", as.character(packageVersion(pkg)), ") OK.")
    } else {
      message("Installing ", pkg, " from GitHub (", repo, ") ...")
      renv::install(repo)
    }
  }

  # ---- 5) Snapshot ----
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
    # Core single-cell
    library(Seurat)
    library(SeuratObject)
    library(scPred)

    # Data wrangling & viz
    library(ggplot2)
    library(dplyr)
    library(data.table)
    library(Matrix)
    library(svglite)
    library(pheatmap)
    library(patchwork)
    library(pROC)
    library(caret)

    # Bioconductor
    library(biomaRt)
    library(AnnotationDbi)
    library(org.Mm.eg.db)
    library(GEOquery)
  })
  message("All packages loaded.")
}

# =============================================================================
# load_all_packages() — load every package used across all Rmd notebooks
# Use this if you plan to run IL9-project_code_hamey.Rmd or IL9_tauber.Rmd
# interactively.
# =============================================================================
load_all_packages <- function() {
  if (file.exists("renv/activate.R")) {
    source("renv/activate.R")
  }

  suppressPackageStartupMessages({
    # Core single-cell
    library(Seurat)
    library(SeuratObject)
    library(scPred)
    library(SeuratWrappers)

    # Data wrangling & viz
    library(ggplot2)
    library(dplyr)
    library(tidyverse)
    library(data.table)
    library(Matrix)
    library(svglite)
    library(pheatmap)
    library(patchwork)
    library(pROC)
    library(caret)
    library(rsvd)
    library(ggridges)
    library(openxlsx)
    library(BioVenn)
    library(tidyquant)

    # Clustering & trajectory
    library(clustree)
    library(harmony)
    library(scCustomize)
    library(monocle3)
    library(slingshot)
    library(tradeSeq)

    # Bioconductor
    library(biomaRt)
    library(AnnotationDbi)
    library(org.Mm.eg.db)
    library(GEOquery)
    library(clusterProfiler)
    library(enrichplot)
    library(Nebulosa)
  })
  message("All packages loaded.")
}
