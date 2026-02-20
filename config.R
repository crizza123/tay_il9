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

  # Suppress RStudio session restarts during setup.
  # renv::init() and renv::activate() default restart = interactive(),
  # which kills the running function before packages get installed.
  old_restart <- getOption("restart")
  on.exit(options(restart = old_restart), add = TRUE)
  options(restart = NULL)

  # ---- 0) Bootstrap renv ----
  if (!requireNamespace("renv", quietly = TRUE)) {
    install.packages("renv")
  }

  if (!file.exists("renv/activate.R")) {
    renv::init(bare = TRUE, restart = FALSE)
    message("renv initialized with project-local library.")
  } else {
    renv::activate(restart = FALSE)
    message("renv already initialized \u2014 activated.")
  }

  # Use renv::install() unconditionally for all packages.  It is idempotent
  # (skips packages already in the project library) and always installs into
  # the renv project library.  We avoid requireNamespace() / system.file()
  # checks because after renv::init() the global library is still visible,
  # causing those checks to say "OK" for packages that aren't actually in the
  # project library yet.

  # ---- 1) Tooling ----
  message("\n-- Installing tooling packages --")
  renv::install(c("BiocManager", "remotes", "devtools", "yaml", "rmarkdown"))

  # ---- 2) CRAN packages ----
  message("\n-- Installing CRAN packages --")
  renv::install(cran_packages)

  # ---- 3) Bioconductor packages ----
  message("\n-- Installing Bioconductor packages --")
  renv::install(paste0("bioc::", bioc_packages))

  # ---- 4) GitHub packages ----
  message("\n-- Installing GitHub packages --")
  renv::install(unname(github_packages))

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
