#' @name bg20DemographicSubgroups2014to2018
#' @docType data
#' @title Demographic subgroups of race/ethnicity by block group (ACS2014-2018 for bg20 and 2020v of EJSCREEN)
#' @description This 2014-2018 data fits with the bg20 data
#'   which is be the 2020 version of EJSCREEN (actually released mid 2021).
#'   Percent Hispanic, percent Non-Hispanic Black Alone (not multirace), etc.
#'   Additional detail in demographic subgroups beyond demographic info
#'   that is in EJSCREEN dataset. Block group resolution for USA.
#'   From Census ACS 5 year summary file.
#'   Can be merged with EJSCREEN data for analysis of the subgroups.
#'   Race ethnicity groups are defined by Census Bureau. They are
#'   mutually exclusive (no overlaps between groups,
#'   so a person is always in only one of these groups)
#'   so they add up to the total population count or percent.
#' @details
#' \preformatted{
#'   This data was created by downloading and calculating
#'   DETAILED RACE ETHNICITY SUBGROUP VARIABLES THAT ARE NOT IN EJSCREEN
#'   INCLUDING % Hispanic, etc. (the subgroups within "minority")
#'   for use in EJ analysis.
#'   This can be MERGED WITH the EJSCREEN DATASET (see below).
#'   But note that unlike bg20DemographicSubgroups2014to2018,
#'    bg20 has PR
#'    and may also have some rows with NA for state fips not yet fixed.
#'
#'   This may also be addressed in documentation help page for bg19 or bg20 via ?bg20
#'
#'   The 2021 version of EJSCREEN, likely to be released in late 2021,
#'   (which will be avail as data in \code{ejscreen::bg21})
#'      and fits with \link{bg21DemographicSubgroups2015to2019}
#'      is based on 2015-2019 ACS (Census calls it the 2019 5-year data release, but released it in Dec 2020).
#'     \url{https://www.census.gov/programs-surveys/acs/news/data-releases/2019/release-schedule.html}
#'
#'   *** Note the 2020 version of EJSCREEN released late 2020 (actually Jan 2021)
#'   actually uses ACS2018 and fits with bg20DemographicSubgroups2014to2018, which is from 2014-2018 (released late 2019).
#'
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'    actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'   Note the 2018 version of EJSCREEN (released late 2018)
#'    actually uses ACS2016, which is from 2012-2016 (released late 2017).
#'
#'     ##########################################
#'     # How to merge demographic subgroup info into the basic EJSCREEN bg20 dataset:
#'     ###########################################
#'     d <- bg20DemographicSubgroups2014to2018
#'     d <- d[ , !(names(d) %in% c('pop', 'mins', 'pctmin'))]
#'     bg20plus <- merge(bg20, d, by = 'FIPS', all.x = TRUE)
#'     rm(d)
#'     # save(bg20plus, file = 'bg20plus EJSCREEN dataset plus race ethnic subgroups.rdata')
#'     # write.csv(bg20plus, file = 'bg20plus EJSCREEN dataset plus race ethnic subgroups.csv')
#'     ##########################################
#'     names(bg20plus)[!(names(bg20plus) %in% names(bg20))]
#'     [1] "hisp"            "nhwa"            "nhba"            "nhaiana"
#'     [5] "nhaa"            "nhnhpia"         "nhotheralone"    "nhmulti"
#'     [9] "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
#'     [13] "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone"
#'     [17] "pctnhmulti"
#'     ##########################################
#'     > dim(bg20)
#'     [1] 220333    118
#'     > dim(bg20plus)
#'     [1] 220333    135
#'
#'     # Note that only Puerto Rico is missing from this ACS dataset?
#'     # while bg20 should have PR
#'     # setdiff(substr(bg20$FIPS, 1,2), substr(bg20DemographicSubgroups2014to2018$FIPS,1,2))  # substr(bgACS$FIPS,1,2))
#'     # [1] "72" which is the FIPS code for Puerto Rico.
#'
#'
#'   How bg20DemographicSubgroups2014to2018 was created:
#'
#'     ######################################################################################
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
#'   # setwd('~/../Downloads/acs1418')
#'
#'   library(ejscreen); library(ejanalysis); library(analyze.stuff); require(ACSdownload)
#'   acsdata <- ejscreen.acsget(tables = 'B03002',
#'     end.year = 2018,
#'     base.path = '~/../Downloads/acs1418', sumlevel = 'both' )
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
#'     file = '~/R/ejscreen/data/bg20DemographicSubgroups2014to2018.rdata')
#'
#'     ######################################################################################
#'
#'     # SUMMARY STATS ON DISPARITY BY GROUP BY ENVT ISSUE
#'     #  See help for RR.table() in ejanalysis package
#'
#'     x <- ejanalysis::RR.table(bg20plus, Enames = names.e, Dnames = c(names.d, names.d.subgroups), popcolname = 'pop', digits = 2)
#'     y <- ejanalysis::RR.means(bg20plus[ , names.e], bg20plus[ , c(names.d, names.d.subgroups)], bg20plus$pop)
#'     y
#'     x
#'
#'     ###########################################
#'     }
#'
NULL
