#' @title Make text to be shown in popups on Demographic data map
#'
#' @description
#'   Takes raw values and what percentiles they are at, 
#'   and presents those as a text field to be used as the text in a popup window on a map 
#' @details  
#'   Note d should be a (vector? or) data.frame of exact demographic percentages from 0 to 1, not 0 to 100
#'   BUT pctile should be INTEGER 0 to 100, NOT 0 to 1!
#'   Because that is how EJSCREEN data are stored
#'   In EJSCREEN, there are three types of pctile.text fields: E (text varies), D, EJ:
#'     'pctile.text.cancer'                            "55 lifetime risk per million (91%ile)"     
#'     'pctile.text.pctmin'                            "13% (30%ile)" 
#'     'pctile.text.EJ.DISPARITY.cancer.eo'            "36%ile"                                    
#' @param d raw demographic values, 0-1 (such as 0.3345 where roughly 33 percent of the local population is under age 5)
#' @param pctile required integers 0 to 100, representing the percentile(s) at which the raw value(s) fall(s). 
#' @param prefix optional, default is 'pctile.text.'  This is a text string specifying the first part of the desired resulting fieldname in outputs.
#' @param basenames optional, default is colnames(d). Defines colname(s) of outputs, which are the prefix plus this. 
#' @return Returns character vector or data.frame, same shape as first input parameter.
#' @seealso \code{\link{make.popup.d}} \code{\link{make.popup.e}} \code{\link{make.popup.ej}} \code{\link{pctileAsText}}
#' @examples 
#'  # inputs are test0 and test1, and desired output is like test2 
#'    # (except note how prefix is added to each basename)
#'  test0 <- structure(list(
#'    VSI.eo = c(0.185525372063833, 0.174428104575163, 0.485647788983707), 
#'    pctmin = c(0.131656804733727, 0.111928104575163, 0.671062839410395), 
#'    other = c(NA, NA, 0.02)), 
#'    .Names = c("VSI.eo", "pctmin", "other"), 
#'    row.names = c(NA, 3L), class = "data.frame")
#'   test0
#'  # VSI.eo    pctmin other
#'  # 1 0.1855254 0.1316568    NA
#'  # 2 0.1744281 0.1119281    NA
#'  # 3 0.4856478 0.6710628  0.02
#'  
#'   test1 <- structure(list(
#'     pctile.VSI.eo = c(27.1991395138354, 24.6836238179206, 72.382419748292), 
#'     pctile.pctmin = c(30.2662374847936, 26.761078397073, 78.2620665123235), 
#'     other = c(NA, NA, 4)), 
#'     .Names = c("pctile.VSI.eo", "pctile.pctmin", "other"), 
#'     row.names = c(NA, 3L), class = "data.frame")
#'   test1
#'  #   pctile.VSI.eo pctile.pctmin other
#'  # 1      27.19914      30.26624    NA
#'  # 2      24.68362      26.76108    NA
#'  # 3      72.38242      78.26207     4
#'   
#'   test2 <- structure(list(
#'     pctile.text.VSI.eo = c("19% (27%ile)", "17% (24%ile)","49% (72%ile)"),
#'     pctile.text.pctmin = c("13% (30%ile)", "11% (26%ile)", "67% (78%ile)"), 
#'     other = c(NA, NA, 4)), 
#'     .Names = c("pctile.text.VSI.eo","pctile.text.pctmin", "other"), 
#'     row.names = c(NA, 3L), class = "data.frame")
#'   test2
#'  #   pctile.text.VSI.eo pctile.text.pctmin other
#'  # 1       19% (27%ile)       13% (30%ile)    NA
#'  # 2       17% (24%ile)       11% (26%ile)    NA
#'  # 3       49% (72%ile)       67% (78%ile)     4
#' 
#' make.popup.d(test0, test1)
#'  #   pctile.text.VSI.eo pctile.text.pctmin pctile.text.other
#'  # 1       19% (27%ile)       13% (30%ile)              <NA>
#'  # 2       17% (24%ile)       11% (26%ile)              <NA>
#'  # 3       49% (72%ile)       67% (78%ile)        2% (4%ile)
#' 
#' @export
make.popup.d <- function(d, pctile, prefix = 'pctile.text.', basenames) {
  if (missing(basenames)) {
    # might add code to handle cases like only one row, matrix not df, etc?
    basenames <- colnames(d)
  }
  x <- mapply(FUN = function(x, y) {paste(round(100 * x), '% (', pctileAsText(y), ')', sep = '')}, d, pctile)
  x <- data.frame(x, stringsAsFactors = FALSE)
  colnames(x) <- paste(prefix, basenames, sep = '')
  #rownames(x) <- NULL
  x[is.na(d)] <- NA
  rownames(x) <- rownames(d)
  return(x)

}

