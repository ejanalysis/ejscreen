#' @name bg20DemographicSubgroups2014to2018
#' @docType data
#' @title Demographic subgroups of race/ethnicity by block group (ACS2014-2018 for bg20 and 2020v of EJSCREEN)
#' @description This 2014-2018 dataset fits with the \link{bg20} data
#'   which is the 2020 version of EJSCREEN (actually released early/mid 2021).
#'  EJScreen 2.1 was released circa August 2022.
#'    EJScreen 2.1 uses ACS2020, which is from 2016-2020 (released March 17 2022, delayed from Dec 2021).
#'    It was to be called the 2022 version of EJScreen, and
#'    here is called bg22.
#'
#'  EJScreen 2.0 was released by EPA 2022-02-18 (delayed from mid/late 2021).
#'    EJScreen 2.0 used ACS2019, which is from 2015-2019 (released Dec 2020).
#'    It was to be called the 2021 version, and here is called bg21 as it was to be a late 2021 version.
#'
#'  \preformatted{
#'
#'   This dataset can be merged with EJSCREEN data for analysis of the subgroups, as shown below.
#'
#'   This dataset provides percent Hispanic, percent Non-Hispanic Black Alone (not multirace), etc.
#'   Additional detail in demographic subgroups beyond demographic info
#'   that is in EJSCREEN dataset. Block group resolution for USA.
#'   From Census ACS 5 year summary file.
#'   Race ethnicity groups are defined by Census Bureau. They are
#'   mutually exclusive (no overlaps between groups,
#'   so a person is always in only one of these groups)
#'   so they add up to the total population count or percent.
#'  }
#' @details
#' \preformatted{
#'
#'   Note the 2021 version of EJSCREEN  released early 2022 not late 2021
#'   actually uses ACS2019 and fits with bg21DemographicSubgroups2015to2019, which is from 2015-2019 (released by Census late 2020).
#'
#'   Note the 2020 version of EJSCREEN released not in late 2020 but actually early-mid 2021, in bg20
#'   actually uses ACS2018 and fits with bg20DemographicSubgroups2014to2018, which is from 2014-2018 (released by Census late 2019).
#'
#'   This data was created by downloading and calculating
#'   DETAILED RACE ETHNICITY SUBGROUP VARIABLES THAT ARE NOT IN EJSCREEN
#'   INCLUDING % Hispanic, etc. (the subgroups within "minority")
#'   for use in EJ analysis.
#'
#'   This will give a quick look at some key stats:
#'    round(data.frame(cbind(
#'      subgroups=unlist(ustotals(bg20DemographicSubgroups2014to2018)),
#'      maingroups= unlist(ustotals(bg20[bg20$ST !='PR',])))
#'      ),2)
#'
#'   This can be MERGED WITH the EJSCREEN DATASET (see below).
#'
#'   This may also be addressed in documentation help page for \link{bg20}
#'
#'     ######################################################################################
#'     # How to merge demographic subgroup info into the basic EJSCREEN bg21 dataset:
#'     ######################################################################################
#'
#'     d <- bg20DemographicSubgroups2014to2018
#'     d <- d[ , !(names(d) %in% c('pop', 'mins', 'pctmin'))]
#'     bg20plus <- merge(bg20, d, by = 'FIPS', all.x = TRUE)
#'     rm(d)
#'     # save(bg20plus, file = 'bg20plus EJSCREEN dataset plus race ethnic subgroups.rdata')
#'     # write.csv(bg20plus, file = 'bg20plus EJSCREEN dataset plus race ethnic subgroups.csv')
#'     ##########################################
#'
#'     # Note that only Puerto Rico is missing from this ACS dataset.
#'     # while bg20 has PR, so when merged, the PR rows will be NA for pcthisp, etc.
#'     # setdiff(substr(bg20$FIPS, 1,2), substr(bg20DemographicSubgroups2014to2018$FIPS,1,2))
#'     # [1] "72" which is the FIPS code for Puerto Rico.
#'
#'     names(bg20plus)[!(names(bg20plus) %in% names(bg20))]
#'  }
#'   \preformatted{
#'
#'   ######################################################################################
#'   How bg21DemographicSubgroups2015to2019 was created:
#'   ######################################################################################
#'
#'     # DOWNLOAD ACS TABLE WITH RACE ETHNICITY BY BLOCK GROUP
#'     # AND CREATE PERCENT VARIABLES LIKE PERCENT HISPANIC, ETC.
#'
#'     # These are created: (count and percent hispanic or latino, nonhispanic white alone i.e. single race,
#'   # nonhispanic black or african american alone, Not Hispanic or Latino American Indian and Alaska Native alone,
#'   # Not Hispanic or Latino Native Hawaiian and Other Pacific Islander alone,
#'   # and nh some other race alone, and nh two or more races)
#'   # [1] "hisp"            "nhwa"            "nhba"            "nhaiana"         "nhaa"            "nhnhpia"
#'   # [7] "nhotheralone"    "nhmulti"         "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
#'   # [13] "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone" "pctnhmulti"
#'
#'   # setwd('~/Downloads/acs1418')
#'
#'   library(ejscreen); library(ejanalysis); library(analyze.stuff); require(ACSdownload)
#'   acsdata <- ejscreen.acsget(tables = 'B03002',
#'     end.year = 2018,
#'     base.path = '~/Downloads/acs1418', sumlevel = 'both' )
#'     # 10 minutes?? slow - downloads each state
#'   bgACS   <- ejscreen.acs.rename(acsdata$bg)
#'   names(bgACS) <- gsub('pop3002', 'pop', names(bgACS))
#'   bgACS   <- ejscreen.acs.calc(bgACS)
#'   rm(acsdata)
#'   # head(bgACS); hist(bgACS$pcthisp,100)  # write.csv(bgACS, file = 'demographics.csv', row.names = FALSE)
#'   # to SEE WHAT THOSE FIELDS ARE DEFINED AS
#'   # ejscreenformulas[ ejscreenformulas$Rfieldname %in% names(bgACS), c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula')]
#'
#'   bg20DemographicSubgroups2014to2018 <- bgACS
#'   save(bg20DemographicSubgroups2014to2018,
#'     file = '~/Documents/R PACKAGES/ejscreen/data/bg20DemographicSubgroups2014to2018.rdata')
#'
#'     ######################################################################################
#'     # SUMMARY STATS ON DISPARITY BY GROUP BY ENVT ISSUE
#'     #  See help for RR.table() in ejanalysis package
#'
#'     x <- ejanalysis::RR.table(bg20plus, Enames = names.e, Dnames = c(names.d, names.d.subgroups), popcolname = 'pop', digits = 2)
#'     y <- ejanalysis::RR.means(bg20plus[ , names.e], bg20plus[ , c(names.d, names.d.subgroups)], bg20plus$pop)
#'     y
#'     x
#'     }
#'
NULL
