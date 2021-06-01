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

## this is just a little toy function to get the counts of
## treated and control from a df
## for use in SE calculation, etc.

## THIS NEEDS DOCUMENTATION IF IT'S GOING TO BE USED.
get_group_counts <- function(df, treatment) {
  treatment_count <<- length(df$treatment[df$treatment == 1])
  control_count <<- length(df$treatment[df$treatment == 0])
}



