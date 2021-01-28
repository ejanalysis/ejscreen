

# This has been moved to help file for 
# data(bgDemographicSubgroups2015to2019) 

# SCRIPT TO DOWNLOAD AND CALCULATE
#   [AND later MERGE INTO EJSCREEN DATASET ]
# DETAILED RACE ETHNICITY SUBGROUP VARIABLES THAT ARE NOT IN EJSCREEN
# INCLUDING % Hispanic, etc. (the subgroups within "minority")
# for use in EJ analysis
#
# This is also addressed in documentation help page for bg19 dataset via ?bg19

#   Note the 2020 version of EJSCREEN released late 2020
#     actually uses ACS2018, which is from 2014-2018 (released late 2019).
#   Note the 2019 version of EJSCREEN (released late 2019)
#     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#   Note the 2018 version of EJSCREEN (released late 2018)
#     actually uses ACS2016, which is from 2012-2016 (released late 2017).

if (1 == 0) {
  ######################################################################################

  # DOWNLOAD ACS TABLE WITH RACE ETHNICITY BY BLOCK GROUP
  # AND CREATE PERCENT VARIABLES LIKE PERCENT HISPANIC, ETC.

  # These will be added: (count and percent hispanic or latino, nonhispanic white alone i.e. single race,
  # nonhispanic black or african american alone, Not Hispanic or Latino American Indian and Alaska Native alone,
  # Not Hispanic or Latino Native Hawaiian and Other Pacific Islander alone,
  # and nh some other race alone, and nh two or more races)
  # [1] "hisp"            "nhwa"            "nhba"            "nhaiana"         "nhaa"            "nhnhpia"
  # [7] "nhotheralone"    "nhmulti"         "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
  # [13] "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone" "pctnhmulti"

  library(ejscreen); library(ejanalysis); library(analyze.stuff); require(ACSdownload)
  
  setwd('~/../Downloads/acs')
  
  acsdata <- ejscreen.acsget(tables = 'B03002', end.year = 2019, 
                             base.path = '~/../Downloads/acs', sumlevel = 'both' ) # 10 minutes?? slow - downloads each state
  bgACS   <- ejscreen.acs.rename(acsdata$bg)
  names(bgACS) <- gsub('pop3002', 'pop', names(bgACS))
  bgACS   <- ejscreen.acs.calc(bgACS)
  # rm(acsdata)
  # head(bgACS); hist(bgACS$pcthisp,100)  # write.csv(bgACS, file = 'demographics.csv', row.names = FALSE)
  # to SEE WHAT THOSE FIELDS ARE DEFINED AS
  # ejscreenformulas[ ejscreenformulas$Rfieldname %in% names(bgACS), c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula')]

  # could save just that now:
  bgDemographicSubgroups2015to2019 <- bgACS 
  # rm(bgACS) # used below in script to merge with bg20 etc.
  save(bgDemographicSubgroups2015to2019, file = 'bgDemographicSubgroups2015to2019.rdata')

  ######################################################################################

  ###########################################
  # MERGE the
  # DOWNLOADED ACS SUBGROUPS OF RACE ETHNICITY blockgroups
  # with the
  # EJSCREEN dataset blockgroups (from ftp site or from ejscreen package data)

  # Note that only Puerto Rico is missing from bgACS?
  # while bg19 has PR
  # setdiff(substr(bg19$FIPS, 1,2), substr(bgACS$FIPS,1,2))
  # [1] "72" which is the FIPS code for Puerto Rico.

  bg <- 0 # just to stop RStudio from warnings about bg not existing.
  # # Use one of these, for example:
  # bg <- bg19 #; yr <- 2019
  # bg <- bg19 #; yr <- 2019

  ###########################################
  # merge bgACS info into bg
  ###########################################

  bg2 <- merge(bgACS, bg, by = 'FIPS', all.x = TRUE, all.y = TRUE, suffixes = c('_acs', '_bg'))

  # check which fields were in both
  # > grep('_acs', names(bg2), value = T)
  # [1] "pop_acs"    "pctmin_acs" "mins_acs"
  # > grep('_bg', names(bg2), value = T)
  # [1] "pop_bg"    "mins_bg"   "pctmin_bg"
  # confirm value was same in both for avail block groups
  # > table(bg2$mins_acs == bg2$mins_bg, useNA = 'always')
  # TRUE   <NA>
  #   217739   2594
  # > table(bg2$pop_acs == bg2$pop_bg, useNA = 'always')
  # TRUE   <NA>
  #   217739   2594
  # almost exactly the same percent minority values:
  # table(abs(bg2$pctmin_acs - bg2$pctmin_bg)/bg2$pctmin_acs < 0.00001, useNA = 'always')
  # TRUE   <NA>
  #   211244   9089
  #
  # rename to original names, using the bg version and dropping duplicate from acs download

  names(bg2) <- gsub('pop_bg', 'pop', names(bg2)); bg2$pop_acs <- NULL
  names(bg2) <- gsub('mins_bg', 'mins', names(bg2)); bg2$mins_acs <- NULL
  names(bg2) <- gsub('pctmin_bg', 'pctmin', names(bg2)); bg2$pctmin_acs <- NULL

  #replace with expanded version of dataset, once sure merge was ok.
  bg <- bg2; rm(bg2, bgACS)
  ###########################################


  ###########################################
  # # Then use one of these, for example, to save the full merge as a data file:
  # bg19 <- bg; rm(bg); save(bg19, file = 'bg19.rdata')
  # bg20 <- bg; rm(bg); save(bg20, file = 'bg20.rdata')
  # # then move the .rdata file to the data folder and rebuild the package.
}
