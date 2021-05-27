### this script is to queue up some basic estimators for use in the package

# first...

# let's just start with DIM
# we can do something like a function that allows for a single estimator to be
# passed to two dataframes (or vice versa)

naive_dim_comparison <- function(df1, df2, treatment, outcome) {
  # initialize a df for final output
  final_output <<- as.data.frame(matrix())
  treatment_sym <- sym(treatment)
  outcome_sym <- sym(outcome)
  dim_estimator_df1 <- df1 %>%
    group_by(!!treatment_sym) %>%
    summarise(avg_earnings = mean(!!outcome_sym),
              earnings_var = var(!!outcome_sym),
              count = n())

  # need to input treatment_length fxn here
  # need to input control_length fxn here

  dim_estimate1 <<- dim_estimator_df1$avg_earnings[2] - dim_estimator_df1$avg_earnings[1]
  # see above for how to fix se
  # se_dim <<- sqrt((dim_estimator_df1[1,3]/length(df1$!!treatment_sym[df1$!!treatment_sym == 1])) +
  #                   (dim_estimator_df1[2,3]/length(df1$!!treatment_sym[df1$!!treatment_sym == 0])))

  # create the df of treatment-only from df1
  df1_treated_only <- df1 %>%
    filter(treat == 1) %>%
    # select(c(treatment, outcome))
    select(c('treat', 're78'))

  # create df2 and bind treatment-only from df1 to it
  dim_estimator_df2 <- df2 %>%
    # filter(!is.na(!!treatment_sym) & !is.na(!!outcome_sym)) %>%
    # select(c(!!treatment_sym, !!outcome_sym)) %>%
    select(c('treat', 're78')) %>%
    rbind(df1_treated_only) %>%
    group_by(!!treatment_sym) %>%
    summarise(avg_earnings = mean(!!outcome_sym, na.rm = TRUE),
              earnings_var = var(!!outcome_sym, na.rm = TRUE),
              count = n())

  # need to input treatment_length fxn here
  # need to input control_length fxn here

  dim_estimate2 <<- dim_estimator_df2$avg_earnings[2] - dim_estimator_df2$avg_earnings[1]

}

## Bug fixed to improve generalisability 
naive_dim_comparison <- function(df1, df2, treatment, outcome) {
  # Initialise relevant packages
  require(tidyverse)
  options(dplyr.summarise.inform = F)
  
  # Set up the treatment and outcome variables
  treatment_sym <- sym(treatment)
  outcome_sym <- sym(outcome)
  df1 <- df1 %>% mutate_at(treatment, as.numeric)
  df2 <- df2 %>% mutate_at(treatment, as.numeric)
  
  # Estimating the means and variances
  dim_estimator_df1 <- df1 %>%
    group_by(!!treatment_sym) %>%
    summarise(avg_earnings = mean(!!outcome_sym),
              earnings_var = var(!!outcome_sym),
              count = n())
  
  # Calculating the DIM estimates and SE
  dim_estimate1 <- filter(dim_estimator_df1, !!treatment_sym == 1)$avg_earnings - filter(dim_estimator_df1, !!treatment_sym == 0)$avg_earnings
  se_dim1 <- dim_estimator_df1 %>% mutate(se_cal = earnings_var / count) %>% colSums()
  se_dim1 <- se_dim1["se_cal"] %>% sqrt() %>% as.numeric()
  
  # Create the df of treatment-only from df1
  df1_treated_only <- df1 %>%
    filter(!!treatment_sym == 1 | !!treatment_sym == T) %>%
    dplyr::select(matches(paste(treatment, outcome, sep = "|")))

  # Create df2 and bind treatment-only from df1 to it
  dim_estimator_df2 <- df2 %>%
    drop_na(!!treatment_sym) %>% drop_na(!!outcome_sym) %>%
    dplyr::select(matches(paste(treatment, outcome, sep = "|"))) %>%
    rbind(df1_treated_only) %>%
    group_by(!!treatment_sym) %>%
    summarise(avg_earnings = mean(!!outcome_sym, na.rm = TRUE),
              earnings_var = var(!!outcome_sym, na.rm = TRUE),
              count = n())
  
  # Calculating the DIM estimates and SE
  dim_estimate2 <- filter(dim_estimator_df2, !!treatment_sym == 1)$avg_earnings - filter(dim_estimator_df2, !!treatment_sym == 0)$avg_earnings
  se_dim2 <- dim_estimator_df2 %>% mutate(se_cal = earnings_var / count) %>% colSums()
  se_dim2 <- se_dim2["se_cal"] %>% sqrt() %>% as.numeric()
  
  # Combining the outputs
  final_output <- c(dim_estimate1, se_dim1, dim_estimate2, se_dim2)
  names(final_output) <- c("dim_estimate1", "se_dim1", "dim_estimate2", "se_dim2")
  
  return(final_output)
}

data("lalonde")
naive_dim_comparison(lalonde, lalonde, "treat", "re78")
naive_dim_comparison(causaldata::Mroz, causaldata::Mroz, "lfp", "inc")

