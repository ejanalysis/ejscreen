#' @name popupunits
#' @docType data
#' @title Units of measurement for environmental indicators
#' @description Table indicating what units to use, such as ug/m3, 
#'   in showing environmental indicators in EJSCREEN, as shown in popup windows on maps
#' @usage data('popupunits')
#' @source See related Technical Documentation at \url{http://www.epa.gov/ejscreen}
#' @seealso  \code{\link{make.popup.e}} \code{\link{names.e}}
#' @format A data.frame: \cr\cr
#' > \code{str(popupunits) \cr
#' 'data.frame':	11 obs. of  2 variables: \cr
#' $ evar : chr  "pm" "o3" "cancer"  ... \cr
#' $ units: chr  "ug/m3" "ppb" "lifetime risk per million" "" ... \cr
#' > popupunits \cr
#'               evar                          units  \cr
#' 1               pm                          ug/m3  \cr
#' 2               o3                            ppb  \cr
#' 3           cancer      lifetime risk per million  \cr
#' 4             resp                                 \cr
#' 5              dpm                          ug/m3  \cr
#' 6       pctpre1960            = fraction pre-1960  \cr
#' 7    traffic.score daily vehicles/meters distance  \cr
#' 8    proximity.npl              sites/km distance  \cr
#' 9    proximity.rmp         facilities/km distance  \cr
#' 10  proximity.tsdf         facilities/km distance  \cr
#' 11 proximity.npdes         facilities/km distance  \cr
#' }
NULL
