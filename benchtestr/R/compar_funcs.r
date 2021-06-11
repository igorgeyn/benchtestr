
### A function to compare estimates from different estimators
## need to figure out the else statements, and to code out dependencies.

compar_ests = function(dim, lm, match, df_exp, df_base, treatment, outcome, covars, formula_arg, reg_formula) {
  require('gtools'); require('reshape2')
  if(dim == 1) {
    dim_output = dim_estimator(df_exp = df_exp, df_base = df_base, treatment = treatment, outcome = outcome) %>% 
      select(c('estimator', 'nature', 'term', 'estimate', 'conf.low', 'conf.high', 'outcome'))
    }
  else {
    dim_output = X
  }
  if(lm == 1) {
    lm_output = lm_estimator(df_exp = df_exp, df_base = df_base, treatment = treatment, outcome = outcome) %>% 
      select(c('estimator', 'nature', 'term', 'estimate', 'conf.low', 'conf.high', 'outcome')) %>% 
      filter(term == 'treat')
  }
  else {
    lm_output = X
  }
  if(match == 1) {
    match_out_stage = match_estimator(df_exp = df_exp, df_bench = df_base, treatment = treatment, 
                                      outcome = outcome, covars = covars,
                                      formula_arg = formula_arg, 
                                      reg_formula = reg_formula)
    match_out_stage = as.data.frame(t(apply(match_out_stage,1,unlist))) %>% 
      mutate(match_method = trimws(V1), estimate = as.numeric(V2)) %>% 
      select(c('match_method', 'estimate'))
    match_out = melt(match_out_stage, id.vars = 'match_method') %>% select(c('match_method', 'value')) %>%
      rename(estimator = match_method, estimate = value)
  }
  else {
    match_out = X
  }
  compare_out = smartbind(list = list(dim_output, lm_output, match_out))
  return(compare_out)
}