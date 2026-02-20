# =============================================================================
# config.R — Package versions and installer for scPred label transfer pipeline
# =============================================================================
# Usage:
#   source("config.R")           # defines functions + package lists
#   install_packages()           # install all packages at pinned versions
#   load_packages()              # load all libraries into session
# =============================================================================

# ---- CRAN packages ----
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

# ---- Bioconductor packages ----
bioc_packages <- list(
  biomaRt        = "2.60.1",
  org.Mm.eg.db   = "3.19.1",
  AnnotationDbi  = "1.66.0"
)

# ---- GitHub packages ----
github_packages <- list(
  scPred = "immunogenomics/scPred"
)

# =============================================================================
# install_packages() — install all dependencies at the specified versions
# =============================================================================
install_packages <- function() {
  # Ensure remotes is available

  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }

  # Ensure BiocManager is available
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }

  # ---- CRAN ----
  for (pkg in names(cran_packages)) {
    ver <- cran_packages[[pkg]]
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " (", ver, ") from CRAN ...")
      remotes::install_version(pkg, version = ver, repos = "https://cloud.r-project.org", upgrade = "never")
    } else {
      installed_ver <- as.character(packageVersion(pkg))
      if (installed_ver != ver) {
        message(pkg, " version mismatch: installed ", installed_ver, ", expected ", ver, ". Reinstalling ...")
        remotes::install_version(pkg, version = ver, repos = "https://cloud.r-project.org", upgrade = "never")
      } else {
        message(pkg, " (", ver, ") already installed.")
      }
    }
  }

  # ---- Bioconductor ----
  for (pkg in names(bioc_packages)) {
    ver <- bioc_packages[[pkg]]
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " (", ver, ") from Bioconductor ...")
      BiocManager::install(pkg, update = FALSE, ask = FALSE)
    } else {
      message(pkg, " already installed (version: ", as.character(packageVersion(pkg)), ").")
    }
  }

  # ---- GitHub ----
  for (pkg in names(github_packages)) {
    repo <- github_packages[[pkg]]
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Installing ", pkg, " from GitHub (", repo, ") ...")
      remotes::install_github(repo, upgrade = "never")
    } else {
      message(pkg, " already installed (version: ", as.character(packageVersion(pkg)), ").")
    }
  }

  message("\nAll packages installed.")
}

# =============================================================================
# load_packages() — load all required libraries
# =============================================================================
load_packages <- function() {
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
