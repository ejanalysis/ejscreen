#' @name esigfigs
#' @docType data
#' @title How many signif digits to show
#' @description How many sig figs to show in showing environmental indicators in EJSCREEN?
#' @usage data('esigfigs')
#' @source See related Technical Documentation at \url{http://www.epa.gov/ejscreen}
#' @seealso  \code{\link{make.popup.e}}
#' @format A data.frame: \cr\cr
#' > str(esigfigs) \cr
#' 'data.frame':	12 obs. of  2 variables:\cr
#'  $ sigfigs: num  3 3 2 2 2 3 2 2 2 2 ...\cr
#'  $ evar   : chr  "pm" "o3" "cancer" "neuro" ...\cr\cr
#'     sigfigs            evar\cr
#'         3              pm\cr
#'         3              o3\cr
#'         2          cancer\cr
#'         2           neuro\cr
#'         2            resp\cr
#'         3             dpm\cr
#'         2      pctpre1960\cr
#'         2   traffic.score\cr
#'         2   proximity.npl\cr
#'         2   proximity.rmp\cr
#'         2  proximity.tsdf\cr
#'         2 proximity.npdes\cr
#' 
NULL
