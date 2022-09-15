#' @name bg22DemographicSubgroups2016to2020
#' @docType data
#' @title Demographic subgroups of race/ethnicity by block group
#'
#' @description  bg22DemographicSubgroups provides subgroups that are
#'   the ones making up EJScreen's % people of color (aka % minority)
#'   such as Hispanic or Latino, Non-Hispanic Black Alone, etc.
#' @details
#' \preformatted{
#'   This dataset is a companion to the block grroup data from EJScreen.
#'   EJScreen and therefore bg22 lack table B03002 (race ethnicity) so that table
#'   is obtained as bg22DemographicSubgroups
#'
#'  Note: As of 9/12/22 this also includes race/ethnicity data for Puerto Rico.
#'
#'    EJScreen 2.1 uses ACS2020, which is from 2016-2020 (released March 17 2022, delayed from Dec 2021).
#'    It was to be called the 2022 version of EJScreen, and
#'    here is called bg22.
#'
#'  EJScreen 2.0 was released by EPA 2022-02-18 (delayed from mid/late 2021).
#'    EJScreen 2.0 used ACS2019, which is from 2015-2019 (released Dec 2020).
#'    It was to be called the 2021 version, and here is called bg21 as it was to be a late 2021 version.
#'    }
#'  \preformatted{
#'   bg22DemographicSubgroups was created by downloading and calculating
#'   RACE ETHNICITY SUBGROUP VARIABLES THAT ARE NOT IN EJSCREEN
#'   (the subgroups within "minority" or "people of color").
#'   This is from Census Table B03002, and includes percent Hispanic,
#'   percent Non-Hispanic Black Alone (not multirace), etc.
#'   Race ethnicity groups are defined by Census Bureau. They are
#'   mutually exclusive (no overlaps between groups,
#'   so a person is always in only one of these groups)
#'   so they add up to the total population count or percent.
#'   Block group resolution for USA.
#'   From Census ACS 5 year summary file.
#'  }
#'  \cr
#'   This will give a quick look at some key stats: \cr
#'     # round(data.frame(cbind(  \cr
#'     # subgroups=unlist(ustotals(bg22DemographicSubgroups2016to2020)), \cr
#'     # maingroups = unlist(ustotals(subset(bg22, bg22$ST !='PR')))  \cr
#'     # ),2) \cr
#'  \cr
#'
#'   \preformatted{
#'
#'   ######################################################################################
#'   How dataset was created:
#'   ######################################################################################
#'
#'     # DOWNLOAD ACS TABLE WITH RACE ETHNICITY BY BLOCK GROUP
#'     # AND CREATE PERCENT VARIABLES LIKE PERCENT HISPANIC, ETC.
#'
#'     # These are created: (count and percent hispanic or latino, nonhispanic white alone i.e. single race,
#'   # nonhispanic black or african american alone, Not Hispanic or Latino American Indian and Alaska Native alone,
#'   # Not Hispanic or Latino Native Hawaiian and Other Pacific Islander alone,
#'   # and nh some other race alone, and nh two or more races):
#'
#'   # "hisp"            "nhwa"            "nhba"            "nhaiana"         "nhaa"            "nhnhpia"
#'   # "nhotheralone"    "nhmulti"         "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
#'   # "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone" "pctnhmulti"
#'
#'   # See in this package inst folder, the SCRIPT for how this was created.
#'   }
#'   \preformatted{
#'     ######################################################################################
#'     # How to add Puerto Rico demographic subgroup info:
#'     ######################################################################################
#'
#'     # For all block groups in US other than in PR,
#'     #  bg22DemographicSubgroups got B03002 using the script
#'     # but that did not include PR. Puerto Rico was missing if using ACSDownload package code.
#'     #   setdiff(substr(bg22$FIPS, 1,2), substr(bg22DemographicSubgroups2016to2020$FIPS,1,2))
#'     #   # "72" which is the FIPS code for Puerto Rico.
#'
#'     # PR table B03002 from ACS2016-2020 block groups was obtained from
#'     # browseURL('https://data.census.gov/cedsci/table?g=0100000US_0400000US72%241500000&y=2020&tid=ACSDT5Y2020.B03002')
#'
#'     # Get Puerto Rico table B03002
#'     prsub <- read.csv('')
#'     # rename headers
#'     # calculated variables
#'     # etc.
#'
#'     # Merge prsub into bg22DemographicSubgroups
#'     bg22DemographicSubgroups <- merge(bg22DemographicSubgroups, prsub, by='FIPS', all=TRUE)
#'     # check it
#'   }
#'   \preformatted{
#'     ######################################################################################
#'     # How to merge demographic subgroup info into the basic EJSCREEN bg dataset:
#'     ######################################################################################
#'
#'     d <- bg22DemographicSubgroups2016to2020
#'     d <- subset.data.frame(x = d, subset = !(names(d) %in% c('pop', 'mins', 'pctmin')) )
#'
#'     # Once bg22DemographicSubgroups has PR table B03002, merge that into complete dataset:
#'
#'     bg22plus <- merge(bg22, d, by = 'FIPS', all.x = TRUE)
#'      usethis::use_data(bg22plus)
#'     ## save(bg22plus, file = 'bg22plus EJSCREEN dataset plus race ethnic subgroups.rdata')
#'     ## write.csv(bg22plus, file = 'bg22plus EJSCREEN dataset plus race ethnic subgroups.csv')
#'     ##########################################
#'
#'         subset.data.frame(x = names(bg22plus), subset =  !(names(bg22plus) %in% names(bg22)) )
#'     }
#'
NULL
