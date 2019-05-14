#' @name bg2017_plus_latlon_etc_minus_some_fields_minus_NA_rows
#' @docType data
#' @title 2017 EJSCREEN dataset plus lat lon and countynames, etc., minus some cols and rows
#' @description This data set is the EJSCREEN 2017 dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package, and some columns dropped (svi6-related)
#'   and some fields added (lat lon for bg centroids, flagged if any of EJ indexes above 80th percentile in US),
#'   and state name and state abbrev and county name and FIPS for tract, county, state,
#'   minus a handful of rows (that had NA values in FIPS?)
#' @concept datasets
#' @format data.frame
NULL
