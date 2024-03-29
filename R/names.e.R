#' @name names.e 
#' @docType data
#' @aliases names.e.pctile names.e.bin  environmental-variable-names Elist
#' @title Fieldnames of environmental indicator columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of environmental indicator fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.e]
#' @details NOTE: This used to provide the 2015 version's list, which had "neuro" in it, but now defaults to the latest (2016) version
#' @seealso \code{\link{names.e.nice}}  \code{\link{ejscreenformulas}} \code{\link{names.d}} \code{\link{names.ej}}
#' @source Names developed for this package. No external data source.
#' @concept datasets
#' @format A series of variables (each is a character vector of colnames).
#' For the 2.0 version of EJSCREEN:
#' \itemize{
#'  \item "names.e" (pm, o3, cancer,     resp, dpm, pctpre1960, traffic.score, proximity.npl, proximity.rmp, proximity.tsdf, proximity.npdes, ust)
#'  \item "names.e.bin"
#'  \item "names.e.pctile"
#'  \item "Elist" (this one is like names.e, but as a list, not a vector)
#' }
NULL
