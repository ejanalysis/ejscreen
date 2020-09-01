
# script to get just race ethnicity variables for use in ej analysis (e.g. percent hispanic)

# and to merge those into existing ejscreen dataset

# this is also in documentation help page for bg19 dataset

if (1 == 0) {

  # DOWNLOAD ACS TABLE WITH RACE ETHNICITY BY BLOCK GROUP
  # AND CREATE PERCENT VARIABLES LIKE PERCENT HISPANIC, ETC.

  # These will be added: (count and percent hispanic or latino, nonhispanic white alone i.e. single race,
  # nonhispanic black or african american alone, Not Hispanic or Latino American Indian and Alaska Native alone,
  # Not Hispanic or Latino Native Hawaiian and Other Pacific Islander alone,
  # and nh some other race alone, and nh two or more races)
  # [1] "hisp"            "nhwa"            "nhba"            "nhaiana"         "nhaa"            "nhnhpia"
  # [7] "nhotheralone"    "nhmulti"         "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
  # [13] "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone" "pctnhmulti"

  require(ejscreen)

  acsdata <- ejscreen.acsget(tables = 'B03002') # 10 minutes?? slow - downloads each state
  bg <- acsdata$bg
  bg <- ejscreen.acs.rename(bg)
  names(bg) <- gsub('pop3002', 'pop', names(bg))
  bg <- ejscreen.acs.calc(bg)

  # head(bg); hist(bg$pcthisp,100)  # write.csv(bg, file = 'demographics.csv', row.names = FALSE)
  # to SEE WHAT THOSE FIELDS ARE DEFINED AS
  # ejscreenformulas[ ejscreenformulas$Rfieldname %in% names(bg), c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula')]

  # MERGE DOWNLOADED RACE ETHNICITY
  # WITH blockgroup ejscreen dataset from ftp site or from ejscreen package data
  # Confirm only puerto rico is missing from bg, which bg19 has PR
  # setdiff(substr(bg19$FIPS, 1,2), substr(bg$FIPS,1,2))
  # [1] "72"

  bg2 <- merge(bg, bg19, by = 'FIPS', all.x = TRUE, all.y = TRUE, suffixes = c('_acs', '_bg19'))

  # check which fields were in both
  # > grep('_acs', names(bg2), value = T)
  # [1] "pop_acs"    "pctmin_acs" "mins_acs"
  # > grep('_bg19', names(bg2), value = T)
  # [1] "pop_bg19"    "mins_bg19"   "pctmin_bg19"
  # confirm value was same in both for avail block groups
  # > table(bg2$mins_acs == bg2$mins_bg19, useNA = 'always')
  # TRUE   <NA>
  #   217739   2594
  # > table(bg2$pop_acs == bg2$pop_bg19, useNA = 'always')
  # TRUE   <NA>
  #   217739   2594
  # almost exactly the same percent minority values:
  # table(abs(bg2$pctmin_acs - bg2$pctmin_bg19)/bg2$pctmin_acs < 0.00001, useNA = 'always')
  # TRUE   <NA>
  #   211244   9089
  #
  # rename to original names, using the bg19 version and dropping duplicate from acs download

  names(bg2) <- gsub('pop_bg19', 'pop', names(bg2)); bg2$pop_acs <- NULL
  names(bg2) <- gsub('mins_bg19', 'mins', names(bg2)); bg2$mins_acs <- NULL
  names(bg2) <- gsub('pctmin_bg19', 'pctmin', names(bg2)); bg2$pctmin_acs <- NULL

  bg19 <- bg2 #replace with expanded version of dataset
  save(bg19, file = 'bg19.rdata')

}
