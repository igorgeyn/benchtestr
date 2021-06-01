
### working versions of DIM, lm/regression, and instrumental variables estimators:

dim_estimator = function(df_exp, df_base, treatment, outcome){
  require(estimatr)
  
  # Select only the treatment and outcome variables
  df_exp = df_exp %>% dplyr::select(matches(paste(treatment, outcome, sep = "|"))) %>% mutate_at(treatment, as.numeric)
  df_base = df_base %>% dplyr::select(matches(paste(treatment, outcome, sep = "|"))) %>% mutate_at(treatment, as.numeric)
  
  # Estimate three different ways of DIM
  dim_exp = difference_in_means(as.formula(paste(outcome, "~", treatment)), data = df_exp) %>%
    tidy() %>% mutate(nature = "experimental")
  if(mean(df_base["treat"][,1]) > 0){
    dim_base = difference_in_means(as.formula(paste(outcome, "~", treatment)), data = df_base) %>%
    tidy() %>% mutate(nature = "base")
  } else {
    dim_base = dim_exp
  }
  dim_bench = difference_in_means(as.formula(paste(outcome, "~", treatment)), data = rbind(df_exp, df_base)) %>%
    tidy() %>% mutate(nature = "benched")
  
  return(rbind(dim_exp, dim_base, dim_bench) %>% unique() %>% dplyr::select(nature, everything()))
}
dim_estimator(df_exp = nsw_dehejia_wahba, df_base = psid_controls_dw,
              treatment = 'treat', outcome = 're78')
```

### LM estimator

```{r}
lm_estimator = function(df_exp, df_base, treatment, outcome, delete_vars = "id|source"){
  require(estimatr)
  
  # Avoid problems with logical treatment variables
  df_exp = df_exp %>% mutate_at(treatment, as.numeric)
  df_base = df_base %>% mutate_at(treatment, as.numeric)
  
  # Find out the control variables
  controls = names(df_exp)
  controls = controls[!grepl(delete_vars, controls) & controls != treatment & controls != outcome]
  controls = paste(controls, collapse = " + ")
  
  # Three different ways of LM estimators
  lm_exp = lm_robust(as.formula(paste(outcome, "~", treatment, "+", controls)), data = df_exp) %>%
    tidy() %>% mutate(nature = "experimental")
  if(mean(df_base["treat"][,1]) > 0){
    lm_base = lm_robust(as.formula(paste(outcome, "~", treatment, "+", controls)), data = df_base) %>%
      tidy() %>% mutate(nature = "base")
  } else {
    lm_base = lm_exp
  }
  lm_bench = lm_robust(as.formula(paste(outcome, "~", treatment, "+", controls)), 
                       data = rbind(df_exp %>% dplyr::select(matches(paste(treatment, outcome, gsub(" \\+ ", "|", controls), sep = "|"))), 
                                    df_base %>% dplyr::select(matches(paste(treatment, outcome, gsub(" \\+ ", "|", controls), sep = "|"))))) %>%
    tidy() %>% mutate(nature = "benched")
  
  return(rbind(lm_exp, lm_base, lm_bench) %>% unique() %>% dplyr::select(nature, everything()) %>% 
           filter(term == "treat") %>% mutate(control = controls))
}
lm_estimator(df_exp = nsw_dehejia_wahba, df_base = psid_controls_dw,
             treatment = 'treat', outcome = 're78')
```

### IV estimator

```{r}
iv_estimator = function(df_exp, df_base, treatment, outcome, delete_vars = "id|source", ...){
  require(estimatr)
  
  # Avoid problems with logical treatment variables
  df_exp = df_exp %>% mutate_at(treatment, as.numeric) %>% dplyr::select(!matches(delete_vars))
  df_base = df_base %>% mutate_at(treatment, as.numeric) %>% dplyr::select(!matches(delete_vars))
  
  # Find out the instrumental variable
  if(missing(iv_var_arg)) {
    iv_var = cor(df_exp) %>% as.data.frame() %>% mutate(term = colnames(.)) %>% 
    dplyr::select(matches(paste("term", treatment, outcome, sep = "|"))) %>% 
    filter(term != treatment & term != outcome) %>%
    mutate(value = abs(!!sym(treatment)) - abs(!!sym(outcome))) %>%
    arrange(desc(value))
  iv_var = iv_var$term[1]
  }
  else {
    iv_var = iv_var_arg
  }
  
  # Find out the control variables
  controls = names(df_exp)
  controls = controls[!grepl(delete_vars, controls) & controls != treatment & controls != outcome & controls != iv_var]
  controls = paste(controls, collapse = " + ")
  
  # Three different ways of IV estimators
  iv_exp = iv_robust(as.formula(paste(outcome, "~", treatment, "+", controls, "|", iv_var, "+", controls)), data = df_exp) %>%
    tidy() %>% mutate(nature = "experimental")
  if(mean(df_base["treat"][,1]) > 0){
    iv_base = iv_robust(as.formula(paste(outcome, "~", treatment, "+", controls, "|", iv_var, "+", controls)), data = df_base) %>%
     tidy() %>% mutate(nature = "base")
  } else {
    iv_base = iv_exp
  }
  iv_bench = iv_robust(as.formula(paste(outcome, "~", treatment, "+", controls, "|", iv_var, "+", controls)), 
                       data = rbind(df_exp, df_base)) %>%
    tidy() %>% mutate(nature = "benched")
  return(rbind(iv_exp, iv_base, iv_bench) %>% unique() %>% dplyr::select(nature, everything()) %>% 
           filter(term == "treat") %>% mutate(iv_var = iv_var, control = controls))
}

iv_estimator(df_exp = nsw_dehejia_wahba, df_base = psid_controls_dw,
             treatment = 'treat', outcome = 're78')
```

#####################################
# holding place for some of the old versions of the estimators
#####################################

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

