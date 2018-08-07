#' @title Make text to be shown in popups on Envt data map
#'
#' @description
#'   Takes raw values and what percentiles they are at, 
#'   and presents those as a text field to be used as the text in a popup window on a map 
#' @details 
#'   Could edit code to NOT put in the units when value is NA?\cr
#'   Could edit code to handle cases like only one row, matrix not df?\cr
#'   Could fix to use only one space when no units\cr
#'   \cr
#'   EJSCREEN as of 2015 used 85 pctile.text. fields, for popup text, like "pctile.text.EJ.DISPARITY.pm.eo"\cr
#'   \code{
#'    names(bg2)[grepl('pctile.text', names(bg2) )] \cr
#'    length( bg2[1, grepl('pctile.text', names(bg2) )] ) \cr
#'    # [1] 85 \cr\cr
#'   }  
#'   
#'   In EJSCREEN, there are three types of pctile.text fields: E (text varies), D, EJ:\cr
#'   \code{
#'     'pctile.text.cancer'                            "55 lifetime risk per million (91%ile)"     \cr
#'     'pctile.text.pctmin'                            "13% (30%ile)" \cr
#'     'pctile.text.EJ.DISPARITY.cancer.eo'            "36%ile"    \cr\cr
#'     }                                
#'   For E popups, text includes units:\cr
#'   (neuro was only in 2015 version, not later versions of EJSCREEN)\cr\cr
#'  \code{
#' names.e.pctile[names.e.pctile != 'pctile.neuro']\cr
#' # [1] "pctile.pm"              "pctile.o3"              "pctile.cancer"         \cr
#' # [4] "pctile.resp"            "pctile.dpm"             "pctile.pctpre1960"     \cr
#' # [7] "pctile.traffic.score"   "pctile.proximity.npl"   "pctile.proximity.rmp"  \cr
#' # [10] "pctile.proximity.tsdf"  "pctile.proximity.npdes"\cr\cr
#' }
#' # NOTE HOW UNITS ARE PART OF THE POPUP, AND IT USES SPECIAL ROUNDING RULES \cr
#' # #' # Stored in data('popunits') # colnames are evar and units \cr\cr
#' \code{
#' t(bg2[1, gsub('pctile', 'pctile.text', names.e.pctile[names.e.pctile != 'pctile.neuro'])]) \cr
#' #                                            
#' # pctile.text.pm              "10.4 ug/m3 (76%ile)"                       \cr
#' # pctile.text.o3              "42.8 ppb (22%ile)"                         \cr
#' # pctile.text.cancer          "55 lifetime risk per million (91%ile)"     \cr
#' # pctile.text.resp            "2.1  (72%ile)"                             \cr
#' # pctile.text.dpm             "0.401 ug/m3 (24%ile)"                      \cr
#' # pctile.text.pctpre1960      "0.4 = fraction pre-1960 (68%ile)"         \cr
#' # pctile.text.traffic.score   "23 daily vehicles/meters distance (28%ile)" \cr
#' # pctile.text.proximity.npl   "0.071 sites/km distance (55%ile)"          \cr
#' # pctile.text.proximity.rmp   "0.085 facilities/km distance (21%ile)"     \cr
#' # pctile.text.proximity.tsdf  "0 facilities/km distance (26%ile)"        \cr
#' # pctile.text.proximity.npdes "0.25 facilities/km distance (70%ile)"      \cr
#' # \cr
#' t(bg2[125:126, gsub('pctile', 'pctile.text', names.e.pctile[names.e.pctile != 'pctile.neuro'])]) \cr
#' #                        125                                          126                       \cr
#' # pctile.text.pm              "8.37 ug/m3 (27%ile)"                        NA                   \cr
#' # pctile.text.o3              "41.7 ppb (19%ile)"                          NA                   \cr
#' # pctile.text.cancer          "36 lifetime risk per million (37%ile)"      NA                   \cr
#' # pctile.text.resp            "1.4  (37%ile)"                              NA                   \cr
#' # pctile.text.dpm             "0.275 ug/m3 (13%ile)"                       NA   \cr
#' # pctile.text.pctpre1960      "0.055 = fraction pre-1960 (27%ile)"         "0 = fraction pre-1960 (10%ile)" \cr
#' # pctile.text.traffic.score   "1.7 daily vehicles/meters distance (6%ile)" "0 daily vehicles/meters distance (2%ile)" \cr
#' # pctile.text.proximity.npl   "0.056 sites/km distance (47%ile)"           "0 sites/km distance (16%ile)" \cr
#' # pctile.text.proximity.rmp   "0.046 facilities/km distance (7%ile)"       "0 facilities/km distance (1%ile)" \cr
#' # pctile.text.proximity.tsdf  "0 facilities/km distance (26%ile)"          "0 facilities/km distance (26%ile)" \cr
#' # pctile.text.proximity.npdes "0.067 facilities/km distance (16%ile)"      "0 facilities/km distance (1%ile)" \cr
#' # \cr
#' # single result, e.g.: "24% (36%ile)" \cr
#' } 
#' 
#' @param e raw environmental indicator values for various locations
#' @param pctile required integers 0 to 100, representing the percentile(s) at which the raw value(s) fall(s). 
#' @param prefix optional, default is 'pctile.text.'  This is a text string specifying the first part of the desired resulting fieldname in outputs.
#' @param basenames optional, default is colnames(e). Defines colname(s) of outputs, which are the prefix plus this. 
#' @param units optional character vector with one per column of e, default is the units used for the latest (2016) version of EJSCREEN environmental indicators, 
#' such as 'ppb' and 'ug/m3' -- function will try to use units appropriate to basenames, looking in data(popupunits), and use '' (blank) if no match is found. 
#' @param sigfigs optional, numeric vector with one per col of e, 
#'   defining number of significant digits to show in popup, 
#'   defaulting to rules in EJSCREEN latest (2016) version, 
#'   or just 2 for basenames not found in data(esigfigs).
#' @return Returns character vector or data.frame, same shape as first input parameter.
#' @seealso \code{\link{esigfigs}} \code{\link{make.popup.d}} \code{\link{make.popup.e}} \code{\link{make.popup.ej}} \code{\link{pctileAsText}}
#' @examples
#'     #   Example: inputs are test0 and test1, and desired output is like test2 
#'     #   (except note how prefix is added to each basename)
#'
#'   test0 <- structure(list(
#'     e1 = c(0.185525372063833, 0.174428104575163, 0.485647788983707), 
#'     e2 = c(0.131656804733727, 0.111928104575163, 0.671062839410395), 
#'     other = c(NA, NA, 0.02)), 
#'     .Names = c("e1", "e2", "other"), 
#'     row.names = c(NA, 3L), class = "data.frame")
#'   test0               
#'   
#'    test1 <- structure(list(
#'      pctile.e1 = c(27.1991395138354, 24.6836238179206, 72.382419748292), 
#'      pctile.e2 = c(30.2662374847936, 26.761078397073, 78.2620665123235), 
#'      other = c(NA, NA, 4)), 
#'      .Names = c("pctile.e1", "pctile.e2", "other"), 
#'      row.names = c(NA, 3L), class = "data.frame")
#'    test1
#'    
#'   test2 <- structure(list(
#'     pctile.text.e1 = c("19 (27%ile)", "17 (24%ile)","49 (72%ile)"),
#'     pctile.text.e2 = c("13 (30%ile)", "11 (26%ile)", "67 (78%ile)"), 
#'     other = c(NA, NA, 4)), 
#'     .Names = c("pctile.text.e1","pctile.text.e2", "other"), 
#'     row.names = c(NA, 3L), class = "data.frame")
#'   test2
#' 
#' make.popup.e(test0, test1)
#' 
#' @export
make.popup.e <- function(e, pctile, prefix = 'pctile.text.', basenames, units, sigfigs) { 
  if (missing(basenames)) {
    # might add code to handle cases like only one row, matrix not df, etc?
    basenames <- colnames(e)
  }
  if (missing(sigfigs)) {
    sigfigs <- esigfigs$sigfigs[ match(basenames, esigfigs$evar) ]
    sigfigs[is.na(sigfigs)] <- 2
  }
  e <- data.frame( ejscreensignifarray(e, digits = sigfigs), stringsAsFactors = FALSE)
  
  #   print(e)
  #   print(str(e))
  
  if (missing(units)) {
    # might add code to handle cases like only one row, matrix not df, etc?
    # units will try to use units appropriate to basenames, looking in data(popupunits), and use '' (blank) if no match is found 
    # data("popupunits")
    #print(popupunits)
    units <- popupunits$units[ match(basenames, popupunits$evar) ]
    units[is.na(units)] <- ''
    # might want to NOT put in the units when value is NA?
  }
  
  # could fix to use only one space when no units
  
  x <- mapply(FUN = function(x, u, y) {paste(x, ' ', u, ' (', pctileAsText(y), ')', sep = '')}, e, units, pctile)
  x <- data.frame(x, stringsAsFactors = FALSE)
  colnames(x) <- paste(prefix, basenames, sep = '')
  #rownames(x) <- NULL
  
  x[is.na(e)] <- NA
  rownames(x) <- rownames(e)
  return(x)
}
