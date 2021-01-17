#' @name names.dvars
#' @docType data
#' @aliases names.dvars names.d names.d.subgroups Dlist demographic-variables
#' @title Fieldnames of demographic columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of demographic fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.e]
#'   Note that earlier versions of EJSCREEN also included fields related to
#'   a demographic indicator that used six not two components:
#'   VSI.svi6, names.d.svi6, names.d.svi6.bin, names.d.svi6.pctile
#' @usage data('names.dvars'); names.d
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.evars}} \code{\link{names.dvars}} \code{\link{names.ejvars}}
#' @source Names developed for this package. No external data source.
#' @concept datasets
#' @format A series of variables (each is a character vector of colnames):
#' \itemize{
#'  \item "names.d" (VSI.eo, pctmin, pctlowinc, pctlths, pctlingiso, pctunder5, pctover64)
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
