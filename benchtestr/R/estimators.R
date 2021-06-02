
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

  return(rbind(dim_exp, dim_base, dim_bench) %>% unique() %>% dplyr::mutate(estimator = 'dim') %>% dplyr::select(estimator, nature, everything()))
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

  return(rbind(lm_exp, lm_base, lm_bench) %>% unique() %>% dplyr::mutate(control = controls, estimator = 'lm')) %>% dplyr::select(estimator, nature, everything()) %>%
           filter(term == "treat")
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
  return(rbind(iv_exp, iv_base, iv_bench) %>% unique() %>% mutate(iv_var = iv_var, control = controls, estimator = 'iv')) %>% dplyr::select(estimator, nature, everything()) %>%
           filter(term == "treat")
}

### Balance assessor for matching

balance_assess <- function(df_exp, df_bench, treat, outcome, covars, formula_arg, ...) {
  require('cobalt')
  require('dplyr')
  require('gridExtra')
  require('MatchIt')
  # First get the data ready
  data_for_balance_assess = rbind(df_exp %>% filter(!!sym(treat) == 1) %>% select(treat, all_of(covars)), df_bench %>% filter(!!sym(treat) == 0) %>% select(treat, all_of(covars)))
  match_cem = matchit(formula = formula_arg, data = data_for_balance_assess, method = 'cem', estimand = 'ATT')
  match_nearest = matchit(formula = formula_arg, data = data_for_balance_assess, method = 'nearest', estimand = 'ATT') # leaving ATT as the default, can be overriden
  match_full = matchit(formula = formula_arg, data = data_for_balance_assess, method = 'full', estimand = 'ATT')
  match_subclass = matchit(formula = formula_arg, data = data_for_balance_assess, method = 'subclass', subclass = 5, estimand = 'ATT') # 5 subclass default, can be overriden
  return(grid.arrange(
    love.plot(match_cem, binary = 'std'),
    love.plot(match_nearest, binary = 'std'),
    love.plot(match_full, binary = 'std'),
    ncol = 2))
}

### Matching estimator

match_estimator <- function(df_exp, df_bench, treatment, outcome,
                            covars, formula_arg, reg_formula, ...) {
  require(dplyr); require(MatchIt)
  
  data_for_match <<- as.data.frame(
    rbind(df_exp %>% filter(!!sym(treatment) == 1) %>% select(c(treatment, outcome, all_of(covars))),
          df_bench %>% filter(!!sym(treatment) == 0) %>% select(c(treatment, outcome, all_of(covars))))
    )
  
  match_cem = matchit(formula = formula_arg, data = data_for_match, method = 'cem', estimand = 'ATT')
  match_nearest = matchit(formula = formula_arg, data = data_for_match, method = 'nearest', estimand = 'ATT')
  match_full = matchit(formula = formula_arg, data = data_for_match, method = 'full', estimand = 'ATT')
  match_subclass = matchit(formula = formula_arg, data = data_for_match, method = 'subclass', subclass = 5, estimand = 'ATT')
  
  match_objs <- list(match_cem, match_nearest, match_full, match_subclass)
  effect_ests_list = list()
  
  for (m in match_objs) {
    m_out_effect_est <- summary(lm(data = match.data(m), reg_formula))$coefficients[2]
    effect_ests_list <- rbind(effect_ests_list, m_out_effect_est)
  }
  
  m_out_df <- cbind(c('cem', 'nearest', 'full', 'subclass'), effect_ests_list)
  names(m_out_df) <- c('index', 'match_method', 'estimate')
  m_out_df <<- as.data.frame(m_out_df)
  }