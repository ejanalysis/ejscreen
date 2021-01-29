#' @title Download the EJSCREEN Dataset for use in R
#' @description Download EJSCREEN dataset from FTP site, unzip if necessary,
#'   import to R as data.table,
#'   renaming fields with friendly colnames, optionally adding a flag field (see parameter called \code{addflag}).
#' @details Not fully tested. \cr
#'   Each version of EJSCREEN uses updated environmental data and updated 5-year summary file estimates from the American Community Survey (ACS).\cr
#'   The 2015 version of EJSCREEN, released in mid 2015, was based on 2008-2012 ACS data, and was the first public version available for download. \cr
#'   The 2018 version of EJSCREEN, released in mid 2018, was based on 2012-2016 ACS 5-year summary file data that came out in Dec 2017.\cr
#'   The 2019 version of EJSCREEN, released in mid/late 2019, is based on 2013-2017 ACS 5-year data that came out in Dec 2018.\cr
#'   The 2014-2018 ACS 5-year data will be released starting December 19, 2019.
#' @param folder Optional path to folder (directory) where the file will be downloaded and unzipped. Default is current working directory.
#' @param yr Default is latest available year found as a folder on the FTP site. That was 2018 as of 7/20/19, but would be updated to 2019 upon release of that version in late 2019. Default was 2017 as of 6/2018.
#'   Optional numeric year designating EJSCREEN version such as 2015, 2016, 2017, 2018, 2019.
#' @param ftpurlbase Optional. Default is ftp://newftp.epa.gov/EJSCREEN/ and must have ending slash -- for where to find the zipped data.
#' @param addflag Optional. Default is FALSE. If TRUE, it adds a field called flagged, which is TRUE if 1 or more of the EJ Indexes is at/above the cutoff US percentile.
#' @param cutoff Optional. Default is 80. See addflag parameter.
#' @param or.tied Optional. Default is TRUE, meaning at or above the cutoff. FALSE means above only. See addflag parameter.
#' @param justreadname Optional character file name - if specified, skips downloading and just tries to read csv found in \code{folder}.
#' @return Returns a data.frame with ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, text for popups. Output has one row per block group.
#' @source See \url{http://www.epa.gov/ejscreen} for more information, and see \url{http://www.epa.gov/ejscreen/download-ejscreen-data} or \url{ftp://newftp.epa.gov/EJSCREEN} for raw data.
#' @seealso \code{\link{ejscreen.create}}
#' @examples
#'    # bg18 <- ejscreen.download('~/Dropbox/EJSCREEN/R Analysis/2018 dataset EJSCREEN/')
#'    ## bg18 <- ejscreen.download('~/Dropbox/EJSCREEN/R Analysis/2018 dataset EJSCREEN/',
#'    #  justreadname = 'EJSCREEN_Full_USPR_2018.csv')
#'    # bg18 <- bg18[ , !grepl(pattern = 'pctile\\.text', x = names(bg18))]
#'    # bg18 <- bg18[ , !grepl(pattern = 'svi6', x = names(bg18))]
#'    # setwd('~/Dropbox/EJSCREEN/R analysis/2018 dataset EJSCREEN')
#'    # save(bg18, file = 'bg18.rdata')
#' @export
ejscreen.download <-
  function(folder = getwd(),
           yr = NULL,
           ftpurlbase = 'ftp://newftp.epa.gov/EJSCREEN/',
           justreadname = NULL,
           addflag = FALSE,
           cutoff = 80,
           or.tied = TRUE) {
    # #  @ e x a m p l e s
    # #  \dontrun{
    # #  bg <- ejscreen.download(folder='~', addflag=TRUE)
    # #  names(bg) <- change.fieldnames.ejscreen.csv(names(bg))
    # #  }

    ######################################################################################## #
    # A script to get the 2015, 2016, 2017, 2018, 2019, etc. version of EJSCREEN dataset into memory, using the friendly Rfieldnames
    ######################################################################################## #

    # Note: if already exists as .RData locally, could just do load("bg 2015-04-22 Rnames plus subgroups.RData")

    # Prepare to obtain the zip or just csv file from the FTP site ------------

    ############################# #
    # Prepare to obtain the zip or just csv file from the FTP site, based on which yr
    # (takes a few minutes to download if you do it this way - you could do it manually using an FTP client instead)
    ############################# #
    if (missing(justreadname)) {

      # Check ftp site for largest year of any folder, any use that as the year and folder

      latestavailableyear <- function(mypath) {
        calendaryear <- as.numeric(format(Sys.time(), "%Y")) # just says, what year is it?
        yrschecked <- 2015:calendaryear # 2015 was the earliest, and the current calendar year is latest version possibly available
        return(yrschecked[max(which(sapply(paste(mypath, yrschecked, '/', sep = ''), RCurl::url.exists)))])
      }
      if (is.null(yr)) {
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
        if (yr == 2015) {
          zipname <- 'EJSCREEN_20150505.csv.zip'
          csvname <- 'EJSCREEN_20150505.csv'
        }
        if (yr == 2016) {
          zipname <- 'EJSCREEN_V3_USPR_090216_CSV.zip'
          csvname <- 'EJSCREEN_V3_USPR_090216_CSV' # no extension ?
        }
        if (yr == 2017) {
          zipname <- '' # not zipped on ftp site for this year
          csvname <- 'EJSCREEN_2017_USPR_Public.csv'
        }
        if (yr == 2018) {
          zipname <- 'EJSCREEN_2018_USPR_csv.zip'
          csvname <- 'EJSCREEN_Full_USPR_2018.csv'
        }
        if (yr == 2019) {
          zipname <- 'EJSCREEN_2019_USPR_csv.zip'   # tbd
          csvname <- 'EJSCREEN_Full_USPR_2019.csv'  # tbd
        }
        if (yr > 2019) {
          zipname <- paste('EJSCREEN_', yr, '_USPR_csv.zip', sep = '') # hopefully will keep this format
          csvname <- paste('EJSCREEN_', yr, '_USPR.csv', sep = '') # hopefully will keep this format
        }
        return(c(zipname, csvname))
      }
      x <- zipcsvnames(yr)
      zipname <- x[1]
      csvname <- x[2]

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
        cat('This normally takes a few minutes. \n')
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
        cat('Attempting to unzip dataset \n')
        utils::unzip(file.path(folder, myfilename))
      }
    }

    justreadcsv <- function(fullpathcsvname) {
      # fullpathcsvname here should include full path unless used setwd()
      ############################# #
      # Read the csv file into R
      ############################# #
      # Possibly even faster via readr package readr::read_csv() which I think can download and read all in one step
      # read.csv takes a couple of minutes, and much faster if you use data.table::fread()
      #   Read 217739 rows and 391 (of 391) columns from 0.653 GB file in 00:00:46  # fast via fread()
      # bg <- read.csv('EJSCREEN_20150505.csv', nrows = 220000) # as.is = TRUE, # too slow
      if (!(file.exists(fullpathcsvname))) {
        stop('csv file should have been downloaded but not found in folder where expected')
      }
      cat('Attempting to import csv dataset to R \n')
      #bg <- data.table::fread(fullpathcsvname)
      # Handle 'None' as NA values this way:
      bg <- readr::read_csv(file = fullpathcsvname, na = 'None')
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

