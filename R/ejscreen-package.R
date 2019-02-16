#' @docType package
#' @title Tools for EJSCREEN, US EPA's Environmental Justice (EJ) Screening and Mapping Tool
#' @name ejscreen
#' @aliases ejscreen-package
#' @concept justice EJ demographic
#' @description This R package provides tools related to environmental justice (EJ) analysis,
#'  specifically related to the United States Environmental Protection Agency (EPA)
#'  screening and mapping/GIS tool called EJSCREEN. See \url{http://www.epa.gov/ejscreen}
#'  This package facilitates development of the EJSCREEN dataset, based on user-provided environmental indicators.
#'  The resulting dataset is a data.frame that contains data on demographics (e.g., percent of residents who are low-income)
#'  and user-provided local environmental indicators (e.g., an air quality index),
#'  and calculated indicators called EJ Indexes, which combine environmental and demographic indicators.
#'  The dataset also provides each key indicator as a national population-percentile that represents
#'  what percentage of the US population have equal or lower raw values for the given indicator.
#'  The dataset has one row per spatial location (e.g., Census block group).
#'
#' @details
#' Key functions include
#' \itemize{
#' \item \code{\link{ejscreen.download}} To download the raw data from the FTP site.
#' \item \code{\link{ejscreen.create}}  To create a dataset of demographic indicators, EJ indexes, etc. starting with your own environmental indicators and taking demographic raw data from the American Community Survey (ACS).
#' \item \code{\link{ejscreen.lookuptables}} To create the file that shows percentiles for each indicator
#' \item Various functions from the \pkg{ejanalysis} package are also relevant.
#' }
#' @references
#'
#' \url{http://www.epa.gov/ejscreen} \cr
#' \url{http://ejanalysis.github.io} \cr
#' \url{http://www.ejanalysis.com/} \cr
NULL
