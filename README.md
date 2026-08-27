**Title**
Linking near infrared spectral traits and phytochemistry to browsing intensity by vertebrate herbivores

**Abstract**

These datasets comprise leaf-level near infrared reflectance spectra (350–2500 nm) and corresponding measured and predicted phytochemical concentrations from sagebrush (Artemisia spp.) samples, along with vertebrate browsing intensity metrics. Phytochemical data include crude protein, monoterpenes, coumarins, and phenolics. Browsing intensity is quantified by the number of bite marks on a sagebrush plant. Metadata include a site identifier, patch identifiers, plant species, plant browsed state, season, chemical (reference and predicted) concentrations, and spectra for each sample. Samples without respective chemical or NIR data are removed. These data support analyses linking spectral traits to chemical composition and herbivore browsing patterns.

**Methods**

Leaf samples were collected from multiple sagebrush patches across study sites in Idaho. Each plant was assigned identifiers including site, patch type, season, species, size, browsed state, and associated fecal pellets. Vertebrate browsing was assessed by counting bite marks. In the lab, samples were analyzed for reference ("_Ref") crude protein (% dry weight), monoterpenes (AUC/mg dry weight), coumarins (μmol scopoletin equivalents/g dry weight), and phenolics (mg gallic acid equivalents/g dry weight) using standard chemical assays. Additionally, near infrared reflectance spectra (350–2500 nm) were collected for each sample. Calibration models were developed to predict chemical concentrations ("_Pred") from spectral data.

**Data**

The data analyzed in this repository are archived on Dryad:

Dataset title: Linking near infrared spectral traits and phytochemistry to browsing intensity by vertebrate herbivores
Dryad DOI: 10.5061/dryad.tdz08kqbv

Data files are not stored in this repository. Download them from the Dryad link above and place them in a data/ folder before running any analyses (see Repository structure below).

**Requirements**

Analyses were run in R and rely on the following packages:

r
install.packages(c(
  "rprojroot", "loo", "rstanarm", "ggplot2", "bayesplot", "MASS",
  "lme4", "brms", "tidybayes", "magrittr", "dplyr", "rstan",
  "emmeans", "broom", "modelr", "forcats", "cowplot",
  "RColorBrewer", "gganimate", "ggridges", "viridis", "ggExtra"
))

brms and rstanarm require a working C++ toolchain (via rstan) — see the Stan installation guide if library(rstan) fails.

**Repository structure and workflow**

Scripts are numbered in the order they should be run; each step's outputs (saved as .Rdata objects) are inputs to later steps:

project/
├── data/                     <- downloaded from Dryad, not in this repo
├── 1.PLSR_train_export_2025.R
├── 2.Cedar_Gulch_Binomial_2026_Final.Rmd
├── 2.Craters_Individuals_2026_Final.Rmd
├── 2.JN_Magic_binomial_2026_Final.Rmd
├── 2.KG_Magic_Site_2026_Final.Rmd
├── 2.Raft_River_2026_Final.Rmd
├── 3.GGRidges_16Jun2026.Rmd
└── 4.Counterfactuals_31Jan2026.Rmd

PLSR_train_export_2025.R trains partial least squares regression calibration models on the NIRS data and exports predicted chemistries for each sample.

The five site-level .Rmd files each take the reference and predicted chemistry (from step 1) together with bite-count data and fit models of browsing intensity as a function of chemistry, for their respective site. 

GGRidges_2026.Rmd combines the posterior draws across all five sites and produces ridge plots comparing reference vs. predicted chemistry posteriors by site and chemical class.

Counterfactuals_2026.Rmd uses the fitted site-level models to generate counterfactual plots showing predicted bite counts across the observed range of each chemical trait.

**File descriptions**

PLSR_train_export_2025.R	Creates predicted chemistries from NIRS data.
Cedar_Gulch_Binomial_2026_Final.Rmd	Analyzes bite data from Cedar Gulch.
Craters_Individuals_2026_Final.Rmd	Analyzes bite data from Craters.
JN_Magic_binomial_2026_Final.Rmd	Analyzes bite data from JN Magic.
KG_Magic_Site_2026_Final.Rmd	Analyzes bite data from KG Magic.
Raft_River_2026_Final.Rmd	Analyzes bite data from Raft River.
GGRidges_2026.Rmd	Creates ridge plots from posterior distributions across all sites.
Counterfactuals_2026.Rmd	Creates counterfactual plots from fitted site-level models.
