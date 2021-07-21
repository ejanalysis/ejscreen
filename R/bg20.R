#' @name bg20
#' @docType data
#' @title The 2020 version of EJSCREEN data (based on ACS 2014-2018) plus lat lon, countynames, etc., minus some nonessential fields
#' @description
#'   Note the 2020 version of EJSCREEN (released January 2021 rather than late 2020)
#'     actually uses ACS2018, which is from 2014-2018 (released by Census late 2019).
#'
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually uses ACS2017, which is from 2013-2017 (released by Census late 2018).
#'
#'   This data set is the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package,
#'   Columns dropped from ftp version, not included here:
#'     - text fields about percentiles, used as popup text on maps
#'     - any obsolete columns related to the 2 alternative versions of an EJ Index phased out (except VNI.eo and VSI.eo are kept)
#'     - any obsolete columns related to using 6 instead of 2 demographic variables (svi6)
#'   Columns added here, not in ftp version:
#'     - lat lon for bg centroids
#'     - state name and state abbrev, county name, and FIPS for tract, county, state
#'     - flag indicating if any of EJ indexes above 80th percentile in US
#'   Detailed info on demog subgroups is in \link{bgDemographicSubgroups2014to2018} and \link{bgDemographicSubgroups2015to2019}
#'
#' @details
#' Note that unlike bgDemographicSubgroups2014to2018,
#'    bg20 has PR
#'    and has some rows with NA for state fips not yet fixed
#'    and has some rows with lowinc or povknownratio NA not fixed (but pctlowinc is OK)...
#'    rows all were kept --
#'    #
#'    # HOW THE 13 PROBLEM ROWS WERE FIXED IN  bg18, bg19, bg20:
#'    #
#'    Initially a handful of rows that had NA values in FIPS.ST, other geo fields,
#'    in AK and SD, probably because those
#'    were not in the old list of valid county FIPS numbers that has been used by ejanalysis::get.county.info() used by clean.fips()
#'    and those block group FIPS are also not found in the Census 2010 (block group) FIPS in proxistat::bg.pts$FIPS
#'    Those 13 rows were manually fixed for bg20 (so now they have NA just for lat, lon, and countyname).
#'    The fields that did not get created right for the 13 were:
#'    y <- bg18
#'    newfips <- y$FIPS[is.na(y$ST)]
#'    bad <- which(is.na(y$ST))
#'    nastuff <- analyze.stuff::na.check(y[bad,])[ , c('count', 'na')]; nastuff[order(nastuff$na),]
#'    ###  FIPS.TRACT, FIPS.COUNTY ,FIPS.ST, ST, statename, REGION, countyname , lat  , lon
#'
#'    ######3 *** TO BE FIXED... CONTINUED...
#'
#'    y[bad] <- bg19[bad,]
#'    y['FIPS.TRACT'] <- substr(y$FIPS,1,11)
#'    y['FIPS.COUNTY'] <- substr(y$FIPS,1,5)
#'    y['FIPS.ST'] <- substr(y$FIPS,1,2)
#'    y['ST'] <- ejanalysis::get.state.info(substr(y$FIPS,1,2))$ST
#'    y['statename'] <- ejanalysis::get.state.info(substr(y$FIPS,1,2))$statename
#'    y['REGION'] <- ejanalysis::get.state.info(substr(y$FIPS,1,2))$REGION

#'
#'   Lookup tables are not yet included here: lookup tables of percentiles for USA, Regions, States are in the gdb file on EJSCREEN FTP site.
#'   For that information, see ejscreen::lookupUSA, lookupRegions, lookupStates, and ejscreen::ejscreen.lookuptables
#'
#'   Definitions of column names here vs in the gdb or csv on the FTP site files
#'   are in data(ejscreenformulas)
#'   and also in a file called EJSCREEN_columns_explained.csv
#'   in the inst folder of the ejscreen package.
#'   Technical documentation is at \url{https://www.epa.gov/ejscreen}
#'
#'   The data was created for this package as follows: \cr\cr
#'     \code{require(ejscreen); require(ACSdownload)} \cr
#'     \code{require(proxistat) # for adding the lat lon of each block group }\cr
#'     \code{require(analyze.stuff); require(ejanalysis); require(readr)} \cr
#'      \cr
#'   \code{ # DOWNLOADED AND UNZIPPED  }\cr\cr
#'   \cr 2020 version of EJSCREEN downloaded 2020-01-27 from public FTP site
#'   \cr as csv format (zipped)
#'   \cr then unzipped to csv file
#'   \cr
#'   \code{#  bg <- ejscreen.download(folder = getwd(), justreadname = 'EJSCREEN_2020_USPR.csv', addflag = TRUE)} \cr\cr
#'   # Starts by reading in 141 columns from csv\cr
#'   # and \link{ejscreen.download} renames fields, drops an ID field, \cr
#'   # and adds fields called FIPS.TRACT, FIPS.COUNTY, FIPS.ST, countyname, and (optionally) flagged. \cr\cr
#'   \code{bg <- bg[ , !grepl(pattern = 'pctile\\\\.text', x = names(bg))]} \cr
#'   \code{bg <- bg[ , names(bg) != 'Shape_Length'] } \cr
#'
#'   # Then added lat, lon fields for block group centroids, via \link[proxistat]{bg.pts} from proxistat package:\cr
#'   \code{bg <- merge(bg, proxistat::bg.pts[ , c('FIPS', 'lat')], by.x = 'FIPS', by.y = 'FIPS', all.x = TRUE, all.y = FALSE)} \cr
#'   \code{bg <- merge(bg, proxistat::bg.pts[ , c('FIPS', 'lon')], by.x = 'FIPS', by.y = 'FIPS', all.x = TRUE, all.y = FALSE)} \cr\cr
#'   \code{plot(bg$lon[bg$lon < -50], bg$lat[bg$lon < -50], pch = '.')} \cr\cr
#'   # \code{sum(is.na(bg$FIPS.ST)) # 13 are NA} \cr
#'
#'   # THEN USE A NAME SPECIFIC TO THE YEAR: \cr
#'   \code{bg20 <- bg; rm(bg)} \cr
#'   \code{save(bg20, file = 'bg20.rdata')} \cr \cr
#' @concept datasets
#' @format data.frame with 220,333 rows (block groups) and 118 columns in bg20
NULL
