library(tidyverse)
library(caroline)

### take a look at the Tennessee STAR data:

tenn_star <- read.tab('C:/Users/Igor/Desktop/grad school/coursework/SP21/200C/package/benchmarkr/benchtestr/data/STAR_students.tab')
tenn_compar <- read.tab('C:/Users/Igor/Desktop/grad school/coursework/SP21/200C/package/benchmarkr/benchtestr/data/Comparison_Students.tab')

tenn_star_df <- as.data.frame(tenn_star)
tenn_compar_df <- as.data.frame(tenn_compar)
# i ended up just running a few things in my console
# but we might want to draft up some code to do this more formally here:

setwd('C:/Users/Igor/Desktop/grad school/coursework/SP21/200C/package/benchmarkr/benchtestr/data')
save(tenn_star_df, file = "star_tenn_experiment.rda")
save(tenn_compar_df, file = "star_tenn_comparison.rda")
