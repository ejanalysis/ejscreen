#' @name names.ej
#' @docType data
#' @aliases names.ej  names.ej.pctile names.ej.bin  EJ-variable-names
#' @title Fieldnames of environmental justice indicator columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of environmental indicator fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.ej]
#'
#' @details This should have the latest version.
#'  Old versions also had fields related to svi6 the 6-demographic-variable indicator
#'  and other versions of EJ index formula with PCT or BURDEN in the variable name instead of DISPARITY.
#'
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.e}} \code{\link{names.d}} \code{\link{names.ej.pctile}}
#' @source Names developed for this package. No external data source.
#' @concept datasets
#' @format A series of variables are available (each is a character vector of colnames):
#' \itemize{
#'  \item "names.ej"
#'  \item "names.ej.bin"
#'  \item "names.ej.pctile"
#'  \item "namesall.ej"
#'  \item "namesall.ej.bin"
#'  \item "namesall.ej.pctile"
#' }
#' And names.ej in turn is this, for example:
#' \itemize{
#'  \item  [1] "EJ.DISPARITY.pm.eo"
#'  \item  [2] "EJ.DISPARITY.o3.eo"
#'  \item  [3] "EJ.DISPARITY.cancer.eo"
#'  \item  [4] "EJ.DISPARITY.resp.eo"
#'  \item  [5] "EJ.DISPARITY.dpm.eo"
#'  \item  [6] "EJ.DISPARITY.pctpre1960.eo"
#'  \item  [7] "EJ.DISPARITY.traffic.score.eo"
#'  \item  [8] "EJ.DISPARITY.proximity.npl.eo"
#'  \item  [9] "EJ.DISPARITY.proximity.rmp.eo"
#'  \item  [10] "EJ.DISPARITY.proximity.tsdf.eo"
#'  \item  [11] "EJ.DISPARITY.proximity.npdes.eo"
#'  \item  [12] "EJ.DISPARITY.ust.eo"
#' }
NULL
