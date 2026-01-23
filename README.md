# Placebo Response in Levodopa-Induced Dyskinesia: Meta-analysis Code

This repository contains the R code used to perform the systematic review and meta-analysis evaluating the magnitude of the placebo response in patients with Parkinson’s disease (PD) experiencing levodopa-induced dyskinesia (LID).

The analyses were conducted to support the manuscript entitled:

**"Placebo Effect in Levodopa-Induced Dyskinesia: A Systematic Review and Meta-Analysis"**

---

## Background

Levodopa-induced dyskinesia (LID) is a frequent and disabling complication of Parkinson’s disease treatment. Although placebo responses are well documented in PD clinical trials, their magnitude and determinants in the context of LID remain poorly characterized.

This project quantifies the placebo response observed in randomized, double-blind, placebo-controlled trials in LID and investigates clinical and methodological moderators of this effect using meta-analytic techniques.

---

## Methods Overview

- Systematic review of randomized, double-blind, placebo-controlled clinical trials
- Primary outcome: change in dyskinesia severity in the placebo arm
- Effect size: Standardized Mean Difference (SMD)
- Separate meta-analyses for:
  - Least Squares (LS) mean change (primary analysis)
  - Simple mean change
- Random-effects models using REML estimator
- Heterogeneity assessed with Cochran’s Q and I²
- Meta-regression for predefined moderators:
  - Study duration
  - Baseline age
  - Sex ratio
  - Baseline dyskinesia severity
- Sensitivity analyses:
  - Leave-one-out (LOO)
- Publication bias assessment:
  - Funnel plots
  - Egger’s regression test

All analyses were performed using **R (version 4.5.1)** and the **metafor** package.

---

## Repository Structure

```text
├── data/
│   ├── extracted_data.csv        # Extracted study-level data used in the analyses
│
├── scripts/
│   ├── 01_data_preparation.R     # Data cleaning and variable harmonization
│   ├── 02_meta_analysis.R        # Primary random-effects meta-analyses
│   ├── 03_subgroup_analyses.R    # Scale-specific subgroup analyses
│   ├── 04_meta_regression.R      # Univariable and multivariable meta-regression
│   ├── 05_sensitivity_analysis.R # Leave-one-out analyses
│   ├── 06_publication_bias.R     # Funnel plots and Egger tests
│
├── figures/
│   ├── funnel_plots/             # Funnel plots used in the manuscript
│   ├── forest_plots/             # Forest plots for primary and subgroup analyses
│
├── README.md
