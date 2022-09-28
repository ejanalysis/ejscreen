#' @name bg22DemographicSubgroups2016to2020
#' @docType data
#' @title Demographic subgroups of race/ethnicity by block group
#'
#' @description  bg22DemographicSubgroups provides subgroups that are
#'   the ones making up EJScreen's % people of color (aka % minority)
#'   such as Hispanic or Latino, Non-Hispanic Black Alone, etc.
#' @details
#' \preformatted{
#'   This dataset is a companion to the block group data from EJScreen.
#'   EJScreen and therefore bg22 lack table B03002 (race ethnicity) so that table
#'   is obtained as bg22DemographicSubgroups
#'  
#'  This also includes race/ethnicity data for Puerto Rico, but not GU/AS/VI/MP.
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
#'     # see  ejscreen/inst/SCRIPT_create_bgDemog_ejscreen2.1_andtracts.R 
#'     # the SCRIPT for how this was created
#'     # and  ejscreen/inst/SCRIPT_ADD_PUERTORICO_DEMOG_SUBGROUPS.R for the PR part.
#'     
#'     # DOWNLOADED ACS TABLE WITH RACE ETHNICITY BY BLOCK GROUP
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
#'   }
#'     
NULL
