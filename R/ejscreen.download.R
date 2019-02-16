#' @title Download the EJSCREEN Dataset for use in R
#' @description Download EJSCREEN dataset from FTP site, and import to R as data.table,
#'   renaming fields with friendly colnames, optionally adding a flag field.
#' @details Not tested.
#' @param folder Optional path to folder (directory) where the file will be downloaded and unzipped. Default is current working directory.
#' @param yr Default was 2017 as of 6/2018. Optional numeric year version such as 2015, 2016, 2017.
#' @param ftpurl Optional. Default is ftp://newftp.epa.gov/EJSCREEN/yyyy (yyyy=year version=yr) for where to find the zipped data.
#' @param zipname Optional. Default for the name of the zip file of data depends on yr. Empty for yr=2017. For yr=2015, EJSCREEN_20150505.csv.zip
#' @param csvname Optional. Default for the name of the csv file of data depends on yr. For yr=2017, EJSCREEN_2017_USPR_Public.csv and for yr=2015, EJSCREEN_20150505.csv
#' @param addflag Optional. Default is FALSE. If TRUE, it adds a field called flagged, which is TRUE if 1 or more of the EJ Indexes is at/above the cutoff US percentile.
#' @param cutoff Optional. Default is 80. See addflag parameter.
#' @param or.tied Optional. Default is TRUE, meaning at or above the cutoff. FALSE means above only. See addflag parameter.
#' @return Returns a data.frame with ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, text for popups. Output has one row per block group.
#' @source See \url{http://www.epa.gov/ejscreen} for more information, and see \url{http://www.epa.gov/ejscreen/download-ejscreen-data} or \url{ftp://newftp.epa.gov/EJSCREEN} for raw data.
#' @seealso \code{\link{ejscreen.create}}
#' @export
ejscreen.download <-
  function(folder = getwd(),
           yr = 2017,
           ftpurl,
           zipname,
           csvname,
           addflag = FALSE,
           cutoff = 80,
           or.tied = TRUE) {
    # #  @ e x a m p l e s
    # #  \dontrun{
    # #  bg <- ejscreen.download(folder='~', addflag=TRUE)
    # #  names(bg) <- change.fieldnames.ejscreen.csv(names(bg))
    # #  }
    
    ######################################################################################## #
    # A script to get the 2015, 2016, 2017 etc. version of EJSCREEN dataset into memory, using the friendly Rfieldnames
    ######################################################################################## #
    
    # Note: if already exists as .RData locally, could just do load("bg 2015-04-22 Rnames plus subgroups.RData")
    
    # Prepare to obtain the zip or just csv file from the FTP site ------------
    
    ############################# #
    # Prepare to obtain the zip or just csv file from the FTP site, based on which yr
    # (takes a few minutes to download if you do it this way - you could do it manually using an FTP client instead)
    ############################# #
    yr <- as.numeric(yr) # in case entered as character
    calendaryear <-
      as.numeric(format(Sys.time(), "%Y"))  # as.numeric(substr(date(), 21, 24)) # So far the version year has been same as? prior to current actual year? 2017 version was available in 2017?
    if (yr == calendaryear)
      warning('This version might not be available yet.')
    if (!(yr %in% 2015:calendaryear)) {
      stop('Invalid year')
    }
    
    ftpurl <-
      paste('ftp://newftp.epa.gov/EJSCREEN/', yr, sep = '') # coerces yr to character. Hopefully will keep this format
    
    zipcsvnames <- function(yr) {
      if (yr == 2015) {
        zipname <- 'EJSCREEN_20150505.csv.zip'
        csvname <- 'EJSCREEN_20150505.csv'
      }
      if (yr == 2016) {
        zipname <- 'EJSCREEN_V3_USPR_090216_CSV.zip'
        csvname <- 'EJSCREEN_V3_USPR_090216_CSV'
      }
      if (yr == 2017) {
        zipname <- '' # not zipped on ftp site for this year
        csvname <- 'EJSCREEN_2017_USPR_Public.csv'
      }
      if (yr > 2017) {
        zipname <- ''
        csvname <-
          paste('EJSCREEN_', yr, '_USPR_Public.csv', sep = '') # hopefully will keep this format
      }
      return(c(zipname, csvname))
    }
    x <- zipcsvnames(yr)
    zipname <- x[1]
    csvname <- x[2]
    
    setwd(folder)
    if (zipname == '') {
      myfilename <- csvname
    } else {
      myfilename <- zipname
    }
    mypathfile <- file.path(ftpurl, myfilename)
    
    # Download, Unzip, Read  ----------------------------------------------
    
    ############################# #
    # DOWNLOAD from the FTP site
    ############################# #
    cat('Attempting to download dataset from ',
        mypathfile,
        'and saving in',
        folder,
        ' \n')
    cat('This normally takes a few minutes. \n')
    x <- download.file(mypathfile, myfilename)
    if (x != 0) {
      stop('Download failed.')
    }
    if (!(file.exists(myfilename))) {
      stop('download attempted but saved zip file not found locally')
    }
    
    ############################# #
    # UNZIP IF WAS ZIPPED
    ############################# #
    if (zipname == '') {
      cat('\n')
    } else {
      cat('Attempting to unzip dataset \n')
      unzip(zipname)
    }
    
    ############################# #
    # Read the csv file into R
    ############################# #
    # Possibly even faster via readr package readr::read_csv() which I think can download and read all in one step
    # read.csv takes a couple of minutes, and much faster if you use data.table::fread()
    #   Read 217739 rows and 391 (of 391) columns from 0.653 GB file in 00:00:46  # fast via fread()
    # bg <- read.csv('EJSCREEN_20150505.csv', nrows = 220000) # as.is = TRUE, # too slow
    if (!(file.exists(csvname))) {
      stop('csv file should have been downloaded but not found in folder where expected')
    }
    cat('Attempting to import csv dataset to R \n')
    bg <- data.table::fread(csvname)
    bg <- data.frame(bg)
    
    
    ############################# #
    # sort by FIPS
    ############################# #
    bg <- bg[order(bg$FIPS),]
    
    
    # Add a flag column ---------------------------------------------------------
    
    ############################# #
    # ADD FLAG COLUMN - FLAG ROWS WHERE AT LEAST ONE OF A FEW INDICATORS IS ABOVE GIVEN CUTOFF THRESHOLD
    ############################# #
    if (addflag) {
      data(names.ejvars)
      # dput(names.ej.pctile)
      # c("pctile.EJ.DISPARITY.pm.eo",
      #   "pctile.EJ.DISPARITY.o3.eo",
      #   "pctile.EJ.DISPARITY.cancer.eo",
      #   "pctile.EJ.DISPARITY.neuro.eo",
      #   "pctile.EJ.DISPARITY.resp.eo",
      #   "pctile.EJ.DISPARITY.dpm.eo",
      #   "pctile.EJ.DISPARITY.pctpre1960.eo",
      #   "pctile.EJ.DISPARITY.traffic.score.eo",
      #   "pctile.EJ.DISPARITY.proximity.npl.eo",
      #   "pctile.EJ.DISPARITY.proximity.rmp.eo",
      #   "pctile.EJ.DISPARITY.proximity.tsdf.eo",
      #   "pctile.EJ.DISPARITY.proximity.npdes.eo")
      #
      # See which block groups are flagged as having one or more of 12 EJ indexes >= 80th US pctile
      # Store result as x, which is a logical vector as long as the list of block groups:
      x <-
        ejanalysis::flagged(bg[, names.ej.pctile], cutoff = cutoff, or.tied = or.tied)
      bg$flagged <- x
      # cat(round(100* sum(x)/length(x) , 1), ' percent of block groups are flagged as having 1+ of the EJ Indexes at/above the 80th percentile of US population \n')
      # 31% of US block groups
      # NOTE: function called "ejanalysis::flagged()" and data(names.ej.pctile), which stores field names
      #  ARE NOW attached via Depends in DESCRIPTION file
      # if (!require('devtools')) install.packages('devtools')
      # if (!require('analyze.stuff')) devtools::install_github("ejanalysis/analyze.stuff"); library(analyze.stuff)
      # if (!require('ejanalysis')) devtools::install_github("ejanalysis/ejanalysis"); library(ejanalysis)
    }
    
    ############################# #
    cat('Done \n\n')
    ############################# #
    return(bg)
  }
