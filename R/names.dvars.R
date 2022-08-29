#' @name names.d
#' @docType data
#' @aliases names.d  names.d.pctile names.d.bin names.d.subgroups Dlist demographic-variables
#' @title Fieldnames of demographic columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of demographic fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.e]
#'   Note that earlier versions of EJSCREEN also included fields related to
#'   a demographic indicator that used six not two components:
#'   VSI.svi6, names.d.svi6, names.d.svi6.bin, names.d.svi6.pctile
#' @usage data('names.dvars'); names.d
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.e}} \code{\link{names.d}} \code{\link{names.ej}}
#' @source Names developed for this package. No external data source.
#' @concept datasets
#' @format A series of variables (each is a character vector of colnames):
#' \itemize{
#'  \item "names.d" (VSI.eo, pctmin, pctlowinc, etc.)
#'  \item "names.d.bin"
#'  \item "names.d.eo"
#'  \item "names.d.eo.bin"
#'  \item "names.d.eo.pctile"
#'  \item "names.d.pctile"
#'  \item "names.d.subgroups"
#'  \item "names.d.subgroups.count"
#'  \item "names.d.subgroups.pct"
#'  #'  \item "Dlist" (this one is like names.d, but as a list, not a vector)
#' }
NULL
