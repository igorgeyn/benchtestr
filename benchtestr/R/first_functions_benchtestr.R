### This is just to generate some super basic functions to test in the R package framework.
### You should install and load (at least install) the `dplyr` package if you have not yet done so.

## base R
adding_two <- function(x) {
  y = x + 2
  print(y)
}

story_mod <- function(num_bears) {
  paste('Goldilocks would have been better with',num_bears,'bears instead of three.')
}

## dplyr
## note this saves to global
dplyr_manip <- function(df, var_half, var_double) {
  require('dplyr')
  var_half <- sym(var_half)
  var_double <- sym(var_double)
  df_out <<- 
    df %>% 
    mutate(new_var1 = !!var_half/2,
           new_var2 = !!var_double*2) %>% 
    rename(var_half_new = new_var1,
           var_double_new = new_var2)
}


## Nonparametric estimation of robustness value
## Slow, suggest putting R = 10 to test
require(sensemakr); require(boot); require(randomizr)
benchmakr_rvq = function(sensitivity_stats = "rv_q",
                         data = darfur,
                         formula = "peacefactor ~ directlyharmed + age + farmer_dar + herder_dar +
                         pastvoted + hhsize_darfur + female + village", 
                         slice_prop = .5, 
                         treatment = "directlyharmed", 
                         bm_cov = "female", 
                         kd = 1:3,
                         R = 250){
  slice = simple_ra(nrow(data), prob = slice_prop)
  boot_fun = function(data, slice){
    data = rbind(data, data[slice,])
    model = lm(formula = as.formula(formula), data = data)
    out = sensemakr(model, treatment = treatment, benchmark_covariates = bm_cov, kd = kd)
    #out = out[["sensitivity_stats"]][[sensitivity_stats]] %>% as.numeric()   # Not working, set "rv_q" by default  
    out = out[["sensitivity_stats"]][["rv_q"]] %>% as.numeric()
    print(out)
  }
  out = boot(data = data, statistic = boot_fun, R = R, parallel = "multicore")
  print(out)
}

benchmakr_rvq_test = benchmakr_rvq(data = darfur, R = 10)
