#' @name popupunits
#' @docType data
#' @title Units of measurement for environmental indicators
#' @description Table indicating what units to use, such as ug/m3, 
#'   in showing environmental indicators in EJSCREEN 2015-2016, as shown in popup windows on maps
#' @usage data('popupunits')
#' @source See related Technical Documentation at \url{http://www.epa.gov/ejscreen}
#' @seealso  \code{\link{make.popup.e}}
#' @keywords EJ, environmental justice, datasets, demographic
#' @format A data.frame: \cr\cr
#' > \code{str(popupunits) \cr
#' 'data.frame':	12 obs. of  2 variables:
#' $ evar : chr  "pm" "o3" "cancer" "neuro" ...
#' $ units: chr  "ug/m3" "ppb" "lifetime risk per million" "" ...
#' > popupunits
#'               evar                          units \cr
#' 1               pm                          ug/m3 \cr
#' 2               o3                            ppb \cr
#' 3           cancer      lifetime risk per million \cr
#' 4            neuro                                \cr
#' 5             resp                                \cr
#' 6              dpm                          ug/m3 \cr
#' 7       pctpre1960            = fraction pre-1960 \cr
#' 8    traffic.score daily vehicles/meters distance \cr
#' 9    proximity.npl              sites/km distance \cr
#' 10   proximity.rmp         facilities/km distance \cr
#' 11  proximity.tsdf         facilities/km distance \cr
#' 12 proximity.npdes         facilities/km distance \cr
#' }
NULL
