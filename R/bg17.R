#' @name bg17
#' @docType data
#' @title This is the 2017 version of the EJSCREEN dataset plus lat lon and countynames, etc., minus some cols and rows
#' @description This data set is the EJSCREEN 2017 dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package, 
#'   and some columns dropped (svi6-related, and the 2 alternative versions of an EJ Index)
#'   and some fields added (lat lon for bg centroids, flagged if any of EJ indexes above 80th percentile in US),
#'   and state name and state abbrev and county name and FIPS for tract, county, state,
#'   minus a handful of rows (that had NA values in FIPS? These are left in the bg18 data for now.)
#' @details Previously the data.frame was bg not bg17, 
#'   and the file was called bg2017_plus_latlon_etc_minus_some_fields_minus_NA_rows.rdata
#' @concept datasets
#' @format data.frame
NULL
