###############################################################################
# LEAVE-ONE-OUT SENSITIVITY ANALYSIS
# Random-effects model (REML)
###############################################################################

library(metafor)
MS_main <- read.csv("data/MS_main.csv")
LS_main <- read.csv("data/LS_main.csv")

# ---------------------------------------------- 
# FUNCTION: LEAVE-ONE-OUT META-ANALYSIS


run_leave_one_out <- function(df, label) {

  # Calculate Cohen's d (if not already present)
  if (!"OUTCOME_smd" %in% colnames(df)) {
    df$OUTCOME_smd <- df$OUTCOME_mean / df$OUTCOME_sd
  }

  # Convert Cohen's d to Hedges' g
  df$g <- df$OUTCOME_smd * (1 - 3 / (4 * (df$N - 1) - 1))

  # Sampling variance
  df$vi <- (1 / df$N + df$g^2 / (2 * df$N)) *
           ((df$N - 1) / (df$N - 3.94))

  # Fit main model
  model <- rma(
    yi = g,
    vi = vi,
    data = df,
    method = "REML"
  )

  # Leave-one-out analysis
  loo <- leave1out(model)

  cat("\n=================================================\n")
  cat("LEAVE-ONE-OUT SENSITIVITY ANALYSIS:", label, "\n")
  cat("=================================================\n")

  print(loo)

  return(loo)
}

# -------------------------------------- 
# RUN LEAVE-ONE-OUT ANALYSES


loo_MS <- run_leave_one_out(
  df = MS_main,
  label = "Mean change (MS)"
)

loo_LS <- run_leave_one_out(
  df = LS_main,
  label = "Least-squares mean change (LS)"
)
