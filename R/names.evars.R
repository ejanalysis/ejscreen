#' @name names.evars
#' @docType data
#' @aliases names.evars names.e environmental-variable-names Elist
#' @title Fieldnames of environmental indicator columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of environmental indicator fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.e]
#' @details NOTE: This used to provide the 2015 version's list, which had "neuro" in it, but now defaults to the latest version. 
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.evars}} \code{\link{names.dvars}} \code{\link{names.ejvars}}
#' @usage data('names.evars')
#' @source Names developed for this package. No external data source.
#' @keywords datasets
#' @format A series of variables (each is a character vector of colnames).
#' For 2016 version of EJSCREEN:
#' \itemize{
#'  \item "names.e" (pm, o3, cancer,     resp, dpm, pctpre1960, traffic.score, proximity.npl, proximity.rmp, proximity.tsdf, proximity.npdes)
#'  \item "names.e.bin"
#'  \item "names.e.pctile"
#'  \item "Elist" (this one is like names.e, but as a list, not a vector)
#' }
#' For 2015 version of EJSCREEN it was:
#' \itemize{
#'  \item "names.e" (pm, o3, cancer, neuro, resp, dpm, pctpre1960, traffic.score, proximity.npl, proximity.rmp, proximity.tsdf, proximity.npdes)
#'  \item "names.e.bin"
#'  \item "names.e.pctile"
#'  \item "Elist" (this one is like names.e, but as a list, not a vector)
#' }
NULL
