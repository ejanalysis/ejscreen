#' @name names.ejvars15
#' @docType data
#' @aliases names.ejvars15 names.ej EJ-variable-names
#' @title 2015 Fieldnames of environmental justice indicator columns in ejscreen package data
#' @description This data set provides variables that hold the colnames
#'   of environmental indicator fields in data.frames that may be used in the ejscreen package
#'   to make it easier to refer to them as a vector, e.g., mydf[ , names.ej15]
#' @details This is the 2015 (obsolete) version.
#'  The 2015 version had neuro-related indicators in it, and is now in \code{\link{names.ejvars15}}.
#' @seealso  \code{\link{ejscreenformulas}} \code{\link{names.evars}} \code{\link{names.dvars}} \code{\link{names.ejvars}}
#' @usage data('names.ejvars15')
#' @source Names developed for this package. No external data source.
#' @keywords datasets
#' @format A series of variables (each is a character vector of colnames):
#' \itemize{
#'  \item "names.ej15"
#'  \item "names.ej.bin15"
#'  \item "names.ej.burden.eo15"
#'  \item "names.ej.burden.eo.bin15"
#'  \item "names.ej.burden.eo.pctile15"
#'  \item "names.ej.burden.svi615"
#'  \item "names.ej.burden.svi6.bin15"
#'  \item "names.ej.burden.svi6.pctile15"
#'  \item "names.ej.pct.eo15"
#'  \item "names.ej.pct.eo.bin15"
#'  \item "names.ej.pct.eo.pctile15"
#'  \item "names.ej.pct.svi615"
#'  \item "names.ej.pct.svi6.bin15"
#'  \item "names.ej.pct.svi6.pctile15"
#'  \item "names.ej.pctile15"
#'  \item "names.ej.svi615"
#'  \item "names.ej.svi6.bin15"
#'  \item "names.ej.svi6.pctile15"
#'  \item "namesall.ej15"
#'  \item "namesall.ej.bin15"
#'  \item "namesall.ej.pctile15"
#' }
#' And names.ej15 in turn is this, for example: 
#' \itemize{
#'  \item  [1] "EJ.DISPARITY.pm.eo"             
#'  \item  [2] "EJ.DISPARITY.o3.eo"             
#'  \item  [3] "EJ.DISPARITY.cancer.eo" 
#'  \item  [4] "EJ.DISPARITY.neuro.eo"  Note neuro items are only in 2015 version     
#'  \item  [5] "EJ.DISPARITY.resp.eo"           
#'  \item  [6] "EJ.DISPARITY.dpm.eo"            
#'  \item  [7] "EJ.DISPARITY.pctpre1960.eo"     
#'  \item  [8] "EJ.DISPARITY.traffic.score.eo"  
#'  \item  [9] "EJ.DISPARITY.proximity.npl.eo"  
#'  \item  [10] "EJ.DISPARITY.proximity.rmp.eo"  
#'  \item  [11] "EJ.DISPARITY.proximity.tsdf.eo" 
#'  \item  [12] "EJ.DISPARITY.proximity.npdes.eo"
#' }
NULL
