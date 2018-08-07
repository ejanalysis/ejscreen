#' @name names.ejvars16
#' @docType data
#' @aliases names.ejvars names.ej EJ-variable-names
#' @title Fieldnames of environmental justice indicator columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of environmental indicator fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.ej]
#' @details This is the 2016 version
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.evars}} \code{\link{names.dvars}} \code{\link{names.ejvars}} \code{\link{names.ejvars15}}
#' @usage data('names.ejvars')
#' @source Names developed for this package. No external data source.
#' @concepts datasets
#' @format A series of variables (each is a character vector of colnames):
#' \itemize{
#'  \item "names.ej"
#'  \item "names.ej.bin"
#'  \item "names.ej.burden.eo"
#'  \item "names.ej.burden.eo.bin"
#'  \item "names.ej.burden.eo.pctile"
#'  \item "names.ej.burden.svi6"
#'  \item "names.ej.burden.svi6.bin"
#'  \item "names.ej.burden.svi6.pctile"
#'  \item "names.ej.pct.eo"
#'  \item "names.ej.pct.eo.bin"
#'  \item "names.ej.pct.eo.pctile"
#'  \item "names.ej.pct.svi6"
#'  \item "names.ej.pct.svi6.bin"
#'  \item "names.ej.pct.svi6.pctile"
#'  \item "names.ej.pctile"
#'  \item "names.ej.svi6"
#'  \item "names.ej.svi6.bin"
#'  \item "names.ej.svi6.pctile"
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
#' }
NULL
