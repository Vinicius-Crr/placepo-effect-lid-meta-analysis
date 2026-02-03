###############################################################################
# MULTIVARIABLE META-REGRESSION ANALYSIS
#
# Outcome: Placebo response in levodopa-induced dyskinesia
# Effect size: Hedges' g (paired pre–post design)
#
# Moderators included based on univariate significance:
# - Study duration
# - Baseline age
# - Male proportion
###############################################################################

# Load LIBRARY and DATASETS
# Data files are not shared publicly but should be placed in the /data folder with the same structure and variable names.
library(metafor)
MS_main <- read.csv("data/MS_main.csv")
LS_main <- read.csv("data/LS_main.csv")

# -----------------------------------------
# FUNCTION: MULTIVARIABLE META-REGRESSION


run_multivariable_meta_regression <- function(df, moderators, label) {

  # Convert Cohen's d to Hedges' g
  df$g <- df$OUTCOME_smd * (1 - 3 / (4 * (df$N - 1) - 1))

  # Sampling variance for Hedges' g
  df$vi <- (1 / df$N + df$g^2 / (2 * df$N)) *
           ((df$N - 1) / (df$N - 3.94))

  # Build moderator formula
  formula_mod <- as.formula(
    paste("~", paste(moderators, collapse = " + "))
  )

  # Fit random-effects multivariable meta-regression
  model <- rma(
    yi   = g,
    vi   = vi,
    mods = formula_mod,
    data = df,
    method = "REML"
  )

  # Output
  cat("\n=================================================\n")
  cat("MULTIVARIABLE META-REGRESSION:", label, "\n")
  cat("Moderators:", paste(moderators, collapse = ", "), "\n")
  cat("=================================================\n")

  print(summary(model))

  return(model)
}

# ---------------------------------------------
# MULTIVARIABLE META-REGRESSION – MEAN CHANGE (MS)


moderators_sig <- c(
  "DURATION_WEEKS",
  "AGE_BASELINE",
  "MAN_RATIO"
)

mv_model_MS <- run_multivariable_meta_regression(
  df = MS_main,
  moderators = moderators_sig,
  label = "Mean change (MS)"
)

# -------------------------------------------------------
# MULTIVARIABLE META-REGRESSION – LEAST-SQUARES MEAN CHANGE (LS)


mv_model_LS <- run_multivariable_meta_regression(
  df = LS_main,
  moderators = moderators_sig,
  label = "Least-squares mean change (LS)"
)
