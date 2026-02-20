# tay_il9

scPred-based cell type label transfer for Tay et al. 

## Prerequisites

- **Git** — [download here](https://git-scm.com/downloads) if not already installed
- **R >= 4.3**
- **RStudio** (recommended) or any R environment

## Getting Started

### 1. Install Git

Download and install Git for your platform from <https://git-scm.com/downloads>.

### 2. Tell RStudio where Git is

Open RStudio and go to **Tools -> Global Options -> Git/SVN**. If the Git executable is not auto-detected, browse to the path — typically:

```
C:/Program Files/Git/bin/git.exe
```

Check the box for **"Enable version control interface for RStudio projects"** if it isn't already. Click OK and restart RStudio.

### 3. Configure your identity

Open a terminal (the **Terminal** tab in RStudio works fine) and run:

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@umich.edu"
```

### 4. Clone the repository

```bash
git clone https://github.com/crizza123/tay_il9.git
cd tay_il9
```

This creates a `tay_il9/` folder containing all scripts. Open this folder as your RStudio project directory (or `setwd()` to it).

### 5. Install R packages

From an R session **inside the project directory**:

```r
source("config.R")
install_packages()
```

This installs all CRAN, Bioconductor, and GitHub dependencies at pinned versions. Packages already installed at the correct version are skipped.

## Data Setup

Both RMDs expect data files to live **in the same directory as the scripts** (the project root) by default. The path is controlled by the `data_dir` variable at the top of each RMD — change it if your data lives elsewhere.

Your project directory should look like this:

```
tay_il9/
├── config.R
├── scPred_GSE_reference.Rmd
├── scPred_Tauber_reference.Rmd
├── MC_LPMC_072424.rds            <-- in-house query (both RMDs)
├── GSE128003_HTSeq_counts.txt.gz <-- GSE RMD reference
├── GSE128074_HTSeq_counts.txt.gz <-- GSE RMD reference
├── GSE106973_HTSeq_counts.txt.gz <-- GSE RMD reference
├── Mice_Mast_cells.rds           <-- Tauber RMD reference
└── plots/                        <-- created automatically on first run
```

If your data files are in a different location, update `data_dir` in each RMD's setup chunk:

```r
data_dir <- "/path/to/your/data"   # <-- change this line in Module 1
```

All downstream file paths (`query_path`, `ref_files`, `reference_path`) are built relative to `data_dir`, so this single change is all that's needed.

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
