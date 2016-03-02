#' @title Download the EJSCREEN Dataset for use in R
#'
#' @description
#'   Download EJSCREEN dataset from FTP site, and import to R as data.table, optionally adding a flag field.
#' @details Designed for 2015 version only right now. Not tested.
#' @param folder Optional path to folder (directory) where the file will be downloaded and unzipped. Default is current working directory.
#' @param ftpurl Optional. Default is 'ftp://newftp.epa.gov/EJSCREEN' for where to find the zipped data.
#' @param zipname Optional. Default is 'EJSCREEN_20150505.csv.zip' for the name of the zip file of data.
#' @param csvname Optional. Default is 'EJSCREEN_20150505.csv' for the name of the csv file that was zipped.
#' @param addflag Optional. Default is FALSE. If TRUE, it adds a field called flagged, which is TRUE if 1 or more of the EJ Indexes is at/above the cutoff US percentile.
#' @param cutoff Optional. Default is 80. See addflag parameter.
#' @param or.tied Optional. Default is TRUE, meaning at or above the cutoff. FALSE means above only. See addflag parameter.
#' @return Returns a data.frame with ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, text for popups. Output has one row per block group.
#' @source See \url{http://www.epa.gov/ejscreen} for more information, and see \url{http://www.epa.gov/ejscreen/download-ejscreen-data} or \url{ftp://newftp.epa.gov/EJSCREEN} for raw data.
#' @examples
#'  \dontrun{
#'   bg <- download.ejscreen(folder='~', addflag=TRUE)
#'  }
#'  @seealso \code{\link{ejscreen.create}}
#' @export
download.ejscreen <- function(folder=getwd(), ftpurl='ftp://newftp.epa.gov/EJSCREEN', zipname='EJSCREEN_20150505.csv.zip', csvname='EJSCREEN_20150505.csv', addflag=FALSE, cutoff=80, or.tied=TRUE) {

  ##########################################################################################
  # A script to get the 2015 EJSCREEN dataset into memory, using the friendly Rfieldnames
  ##########################################################################################

  if (!require('data.table')) {install.packages('data.table'); library(data.table)}

  # cat( 'value returned is a data.frame with the downloaded EJSCREEN dataset in it \n')

  ##############################
  # if already exists as .RData locally, just do
  # load("bg 2015-04-22 Rnames plus subgroups.RData")
  ##############################

  ##############################
  # To obtain the csv file from the FTP site:
  # (takes a few minutes to download if you do it this way - you could do it manually using an FTP client instead)
  ##############################

  setwd(folder)
  cat('Attempting to download zipped dataset from ', file.path(ftpurl, zipname), ' \n')
  cat('This normally takes a few minutes. \n')
  download.file(file.path(ftpurl, zipname), zipname)
  cat('Attempting to unzip dataset \n')
  unzip(zipname)

  ##############################
  # Read the csv file into R
  ##############################

  # read.csv takes a couple of minutes, and much faster if you use data.table::fread()
  # bg <- read.csv('EJSCREEN_20150505.csv', nrows = 220000) # as.is = TRUE,
  cat('Attempting to import dataset to R \n')
  bg <- fread(csvname)
  bg <- data.frame(bg)

  ##############################
  #
  ##############################
  if (addflag) {
  # Get function called "flagged()" and names.ej.pctile, which stores field names:
  if (!require('devtools')) install.packages('devtools')
  if (!require('analyze.stuff')) devtools::install_github("ejanalysis/analyze.stuff"); library(analyze.stuff)
  if (!require('ejanalysis')) devtools::install_github("ejanalysis/ejanalysis"); library(ejanalysis)
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

  # See which block groups are flagged as having one or more of 12 EJ indexes >= 80th US pctile
  # Store result as x, which is a logical vector as long as the list of block groups:
  x <- flagged(bg[ , names.ej.pctile], cutoff=cutoff, or.tied=or.tied)

  # cat(round(100* sum(x)/length(x) , 1), ' percent of block groups are flagged as having 1+ of the EJ Indexes at/above the 80th percentile of US population \n')
  # 31% of US block groups


  # IF YOU WANT TO SAVE THE RESULTS IN ONE TABLE:
  bg$flagged <- x
}

  # write.csv(bg, file='EJSCREEN_20150505_flagged.csv', row.names=FALSE)
  cat('Done \n\n')

  return(bg)

}
