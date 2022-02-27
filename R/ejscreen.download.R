#' @title Download the EJSCREEN Dataset csv for use in R and rename variables
#' @description Download EJSCREEN dataset from FTP site, unzip if necessary,
#'   import to R as data.table,
#'   renaming fields with friendly colnames,
#'   optionally adding a flag field (see parameter called \code{addflag}).
#'   Note that since 2020v, State percentiles are also available in a separate zipped csv.
#' @details Not fully tested. \cr
#'   \preformatted{
#'   Each version of EJSCREEN uses updated environmental data and updated 5-year summary file estimates from the American Community Survey (ACS).
#'
#'   The 2021 version of EJSCREEN, likely to be released in late 2021, (which will be avail as data in \code{ejscreen::bg21})
#'     is based on 2015-2019 ACS (Census calls it the 2019 5-year data release, but released it in Dec 2020).
#'     \url{https://www.census.gov/programs-surveys/acs/news/data-releases/2019/release-schedule.html}
#'   Note the 2020 version of EJSCREEN (confusingly released early/mid 2021 not late 2020)
#'     actually uses ACS2018, which is from 2014-2018 (released late 2019).
#'     It is avail as \link{bg20}
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'   Note the 2018 version of EJSCREEN (released late 2018)
#'     actually uses ACS2016, which is from 2012-2016 (released late 2017).
#'   The 2015 version of EJSCREEN, released in mid 2015, was based on 2008-2012 ACS data, and was the first public version available for download.
#'
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
#'   }
#' @param folder Optional path to folder (directory) where the file will be downloaded and unzipped. Default is current working directory.
#' @param yr Default is latest available year found as a folder on the FTP site.
#'   Optional numeric year designating EJSCREEN version such as 2015, 2016, 2017, 2018, 2019, 2020, etc.
#' @param ftpurlbase Optional. where to find the zipped data.
#' @param addflag Optional. Default is FALSE. If TRUE, it adds a field called flagged, which is TRUE if 1 or more of the EJ Indexes is at/above the cutoff US percentile.
#' @param cutoff Optional. Default is 80. See addflag parameter.
#' @param or.tied Optional. Default is TRUE, meaning at or above the cutoff. FALSE means above only. See addflag parameter.
#' @param justreadname Optional character file name - if specified, skips downloading and just tries to read previously-downloaded csv found in \code{folder}.
#' @param statepctiles Optional, default FALSE. If TRUE, gets State Percentiles csv instead of the USPR file.
#' @return Returns a data.frame with ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, text for popups. Output has one row per block group, sorted by FIPS.
#' @source See \url{http://www.epa.gov/ejscreen} for more information, and see \url{http://www.epa.gov/ejscreen/download-ejscreen-data}
#' @seealso \code{\link{ejscreen.create}}  \code{\link{change.fieldnames.ejscreen.csv}}
#' @examples
#'    # bg <- ejscreen.download('~')
#'    ## bg <- ejscreen.download('~',
#'    #  justreadname = 'EJSCREEN_Full_USPR_2020.csv')
#'    # bg <- bg[ , !grepl(pattern = 'pctile\\.text', x = names(bg))]
#'    # bg <- bg[ , !grepl(pattern = 'svi6', x = names(bg))]
#'    # setwd('~')
#'    # save(bg, file = 'bgYEAR20XX.rdata')
#' @export
ejscreen.download <-
  function(folder = getwd(),
           yr = NULL,
           ftpurlbase = 'https://gaftp.epa.gov/EJSCREEN/',
           # ftpurlbase = 'ftp://newftp.epa.gov/EJSCREEN/', # was the older URL, until about 2020
           justreadname = NULL,
           statepctiles = FALSE,
           addflag = FALSE,
           cutoff = 80,
           or.tied = TRUE) {

    ######################################################################################## #
    # A way to get the 2015, 2016, 2017, 2018, 2019, 2020, 2021, etc. version of EJSCREEN dataset into memory, using the friendly Rfieldnames
    ######################################################################################## #

    # Note: if already exists as .RData locally, could just do load("bg 2015-04-22 Rnames plus subgroups.RData")

# THIS PART SHOULD BE SPLIT OUT INTO ITS OWN FUNCTION - JUST FIND LATEST VERSION AND DOWNLOAD AND UNZIP, NO MODIFICATIONS

    # Prepare to obtain the zip or just csv file from the FTP site ------------

    ############################# #
    # Prepare to obtain the zip or just csv file from the FTP site, based on which yr
    # (takes a few minutes to download if you do it this way - you could do it manually using an FTP client instead)
    ############################# #
    if (is.null(justreadname)) {

      # Check ftp site for largest year of any folder, any use that as the year and folder

      latestavailableyear <- function(mypath='https://gaftp.epa.gov/EJSCREEN/') {
        calendaryear <- as.numeric(format(Sys.time(), "%Y")) # just says, what year is it?
        yrschecked <- 2015:calendaryear # 2015 was the earliest, and the current calendar year is latest version possibly available
        latestyr <- yrschecked[max(which(sapply(paste(mypath, yrschecked, '/', sep = ''), RCurl::url.exists)))]
        cat('\n', paste(mypath, yrschecked, '/', '\n', sep = ''), '\n')
        if (is.na(latestyr)) {stop('problem - none of those URLs were found by RCurl::url.exists function')}
        return(latestyr)
      }
      
      if (!exists('yr') | is.null(yr) ) {
        yr <- latestavailableyear(ftpurlbase)
      } else {
        yr <- as.numeric(yr) # in case entered as character, later want it as number
        if (!RCurl::url.exists(paste(ftpurlbase, yr, '/', sep = ''))) {
          calendaryear <- as.numeric(format(Sys.time(), "%Y"))
          # if (!(yr %in% 2015:calendaryear)) {stop('Invalid year')}
          if (yr == calendaryear) warning('This version might not be available yet. The 20xx version of EJSCREEN has typically been released around Sept/Oct of that year 20xx.')
          stop('folder for that year not found on FTP site')
          }
      }

      justftpurl <- function(yr) {
        return(paste(ftpurlbase, yr, sep = '')) # coerces yr to character. Hopefully will keep this format
      }
      ftpurl <- justftpurl(yr)

      zipcsvnames <- function(yr) {
          zipnamestate <- '' # na for most years
          csvnamestate <- ''  # na for most years
        if (yr == 2015) {
          zipname <- 'EJSCREEN_20150505.csv.zip'
          csvname <- 'EJSCREEN_20150505.csv'
          warning('state percentiles not available for 2015 dataset')
        }
        if (yr == 2016) {
          zipname <- 'EJSCREEN_V3_USPR_090216_CSV.zip'
          csvname <- 'EJSCREEN_V3_USPR_090216_CSV' # no extension ?
          warning('state percentiles not available for 2016 dataset')
        }
        if (yr == 2017) {
          zipname <- '' # not zipped on ftp site for this year
          csvname <- 'EJSCREEN_2017_USPR_Public.csv'
          warning('state percentiles available only as gdb not csv for 2017 dataset')
        }
        if (yr == 2018) {
          zipname <- 'EJSCREEN_2018_USPR_csv.zip'
          csvname <- 'EJSCREEN_Full_USPR_2018.csv'
          zipnamestate <- 'EJSCREEN_2018_StatePctile_csv.zip'
          csvnamestate <- 'EJSCREEN_StatePctile_2018.csv'
        }
        if (yr == 2019) {
          zipname <- 'EJSCREEN_2019_USPR.csv.zip'
          csvname <- 'EJSCREEN_2019_USPR.csv'
          zipnamestate <- 'EJSCREEN_2019_StatePctile.csv.zip'
          csvnamestate <- 'EJSCREEN_2019_StatePctiles.csv'
        }
        if (yr == 2020) {
          zipname <- 'EJSCREEN_2020_USPR.csv.zip'   #
          csvname <- 'EJSCREEN_2020_USPR.csv'  #
          zipnamestate <- 'EJSCREEN_2020_StatePctile.csv.zip'
          csvnamestate <- 'EJSCREEN_2020_StatePctile.csv'
          # https://gaftp.epa.gov/EJSCREEN/2020/EJSCREEN_2020_USPR.csv.zip
          # https://gaftp.epa.gov/EJSCREEN/2020/EJSCREEN_2020_StatePctile.csv.zip
        }
        if (yr > 2020) {
          zipname <- paste('EJSCREEN_', yr, '_USPR.csv.zip', sep = '') # hopefully will keep this format
          csvname <- paste('EJSCREEN_', yr, '_USPR.csv', sep = '') # hopefully will keep this format
          zipnamestate <- paste('EJSCREEN_', yr, '_StatePctile.csv.zip', sep = '') # hopefully will keep this format
          csvnamestate <- paste('EJSCREEN_', yr, '_StatePctile.csv', sep = '') # hopefully will keep this format
        }
        return(c(zipname, csvname, zipnamestate, csvnamestate))
      }
      x <- zipcsvnames(yr)
      if (statepctiles) {
        zipname <- x[3]
        csvname <- x[4]
      } else {
        zipname <- x[1]
        csvname <- x[2]
      }

      #setwd(folder) # should not need this
      if (zipname == '') {
        myfilename <- csvname
      } else {
        myfilename <- zipname
      }

      # Download, Unzip, Read  ----------------------------------------------

      justdownload <- function(mypathfileRemote, mypathfileLocal) {
        ############################# #
        # DOWNLOAD from the FTP site
        ############################# #
        cat('Attempting to download dataset from ',
            mypathfileRemote,
            'and saving as',
            mypathfileLocal,
            ' \n')
        cat('This may take a few minutes. \n')
        x <- utils::download.file(url = mypathfileRemote, destfile = mypathfileLocal)
        if (x != 0) {
          stop('Download failed.')
        }
        if (!(file.exists(mypathfileLocal))) {
          stop('download attempted but saved zip file not found locally')
        }
        return(NULL)
      }

      justdownload(mypathfileRemote = file.path(ftpurl, myfilename), mypathfileLocal = file.path(folder, myfilename))

      ############################# #
      # UNZIP IF WAS ZIPPED---------
      ############################# #
      if (zipname == '') {
        cat('\n')
      } else {
        cat('Attempting to unzip dataset from', file.path(folder, myfilename), 'to', file.path(folder), '\n')
        utils::unzip(zipfile = file.path(folder, myfilename), exdir = folder)
      }
    }

    justreadcsv <- function(fullpathcsvname) {
      # fullpathcsvname here should include full path unless used setwd()
      ############################# #
      # Read the csv file into R           # this could be split out into a function that is exported for finer control of steps in ejscreen.download
      ############################# #
      # Possibly even faster via readr package readr::read_csv() which I think can download and read all in one step
      # read.csv takes a couple of minutes, and much faster if you use data.table::fread()
      #   Read 217739 rows and 391 (of 391) columns from 0.653 GB file in 00:00:46  # fast via fread()
      # bg <- read.csv('EJSCREEN_20150505.csv', nrows = 220000) # as.is = TRUE, # too slow
      if (!(file.exists(fullpathcsvname))) {
        print(fullpathcsvname)
        stop('csv file should have been downloaded but not found in folder where expected')
      }
      cat('Attempting to import csv dataset to R \n')
      #bg <- data.table::fread(fullpathcsvname)
      # Handle 'None' as NA values this way:
      bg <- readr::read_csv(file = fullpathcsvname, na = 'None') # should check if 2020+ versions still have None for NA
      bg <- data.frame(bg, stringsAsFactors = FALSE)
    }

    # fread had a PROBLEM that readr::read_csv fixes - Several 2017 columns have "None" as a value so the col is interpreted as character not numeric.
    # and ID column which is FIPS is interpreted as integer64 instead of character

    if (!missing(justreadname)) {csvname <- justreadname}
    bg <- justreadcsv(fullpathcsvname = file.path(folder, csvname))

    # change field names  -----------
    # -- rename the cols to preferred field names
    names(bg) <- change.fieldnames.ejscreen.csv(names(bg))

    # Add FIPS, countyname, statename, State etc --------
    # add the other FIPS components as individual columns
    bg <- ejanalysis::addFIPScomponents(bg)

    # Add a flag column if needed ---------------------------------------------------------
    #
    ############################# #
    # ADD FLAG COLUMN - FLAG ROWS WHERE AT LEAST ONE OF A FEW INDICATORS IS ABOVE GIVEN CUTOFF THRESHOLD
    ############################# #
    #
    ## See which block groups are flagged as having one or more of 12 EJ indexes >= 80th US pctile
    ## Store result as a logical vector as long as the list of block groups:

    if (addflag) {
      warning('The flagged field may not work for state percentiles file yet')
      bg$flagged <- ejanalysis::flagged(bg[, names.ej.pctile], cutoff = cutoff, or.tied = or.tied)
    }

    ############################# #
    # sort by FIPS ----------
    ############################# #
    bg <- bg[order(bg$FIPS), ]

    # to drop the popup text percentile info
    # bg <- bg[,!grepl('pctile.text', names(bg)) ]

    ############################# #
    cat('Done \n\n')
    ############################# #
    return(bg)
  }
