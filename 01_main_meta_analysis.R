###############################################################################
# META-ANALYSIS OF PRE–POST INTERVENTION EFFECTS IN LEVODOPA-INDUCED DYSKINESIA
# Effect size: Standardized Mean Difference (Hedges' g, paired pre–post design)
#
# This script performs random-effects meta-analyses of placebo response
# using either mean change (MS) or least-squares mean change (LS) data.
#
# Software:
# R version 4.5.1
# metafor package version 4.8.0
###############################################################################


# Load LIBRARY and DATASETS
# Data files are not shared publicly but should be placed in the /data folder with the same structure and variable names.

library(metafor)

MS_main <- read.csv("data/MS_main.csv")
LS_main <- read.csv("data/LS_main.csv")

# Expected variables:
# REF_ID         : Study identifier
# DURATION_WEEKS : Intervention duration
# AGE_BASELINE   : Mean age at baseline
# ROB2           : Risk of bias assessment
# N              : Sample size
# OUTCOME_mean   : Mean change score
# OUTCOME_sd     : Standard deviation of the change score
# OUTCOME_smd    : Cohen's d (if already available)

## ------------------------------
# EFFECT SIZE CALCULATION (LS DATASET ONLY)
# Cohen's d is calculated as: d = mean change / SD of change

MS_main$OUTCOME_smd <- MS_main$OUTCOME_mean / MS_main$OUTCOME_sd
LS_main$OUTCOME_smd <- LS_main$OUTCOME_mean / LS_main$OUTCOME_sd

##-------------------------------
# FUNCTION: RANDOM-EFFECTS META-ANALYSIS (HEDGES' g)

run_meta <- function(df, smd_col, label) {

  # Convert Cohen's d to Hedges' g (small-sample correction)
  # J = 1 - 3 / [4*(n - 1) - 1]
  df$g <- df[[smd_col]] * (1 - 3 / (4 * (df$N - 1) - 1))

  # Sampling variance for Hedges' g in paired pre–post designs
  # vi = (1/n + g^2 / (2n)) * ((n - 1) / (n - 3.94))
  df$vi <- (1 / df$N + df$g^2 / (2 * df$N)) *
           ((df$N - 1) / (df$N - 3.94))

  # Random-effects meta-analysis using REML
  model <- rma(
    yi = g,
    vi = vi,
    data = df,
    method = "REML"
  )

  # Print key results
  cat("\n=================================================\n")
  cat("META-ANALYSIS:", label, "\n")
  cat("=================================================\n")
  cat("Number of studies (k):", model$k, "\n")
  cat("Pooled Hedges' g:", round(model$beta, 3),
      "95% CI [", round(model$ci.lb, 3), ",", round(model$ci.ub, 3), "]\n")
  cat("p-value:", format.pval(model$pval, digits = 3), "\n")
  cat("I²:", round(model$I2, 1), "%\n")
  cat("tau²:", round(model$tau2, 4), "\n")

  return(model)
}

##-----------------------------
# RUN META-ANALYSES

model_MS <- run_meta(
  df = MS_main,
  smd_col = "OUTCOME_smd",
  label = "Mean change (MS)"
)

model_LS <- run_meta(
  df = LS_main,
  smd_col = "OUTCOME_smd",
  label = "Least-squares mean change (LS)"
)

