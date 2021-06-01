
### working versions of DIM, lm/regression, and instrumental variables estimators:

dim_estimator = function(df_exp, df_base, treatment, outcome){
  # hopefully a temp solution:
  packages <- c('dplyr', 'estimatr')
  lapply(packages, require, character.only = TRUE)

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

  return(rbind(dim_exp, dim_base, dim_bench) %>% unique() %>% dplyr::mutate(estimator = 'dim') %>% dplyr::select(nature, everything()))
}

### LM estimator

lm_estimator = function(df_exp, df_base, treatment, outcome, delete_vars = "id|source"){
  # hopefully a temp solution:
  packages <- c('dplyr', 'estimatr')
  lapply(packages, require, character.only = TRUE)

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

### IV estimator

iv_estimator = function(df_exp, df_base, treatment, outcome, delete_vars = "id|source", ...){
  # hopefully a temp solution:
  packages <- c('dplyr', 'estimatr')
  lapply(packages, require, character.only = TRUE)

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

