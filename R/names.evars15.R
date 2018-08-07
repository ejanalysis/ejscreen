#' @name names.evars15
#' @docType data
#' @aliases names.evars names.e environmental-variable-names Elist
#' @title 2015 Fieldnames of environmental indicator columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of environmental indicator fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.e15]
#' @details NOTE: This is to provide the 2015 version, which had "neuro" in it
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.evars}} \code{\link{names.dvars}} \code{\link{names.ejvars}}
#' @usage data('names.evars')
#' @source Names developed for this package. No external data source.
#' @format A series of variables (each is a character vector of colnames).
#' The 2016 version of EJSCREEN was:
#' \itemize{
#'  \item "names.e" (pm, o3, cancer,     resp, dpm, pctpre1960, traffic.score, proximity.npl, proximity.rmp, proximity.tsdf, proximity.npdes)
#'  \item "names.e.bin"
#'  \item "names.e.pctile"
#'  \item "Elist" (this one is like names.e, but as a list, not a vector)
#' }
#' For 2015 version of EJSCREEN it was changed so names include 15, to distinguish:
#' \itemize{
#'  \item "names.e15" (pm, o3, cancer, neuro, resp, dpm, pctpre1960, traffic.score, proximity.npl, proximity.rmp, proximity.tsdf, proximity.npdes)
#'  \item "names.e.bin15"
#'  \item "names.e.pctile15"
#'  \item "Elist15" (this one is like names.e, but as a list, not a vector)
#' }
NULL
