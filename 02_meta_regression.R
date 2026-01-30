###############################################################################
# META-REGRESSION ANALYSES
# Univariate meta-regressions for potential moderators
#
# Outcome: Placebo response in levodopa-induced dyskinesia
# Effect size: Hedges' g (paired pre–post design)
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

# Ensure categorical variables are treated as factors
MS_main$ROB2 <- factor(MS_main$ROB2)
LS_main$ROB2 <- factor(LS_main$ROB2)

# Expected variables:
# REF_ID         : Study identifier
# DURATION_WEEKS : Intervention duration
# AGE_BASELINE   : Mean age at baseline
# ROB2           : Risk of bias assessment
# N              : Sample size
# OUTCOME_mean   : Mean change score
# OUTCOME_sd     : Standard deviation of the change score
# OUTCOME_smd    : Cohen's d (if already available)

##---------------------------------------------- 
# FUNCTION: UNIVARIATE META-REGRESSION
# This function:
# 1) Converts Cohen's d to Hedges' g
# 2) Computes sampling variance
# 3) Fits a random-effects meta-regression (REML)

run_meta_regression <- function(df, moderator, label) {

  # Convert Cohen's d to Hedges' g (small-sample correction)
  # J = 1 - 3 / [4*(n - 1) - 1]
  df$g <- df$OUTCOME_smd * (1 - 3 / (4 * (df$N - 1) - 1))

  # Sampling variance for Hedges' g (paired pre–post design)
  # vi = (1/n + g^2 / (2n)) * ((n - 1) / (n - 3.94))
  df$vi <- (1 / df$N + df$g^2 / (2 * df$N)) *
           ((df$N - 1) / (df$N - 3.94))

  # Meta-regression model
  model <- rma(
    yi   = g,
    vi   = vi,
    mods = as.formula(paste("~", moderator)),
    data = df,
    method = "REML"
  )

  # Output
  cat("\n=================================================\n")
  cat("META-REGRESSION:", label, "\n")
  cat("Moderator:", moderator, "\n")
  cat("=================================================\n")

  print(summary(model))

  return(model)
}

##--------------------------------------------
# META-REGRESSION ANALYSES – MEAN CHANGE (MS)

mr_duration_MS <- run_meta_regression(
  df = MS_main,
  moderator = "DURATION_WEEKS",
  label = "Mean change (MS) – Study duration"
)

mr_age_MS <- run_meta_regression(
  df = MS_main,
  moderator = "AGE_BASELINE",
  label = "Mean change (MS) – Baseline age"
)

mr_man_ratio_MS <- run_meta_regression(
  df = MS_main,
  moderator = "MAN_RATIO",
  label = "Mean change (MS) – Male proportion"
)

mr_dysk_MS <- run_meta_regression(
  df = MS_main,
  moderator = "DYSK_smd",
  label = "Mean change (MS) – Baseline dyskinesia severity"
)

mr_rob2_MS <- run_meta_regression(
  df = MS_main,
  moderator = "ROB2",
  label = "Mean change (MS) – Risk of bias (ROB2)"
)

##-------------------------------------------------
# META-REGRESSION ANALYSES – LEAST-SQUARES MEAN CHANGE (LS)

mr_duration_LS <- run_meta_regression(
  df = LS_main,
  moderator = "DURATION_WEEKS",
  label = "Least-squares mean change (LS) – Study duration"
)

mr_age_LS <- run_meta_regression(
  df = LS_main,
  moderator = "AGE_BASELINE",
  label = "Least-squares mean change (LS) – Baseline age"
)

mr_man_ratio_LS <- run_meta_regression(
  df = LS_main,
  moderator = "MAN_RATIO",
  label = "Least-squares mean change (LS) – Male proportion"
)

mr_dysk_LS <- run_meta_regression(
  df = LS_main,
  moderator = "DYSK_smd",
  label = "Least-squares mean change (LS) – Baseline dyskinesia severity"
)

mr_rob2_LS <- run_meta_regression(
  df = LS_main,
  moderator = "ROB2",
  label = "Least-squares mean change (LS) – Risk of bias (ROB2)"
)
