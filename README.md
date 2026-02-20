# tay_il9

scPred-based cell type label transfer for the IL-9 mast cell project.

## Prerequisites

- R >= 4.3
- Bioconductor (installed automatically by `config.R`)

## Installation

From an R session in the project directory:

```r
source("config.R")
install_packages()
```

This installs all CRAN, Bioconductor, and GitHub dependencies at pinned versions. Packages already installed at the correct version are skipped.

## Data Setup

Place the following files in the project directory (or update `data_dir` in each RMD):

| File | Used by |
|------|---------|
| `MC_LPMC_072424.rds` | Both RMDs (in-house query) |
| `GSE128003_HTSeq_counts.txt.gz` | `scPred_GSE_reference.Rmd` |
| `GSE128074_HTSeq_counts.txt.gz` | `scPred_GSE_reference.Rmd` |
| `GSE106973_HTSeq_counts.txt.gz` | `scPred_GSE_reference.Rmd` |
| `Mice_Mast_cells.rds` | `scPred_Tauber_reference.Rmd` |

## Usage

Open either RMD in RStudio and knit, or run interactively:

```r
rmarkdown::render("scPred_GSE_reference.Rmd")
rmarkdown::render("scPred_Tauber_reference.Rmd")
```

Plots are saved to `plots/` as both `.png` and `.svg`.

## Project Files

| File | Description |
|------|-------------|
| `config.R` | Package versions, installer, and library loader |
| `scPred_GSE_reference.Rmd` | Label transfer: 3 SMART-seq2 GSE references to in-house query |
| `scPred_Tauber_reference.Rmd` | Label transfer: Tauber mast cell reference to in-house query |
| `IL9-project_code_hamey.Rmd` | Original Hamey analysis (reference only) |
| `IL9_tauber.Rmd` | Original Tauber analysis (reference only) |
