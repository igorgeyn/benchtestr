#####
# This file is to set up some of the things that are going to end up in the `benchtestr` packcage
# but which need a bit of TLC.
#####

library(haven)
library(foreign)
library(readstata13)
library(dplyr)

### dehejia and wahba data from here:
### https://users.nber.org/~rdehejia/data/.nswdata3.html

## make sure the files are in the wd, and then:

# this is Dehejia and Wahba's sample of the NSW data
setwd('C:/Users/Igor/Desktop/grad school/coursework/SP21/200C/package/benchmarkr/package_prep')
nsw_dehejia_wahba <- readstata13::read.dta13('nsw_dw.dta')
save(nsw_dehejia_wahba, file = "nsw_dehejia_wahba.rda")

# this is the data for the PSID (1-3)
# and the CPS controls.
# NOTE THAT AS OF THIS WIRTING THE LINK
# ABOVE HAD INCOMPLETE DATA
# (delete comment once resolved)
psid_controls_1 <- readstata13::read.dta13('psid_controls.dta')
psid_controls_2 <- readstata13::read.dta13('psid_controls2.dta') # missing
psid_controls_3 <- readstata13::read.dta13('psid_controls3.dta')
cps_controls_1 <- readstata13::read.dta13('cps_controls.dta')
cps_controls_2 <- readstata13::read.dta13('cps_controls2.dta')
cps_controls_3 <- readstata13::read.dta13('cps_controls3.dta') # missing

# make changes, append, and save as .RDA
# PSID files
psid_controls_1 <- psid_controls_1 %>% mutate(source = 'psid1')
# psid_controls_2 <- psid_controls_2 %>% mutate(source = 'psid2') # missing
psid_controls_3 <- psid_controls_3 %>% mutate(source = 'psid3')
psid_controls_dw <- rbind(psid_controls_1, psid_controls_3)
save(psid_controls_dw, file = "psid_controls_dw.rda")

# make changes, append, and save as .RDA
# CPS files
cps_controls_1 <- cps_controls_1 %>% mutate(source = 'cps1')
# cps_controls_2 <- cps_controls_2 %>% mutate(source = 'cps2') # missing
cps_controls_3 <- cps_controls_3 %>% mutate(source = 'cps3')
cps_controls_dw <- rbind(cps_controls_1, cps_controls_2)
save(cps_controls_dw, file = "cps_controls_dw.rda")

### doing similar to the above but for the Tennessee data:

# need this for some basic data prep:
require('some_basic_data_exploration.R')
setwd('C:/Users/Igor/Desktop/grad school/coursework/SP21/200C/package/benchmarkr/benchtestr/data')
save(tenn_star_df, file = "star_tenn_experiment.rda")
save(tenn_compar_df, file = "star_tenn_comparison.rda")


