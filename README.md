# Bites

**Title:**Linking near infrared spectral traits and phytochemistry to browsing intensity by vertebrate herbivores

**Abstract:**

These datasets comprise leaf-level near infrared reflectance spectra (350–2500 nm) and corresponding measured and predicted phytochemical concentrations from sagebrush (Artemisia spp.) samples, along with vertebrate browsing intensity metrics. Phytochemical data include crude protein, monoterpenes, coumarins, and phenolics. Browsing intensity is quantified by the number of bite marks on a sagebrush plant. Metadata include a site identifier, patch identifiers, plant species, plant browsed state, season, chemical (reference and predicted) concentrations, and spectra for each sample. Samples without respective chemical or NIR data are removed. These data support analyses linking spectral traits to chemical composition and herbivore browsing patterns.

**Methods:**

Leaf samples were collected from multiple sagebrush patches across study sites in Idaho. Each plant was assigned identifiers including site, patch type, season, species, size, browsed state, and associated fecal pellets. Vertebrate browsing was assessed by counting bite marks. In the lab, samples were analyzed for reference (“_Ref”) crude protein (% dry weight), monoterpenes (AUC/mg dry weight), coumarins (μmol scopoletin equivalents/g dry weight), and phenolics (mg gallic acid equivalents/g dry weight) using standard chemical assays. Additionally, near infrared reflectance spectra (350–2500 nm) were collected for each sample. Calibration models were developed to predict chemical concentrations (“_Pred”) from spectral data.

**Data:**

The data analyzed in this repository are archived on Dryad:

Dataset title: Linking near infrared spectral traits and phytochemistry to browsing intensity by vertebrate herbivores
Dryad DOI: Dataset DOI: 10.5061/dryad.tdz08kqbv

Data files are not stored in this repository. Download them from the Dryad link above and place them in the data/ folder before running any analyses (see below).

**File Descriptions**

File	Description

1.PLSR_train_export_2025.R	Creates predicted chemistries from NIRS data.

2.Cedar_Gulch_Binomial_2026_Final.Rmd  Analyzes bite data from Cedar Gulch. 

2.Craters_Individuals_2026_Final.Rmd  Analyzes bite data from Craters. 

2.JN_Magic_binomial_2026_Final.Rmd  Analyzes bite data from Craters.

2.KG_Magic_Site_2026_Final.Rmd  Analyzes bite data from Craters.

2.Raft_River_2026_Final.Rmd  Analyzes bite data from Craters.

3.GGRidges_2026.Rmd  Creates ridges plots from posterior distributions. 

4.Counterfactuals_2026.Rmd  Creates counterfactual plots from data. 
