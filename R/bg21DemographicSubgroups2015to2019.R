#' @name bg21DemographicSubgroups2015to2019
#' @docType data
#' @title now part of bg21plus but was Demographic subgroups of race/ethnicity by block group (ACS2015-2019 for bg21 and late 2021v of EJSCREEN)
#' @description This 2015-2019 dataset fits with the \link{bg21} data,
#'   which is called EJScreen 2.0, released in Feb 2022, based on ACS 2015-2019.
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
#'  EJScreen 2.1 was released circa August 2022.
#'    EJScreen 2.1 uses ACS2020, which is from 2016-2020 (released March 17 2022, delayed from Dec 2021).
#'    It was to be called the 2022 version of EJScreen, and
#'    here is called bg22.
#'
#'  EJScreen 2.0 was released by EPA 2022-02-18 (delayed from mid/late 2021).
#'    EJScreen 2.0 used ACS2019, which is from 2015-2019 (released Dec 2020).
#'    It was to be called the 2021 version, and here is called bg21 as it was to be a late 2021 version.
#'
#'   This data was created by downloading and calculating
#'   DETAILED RACE ETHNICITY SUBGROUP VARIABLES THAT ARE NOT IN EJSCREEN
#'   INCLUDING percent Hispanic, etc. (the subgroups within "minority")
#'   for use in EJ analysis.
#'  }
#'  \cr
#'   This will give a quick look at some key stats: \cr
#'     # round(data.frame(cbind(  \cr
#'     # subgroups=unlist(ustotals(bg21DemographicSubgroups2015to2019)), \cr
#'     # maingroups = unlist(ustotals(subset(bg21, bg21$ST !='PR')))  \cr
#'     # ),2) \cr
#'  \cr
#'   This can be MERGED WITH the EJSCREEN DATASET (see below).\cr
#'
#'   This may also be addressed in documentation help page for \link{bg21}
#' \preformatted{
#'     ######################################################################################
#'     # How to merge demographic subgroup info into the basic EJSCREEN bg21 dataset:
#'     ######################################################################################
#'
#'  }
#'     d <- bg21DemographicSubgroups2015to2019  \cr
#'     d <- subset.data.frame(x = d, subset = !(names(d) %in% c('pop', 'mins', 'pctmin')) )  \cr
#'     bg21plus <- merge(bg21, d, by = 'FIPS', all.x = TRUE)  \cr
#'     rm(d)  \cr
#'
#'     # save(bg21plus, file = 'bg21plus EJSCREEN dataset plus race ethnic subgroups.rdata')  \cr
#'     # write.csv(bg21plus, file = 'bg21plus EJSCREEN dataset plus race ethnic subgroups.csv') \cr
#'     ########################################## \cr
#'  \cr
#'     # Note that only Puerto Rico is missing from this ACS dataset. \cr
#'     # while bg21 has PR, so when merged, the PR rows will be NA for pcthisp, etc. \cr
#'     # setdiff(substr(bg21$FIPS, 1,2), substr(bg21DemographicSubgroups2015to2019$FIPS,1,2)) \cr
#'     #   "72" which is the FIPS code for Puerto Rico. \cr
#'  \cr
#'         subset.data.frame(x = names(bg21plus), subset =  !(names(bg21plus) %in% names(bg21)) )  \cr
#'    \cr
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
#'   # "hisp"            "nhwa"            "nhba"            "nhaiana"         "nhaa"            "nhnhpia"
#'   # "nhotheralone"    "nhmulti"         "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
#'   # "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone" "pctnhmulti"
#'
#'   # setwd('~/../Downloads/acs1519')
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
#'   # subset.data.frame(x = ejscreenformulas, subset = ejscreenformulas$Rfieldname %in% names(bgACS), select = c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula'))
#'   bg21DemographicSubgroups2015to2019 <- bgACS
#'   save(bg21DemographicSubgroups2015to2019,
#'     file = '~/Documents/R PACKAGES/ejscreen/data/bg21DemographicSubgroups2015to2019.rdata')
#'
#'     ######################################################################################
#'     # SUMMARY STATS ON DISPARITY BY GROUP BY ENVT ISSUE
#'     #  See help for RR.table() in ejanalysis package
#'     # (This is very slow right now)
#'     Ratios <- ejanalysis::RR.table(bg21plus, Enames = names.e, Dnames = c(names.d, names.d.subgroups), popcolname = 'pop', digits = 2)
#'     MeansByGroup_and_Ratios <- ejanalysis::RR.means(subset(bg21plus, select=names.e), subset(bg21plus, select = c(names.d, names.d.subgroups)), bg21plus$pop)
#'     MeansByGroup_and_Ratios
#'     Ratios
#'     }
#'
NULL
