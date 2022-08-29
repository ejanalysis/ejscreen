#' @name bg21
#' @docType data
#' @title EJScreen 2.0 dataset (Feb 2022), plus additional variables, minus some nonessential fields
#' @description
#'   See bg21plus for more fields like demographic subgroups
#'  \preformatted{
#'
#'  *VINTAGE*
#'
#'  - EJScreen 2.1 was released by EPA in August 2022. It is called bg22 here.
#'    It uses ACS 2016-2020, which the Census Bureau released March 17, 2022 (delayed from Dec 2021).
#'
#'  - EJScreen 2.0 was released by EPA February 18, 2022. It was called bg21 here.
#'    It uses ACS 2015-2019, which the Census Bureau released December, 2020.
#'    (EJScreen 2.0 was called the "2021 version" and bg21 here
#'    because it would have been called the late 2021 version but was delayed).
#'
#'
#'   - This data set is the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package,
#'   Columns dropped from ftp version, not included here:
#'     - text fields about percentiles, used as popup text on maps
#'     - any obsolete columns related to the 2 alternative versions of an EJ Index phased out (except VNI.eo and VSI.eo are kept)
#'     - any obsolete columns related to using 6 instead of 2 demographic variables (svi6)
#'   Columns added here, not in ftp version:
#'     - lat lon for bg centroids
#'     - state name and state abbrev, county name, and FIPS for tract, county, state
#'     - flag indicating if any of EJ indexes above 80th percentile in US
#'
#'   Detailed info on demog subgroups is in \link{bg21DemographicSubgroups2015to2019}
#'  }
#' @details
#'
#'    This will give a quick look at some key stats:
#'    #round(data.frame(cbind(
#'    #  subgroups = unlist(ustotals(bg21DemographicSubgroups2015to2019)),
#'    #  maingroups = unlist(ustotals(bg21[ bg21$ST !='PR', ])))
#'    #  ), 2)
#'
#' Note that unlike bg21DemographicSubgroups2015to2019,
#'    bg21 has PR, and will need to add PR to ACS demog subgroup data
#'
#'   Lookup tables are not yet included here: lookup tables of percentiles for USA, Regions, States are on EJSCREEN FTP site.
#'   For that information, see ejscreen::lookupUSA, lookupRegions, lookupStates, and ejscreen::ejscreen.lookuptables
#'
#'   Definitions of column names here vs in the gdb or csv on the FTP site files
#'   are in data(ejscreenformulas)
#'   and also in a file called EJSCREEN_columns_explained.csv
#'   in the inst folder of the ejscreen package.
#'   Technical documentation is at \url{https://www.epa.gov/ejscreen}
#'
#' ############################################################################### #
#' ##  Notes on vintage: 2010 vs 2020 Census block boundaries and FIPS ####
#' #
#' # *** PROBLEM trying to use Census 2020 dataset before EJSCREEN adopts it:
#' # Not exactly right to use Census 2020 weights and lat/lon for buffering unless EJSCREEN does too.
#' # Many of the CENSUS 2020 GEOGRAPHIC boundaries and also a few FIPS
#' # do not match those in EJSCREEN through Jan 2022; same with EJSCREEN 2.0 released Feb 2022. bg20, bg21.
#' #
#' # Boundaries changed:
#' #   Census 2020 more accurately reflects where people now live,
#' #   and EPA FTP site EJScreen dataset uses latest FIPS and boundaries I think (e.g. as in 2015-2019 ACS)?
#' #   The FTP site "2021" dataset, EJScreen 2.0, using ACS 2015-2019, as in bg21,
#' #   has 11 blockgroups where FIPS is not in Census 2010 FIPS list, it appears.
#' #   The old boundaries of a bg and can differ from new ones.
#' #   Census 2010 vs 2020 boundaries are documented here:
#' #   https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html#blkgrp
#' #   https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html#t10t20
#' #
#' # FIPS changed in Alaska:
#' #   Small problem in part of Alaska where buffering and/or getting blockgroupstats
#' #   would fail using census 2020. EJScreen 2.0 as of March/April 2022 used Census 2010 not 2020 geographies.
#' #   ****  One Alaska county FIPS (containing 11 blockgroups) in EJSCREEN through March 2022,
#' #   is not in Census 2020: Valdez-Cordova Census Area, Alaska     bg20$FIPS.COUNTY == '02261'
#' #   population 9,301 per ACS 2014-2018
#' #   **** TWO NEW Alaska COUNTIES with NINE blockgroups with 1,533 blocks
#' #   population 9,719 per Census 2020
#' #   are in Census 2020  not in EJSCREEN through March 2022.
#' #   c("02063", "02066")
#' #  bg21$FIPS[is.na(bg21$ST)]
#' #   c("020630002001", "020630002002", "020630003001", "020630003002", "020630003003", "020630003004", "020630003005", "020660001001", "020660001002")
#' ############################################################################### #
#'
#'   *TO GET/CREATE THIS DATASET IN R FROM THE EPA FTP SITE VERSION*\cr\cr
#'
#'   # Download, unzip, read, modify, all in one function:
#'   #bg <- ejscreen.download(folder = getwd(), year = 2021)
#'
#'   *IF ALREADY DOWNLOADED AND UNZIPPED*\cr\cr
#'   \cr Latest version of EJSCREEN downloaded from public FTP site
#'   \cr as csv format (zipped)
#'   \cr then unzipped to csv file
#'   \cr
#'   \code{
#'   #  bg <- ejscreen.download(folder = getwd(), addflag = TRUE,   \cr
#'   #  justreadname = 'EJSCREEN_2021_USPR.csv' )} \cr\cr
#'
#'   \cr  or maybe should just do (instead of using ejscreen.download() to do this...)
#'     # EJSCREEN_2021_USPR <- as.data.frame(readr::read_csv('./ejscreen2.1 july2022/EJSCREEN_2021_USPR.csv'))
#'     bg <- as.data.frame(readr::read_csv('EJSCREEN_2021_USPR.csv'))
#'
#'     names(bg) <- ejscreen::change.fieldnames.ejscreen.csv(names(bg))
#'
#'     bg <- ejanalysis::addFIPScomponents(bg)
#'     # or
#'     ### bg$FIPS.TRACT <- substr(bg$FIPS, 1, 11) # assumes already has leading zeroes in FIPS
#'     ### bg$FIPS.COUNTY <- substr(bg$FIPS, 1, 5) # assumes already has leading zeroes in FIPS
#'     ### bg$FIPS.COUNTY <- substr(bg$FIPS, 1, 2) # assumes already has leading zeroes in FIPS
#'     ### etc. ### bg$countyname <-
#'
#'
#'   \cr
#'   #  \link{ejscreen.download} renames fields, drops an ID field, \cr
#'   # and adds fields called FIPS.TRACT, FIPS.COUNTY, FIPS.ST, countyname, and (optionally) flagged. \cr\cr
#'   \code{bg <- bg[ , !grepl(pattern = 'pctile\\\\.text', x = names(bg))]} \cr
#'   \code{bg <- bg[ , names(bg) != 'Shape_Length'] } \cr
#'
#'   # Then added lat, lon fields for block group centroids, via \link[proxistat]{bg.pts} from proxistat package:\cr
#'   # for 2010 boundaries that was like this:\cr
#'   \code{bg <- merge(bg, proxistat::bg.pts[ , c('FIPS', 'lat')], by.x = 'FIPS', by.y = 'FIPS', all.x = TRUE, all.y = FALSE)} \cr
#'   \code{bg <- merge(bg, proxistat::bg.pts[ , c('FIPS', 'lon')], by.x = 'FIPS', by.y = 'FIPS', all.x = TRUE, all.y = FALSE)} \cr\cr
#'   # for 2020 boundaries it is like this: \cr
#'   # ... ...
#'
#'   \code{plot(bg$lon[bg$lon < -50], bg$lat[bg$lon < -50], pch = '.')} \cr\cr
#'   # \code{sum(is.na(bg$FIPS.ST)) # check if any are NA} \cr
#'
#'   # THEN USE A NAME SPECIFIC TO THE YEAR: \cr
#'   \code{bg21 <- bg; rm(bg)} \cr
#'   \code{usethis::use_data(bg21) #  save(bg21, file = 'bg21.rdata')} \cr \cr
#' @concept datasets
#' @format data.frame with 220,333 ? rows (block groups) and 118 ? columns in bg21
NULL
