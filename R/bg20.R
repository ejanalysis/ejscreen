#' @name bg20
#' @docType data
#' @title The 2020 version of EJSCREEN data (based on ACS 2014-2018) plus lat lon, countynames, etc., minus some nonessential fields
#' @description
#'  \preformatted{
#'   Note EJScreen 2.0 is the version released February 18, 2022.
#'     It uses ACS2019, which is from 2015-2019 (released by Census late 2020).
#'
#'   The latest version available until late February 18, 2022 was still the 2020 version.
#'
#'   Note the 2020 version of EJSCREEN (released mid 2021 rather than late 2020)
#'     actually used ACS2018, which is from 2014-2018 (released by Census late 2019).
#'
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually used ACS2017, which is from 2013-2017 (released by Census late 2018).
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
#'   Detailed info on demog subgroups is in \link{bg20DemographicSubgroups2014to2018} and \link{bg21DemographicSubgroups2015to2019}
#'}
#' @details
#'  \preformatted{
#'   This will give a quick look at some key stats:
#'    round(data.frame(cbind(
#'      subgroups=unlist(ustotals(bg20DemographicSubgroups2014to2018)),
#'      maingroups= unlist(ustotals(bg20[bg20$ST !='PR',])))
#'      ),2)
#'
#' Note that unlike bg20DemographicSubgroups2014to2018, bg20 has Puerto Rico (PR)
#'  > dim(bg20)
#'  [1] 220333    118
#'  > dim(bg20DemographicSubgroups2014to2018)
#'  [1] 217739     21
#'
#'   Lookup tables are not yet included here: lookup tables of percentiles for USA, Regions, States are in the gdb file on EJSCREEN FTP site.
#'   For that information, see ejscreen::lookupUSA, lookupRegions, lookupStates, and ejscreen::ejscreen.lookuptables
#'
#'   Definitions of column names here vs in the gdb or csv on the FTP site files
#'   are in data(ejscreenformulas)
#'   and also in a file called EJSCREEN_columns_explained.csv
#'   in the inst folder of the ejscreen package.
#'   Technical documentation is at \url{https://www.epa.gov/ejscreen}
#'   }
#'  \preformatted{
#'
#'        TO JUST READ THE EJSCREEN DATA ONCE DOWNLOADED FROM THE FTP SITE:
#'
#'        # may recode ejscreen.download to split out just the part that downloads, unzips, reads into R verbatim.
#'
#'        x <- readr::read_csv('~/Downloads/EJSCREEN_2020_USPR.csv',  na = 'None')
#'        x <- data.frame(x, stringsAsFactors = FALSE) # if you want a data.frame not a data.table
#'
#'        TO JUST RENAME COLUMNS TO FRIENDLY NAMES USED IN THIS PACKAGE:
#'
#'        names(x) <- ejscreen::change.fieldnames.ejscreen.csv(names(x))
#'
#'        TO JUST ADD SOME USEFUL COLUMNS (FIPS, countyname, statename, etc.):
#'
#'        x <- ejanalysis::addFIPScomponents(x)
#'
#'
#'   TO CREATE THIS bg20 DATASET FROM THE EJSCREEN DATA ON THE FTP SITE:
#'
#'   The key function is \link{ejscreen.download} which can downnload it, unzip, read, clean up, add fields, etc.
#'
#'     require(ejscreen); require(ACSdownload)
#'     require(proxistat) # for adding the lat lon of each block group
#'     require(analyze.stuff); require(ejanalysis); require(readr)
#'
#'    # DOWNLOADED AND UNZIPPED
#'    # 2020 version of EJSCREEN downloaded 2021-07 from public FTP site
#'    # as csv format (zipped)
#'    # then unzipped to csv file
#'
#'   # Starts by reading in 141 columns from csv
#'   # and \link{ejscreen.download} renames fields, drops an ID field,
#'   # and adds fields called FIPS.TRACT, FIPS.COUNTY, FIPS.ST, countyname, and (optionally) flagged.
#'
#'   bg <- ejscreen.download(folder = getwd(), justreadname = 'EJSCREEN_2020_USPR.csv', addflag = TRUE)
#'   bg <- bg[ , !grepl(pattern = 'pctile\\\\.text', x = names(bg))]
#'   bg <- bg[ , names(bg) != 'Shape_Length']
#'
#'   sum(is.na(bg$FIPS.ST)) # still 11 bg bad due to just
#'   # 1 county fips "02261" (Valdez-Cordova, AK) not in proxistat::countiesall$FIPS.COUNTY
#'   # which was from 2021 Gazeteer on Census website 8/2021.
#'
#'   # Then added lat, lon fields for block group centroids, via \link[proxistat]{bg.pts} from proxistat package:
#'   bg <- merge(bg, proxistat::bg.pts[ , c('FIPS', 'lat')], by.x = 'FIPS', by.y = 'FIPS', all.x = TRUE, all.y = FALSE)
#'
#'   plot(bg$lon[bg$lon < -50], bg$lat[bg$lon < -50], pch = '.')
#'
#'   # THEN USE A NAME SPECIFIC TO THE YEAR:
#'   # bg20 <- bg; rm(bg)
#'   # save(bg20, file = 'bg20.rdata')
#'    }
#'
#' @concept datasets
#' @format data.frame with 220,333 rows (block groups) and 118 columns in bg20
NULL
