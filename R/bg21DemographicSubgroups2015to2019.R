#' @name bg21DemographicSubgroups2015to2019
#' @docType data
#' @title Demographic subgroups of race/ethnicity by block group (ACS2015-2019 for bg21 and late 2021v of EJSCREEN)
#' @description This 2015-2019 dataset will fit with the \link{bg21} data once available,
#'   which will be the 2021 version of EJSCREEN to be released possibly very late 2021.
#'   The version available as of September 2021 is actually still the 2020 version of EJSCREEN.
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
#'   Note the 2021 version of EJSCREEN possibly to be released near the end of 2021
#'   actually uses ACS2019 and fits with bg21DemographicSubgroups2015to2019, which is from 2015-2019 (released by Census late 2020).
#'
#'   Note the 2020 version of EJSCREEN released not in late 2020 but actually early-mid 2021, in bg20
#'   actually uses ACS2018 and fits with bg20DemographicSubgroups2014to2018, which is from 2014-2018 (released by Census late 2019).
#'
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'   actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'
#'   This data was created by downloading and calculating
#'   DETAILED RACE ETHNICITY SUBGROUP VARIABLES THAT ARE NOT IN EJSCREEN
#'   INCLUDING % Hispanic, etc. (the subgroups within "minority")
#'   for use in EJ analysis.
#'
#'   This will give a quick look at some key stats:
#'    round(data.frame(cbind(
#'      subgroups=unlist(ustotals(bg21DemographicSubgroups2015to2019)),
#'      maingroups= unlist(ustotals(bg21[bg21$ST !='PR',])))
#'      ),2)
#'
#'   This can be MERGED WITH the EJSCREEN DATASET (see below).
#'
#'   This may also be addressed in documentation help page for \link{bg21}
#'
#'     ######################################################################################
#'     # How to merge demographic subgroup info into the basic EJSCREEN bg21 dataset:
#'     ######################################################################################
#'
#'     d <- bg21DemographicSubgroups2015to2019
#'     d <- d[ , !(names(d) %in% c('pop', 'mins', 'pctmin'))]
#'     bg21plus <- merge(bg21, d, by = 'FIPS', all.x = TRUE)
#'     rm(d)
#'     # save(bg21plus, file = 'bg21plus EJSCREEN dataset plus race ethnic subgroups.rdata')
#'     # write.csv(bg21plus, file = 'bg21plus EJSCREEN dataset plus race ethnic subgroups.csv')
#'     ##########################################
#'
#'     # Note that only Puerto Rico is missing from this ACS dataset.
#'     # while bg21 has PR, so when merged, the PR rows will be NA for pcthisp, etc.
#'     # setdiff(substr(bg21$FIPS, 1,2), substr(bg21DemographicSubgroups2015to2019$FIPS,1,2))
#'     # [1] "72" which is the FIPS code for Puerto Rico.
#'
#'     names(bg21plus)[!(names(bg21plus) %in% names(bg21))]
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
#'   # setwd('~/Downloads/acs1519')
#'
#'   library(ejscreen); library(ejanalysis); library(analyze.stuff); require(ACSdownload)
#'   acsdata <- ejscreen.acsget(tables = 'B03002',
#'     end.year = 2019,
#'     base.path = '~/Downloads/acs1519', sumlevel = 'both' )
#'     # 10 minutes?? slow - downloads each state
#'   bgACS   <- ejscreen.acs.rename(acsdata$bg)
#'   names(bgACS) <- gsub('pop3002', 'pop', names(bgACS))
#'   bgACS   <- ejscreen.acs.calc(bgACS)
#'   rm(acsdata)
#'   # head(bgACS); hist(bgACS$pcthisp,100)  # write.csv(bgACS, file = 'demographics.csv', row.names = FALSE)
#'   # to SEE WHAT THOSE FIELDS ARE DEFINED AS
#'   # ejscreenformulas[ ejscreenformulas$Rfieldname %in% names(bgACS), c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula')]
#'
#'   bg21DemographicSubgroups2015to2019 <- bgACS
#'   save(bg21DemographicSubgroups2015to2019,
#'     file = '~/Documents/R PACKAGES/ejscreen/data/bg21DemographicSubgroups2015to2019.rdata')
#'
#'     ######################################################################################
#'     # SUMMARY STATS ON DISPARITY BY GROUP BY ENVT ISSUE
#'     #  See help for RR.table() in ejanalysis package
#'
#'     x <- ejanalysis::RR.table(bg21plus, Enames = names.e, Dnames = c(names.d, names.d.subgroups), popcolname = 'pop', digits = 2)
#'     y <- ejanalysis::RR.means(bg21plus[ , names.e], bg21plus[ , c(names.d, names.d.subgroups)], bg21plus$pop)
#'     y
#'     x
#'     }
#'
NULL
