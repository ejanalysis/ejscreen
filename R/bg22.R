#' @name bg22
#' @docType data
#' @title blockgroup data from EPA's EJScreen dataset (including ACS 2016-2020)
#' @description
#'   
#'  \preformatted{
#'  This is the EPA EJScreen dataset version 2.1 with some additional columns added.
#'  See also the EJAMejscreendata and EJAM packages once available.
#'  
#'  Contents
#'  
#'   Columns are added for bg22 that are not in the EPA version on the FTP site:
#'     - lat lon for bg centroids
#'     - state name and state abbrev, county name, and FIPS for tract, county, state
#'     - demographic subgroups (percent Hispanic, etc.)
#'       Detailed info on demog subgroups was in \link{bg22DemographicSubgroups2016to2020}
#'   Column renamed to friendlier variable names than the ones on the FTP site.
#'   
#'  Vintage
#'
#'    - EJScreen 2.1 was released by EPA in October 2022. It is called bg22 here.
#'    It uses ACS 2016-2020, which the Census Bureau released March 17, 2022 (delayed from Dec 2021).
#'
#'    - EJScreen 2.0 was released by EPA February 18, 2022. It was called bg21 here.
#'    It used ACS 2015-2019, which the Census Bureau released December, 2020.
#'    (EJScreen 2.0 was called the "2021 version" and bg21 here
#'    because it would have been called the late 2021 version but was delayed).
#'    
#'  }
#'
#' @concept datasets
#' @format data.frame with 242335 rows (block groups) and over 150 columns
NULL
