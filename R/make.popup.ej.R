#' @title Make text to be shown in popups on EJ map
#'
#' @description
#'   Takes percentiles (unlike make.popup.d or make.popup.e, which need raw values too),
#'   and presents those as a text field to be used as the text in a popup window on a map.
#' @details
#'   Note pctile should be a (vector? or) data.frame of percentiles as INTEGER 0 to 100, NOT 0 to 1!
#'   Because that is how EJSCREEN data are stored.
#'   Might add code to handle cases like only one row, matrix not df, etc?
#'   Assume normal EJSCREEN pctile cols here would be like pctile.EJ.DISPARITY.pm.eo
#'   and then output popup col would be like pctile.text.EJ.DISPARITY.pm.eo
#'   In EJSCREEN, there are three types of pctile.text fields: E (text varies), D, EJ:
#'     'pctile.text.cancer'                            "55 lifetime risk per million (91%ile)"
#'     'pctile.text.pctmin'                            "13% (30%ile)"
#'     'pctile.text.EJ.DISPARITY.cancer.eo'            "36%ile"
#' @param pctile required integers 0 to 100
#' @param prefix optional, default is 'pctile.text.'  This is a text string specifying the first part of the desired resulting fieldname in outputs.
#' @param basenames optional, default is 'pctile.xxx' where xxx is colnames(pctile). Defines colname(s) of outputs, which are the prefix plus this.
#' @return Returns character vector or data.frame, same shape as pctile.
#' @seealso \code{\link{make.popup.d}} \code{\link{make.popup.e}} \code{\link{make.popup.ej}} \code{\link{pctileAsText}}
#' @examples
#'   test1 <- structure(list(
#'     pctile.EJ.DISPARITY.pm.eo = c(43.1816682334032, 27.4198086017171, 71.7852110581344, NA),
#'     pctile.EJ.DISPARITY.o3.eo = c(47.1675935028896, 33.9578650432096, 69.7501760334948, NA)),
#'     .Names = c("pctile.EJ.DISPARITY.pm.eo", "pctile.EJ.DISPARITY.o3.eo"),
#'     row.names = c(1L, 2L, 3L, 126L), class = "data.frame")
#'   test1
#'   #    pctile.EJ.DISPARITY.pm.eo pctile.EJ.DISPARITY.o3.eo
#'   #1                    43.18167                  47.16759
#'   #2                    27.41981                  33.95787
#'   #3                    71.78521                  69.75018
#'   #126                        NA                        NA
#'
#'   test2 <- structure(list(
#'     pctile.text.EJ.DISPARITY.pm.eo = c("43%ile", "27%ile", "71%ile", NA),
#'     pctile.text.EJ.DISPARITY.o3.eo = c("47%ile", "33%ile", "69%ile", NA)),
#'     .Names = c("pctile.text.EJ.DISPARITY.pm.eo", "pctile.text.EJ.DISPARITY.o3.eo"),
#'     row.names = c(1L, 2L, 3L, 126L), class = "data.frame")
#'   test2
#'   #    pctile.text.EJ.DISPARITY.pm.eo pctile.text.EJ.DISPARITY.o3.eo
#'   #1                           43%ile                         47%ile
#'   #2                           27%ile                         33%ile
#'   #3                           71%ile                         69%ile
#'   #126                           <NA>                           <NA>
#'
#'   make.popup.ej(test1)
#'   #  pctile.text.EJ.DISPARITY.pm.eo pctile.text.EJ.DISPARITY.o3.eo
#'   #1                         43%ile                         47%ile
#'   #2                         27%ile                         33%ile
#'   #3                         71%ile                         69%ile
#'   #4                           <NA>                           <NA>
#'
#' @export
make.popup.ej <-
  function(pctile, prefix = 'pctile.text.', basenames) {
    if (missing(basenames)) {
      basenames <- gsub('pctile.', '', colnames(pctile))
    }
    
    #x <- mapply(FUN = function(x, y) {paste(round(100 * x), '% (', pctileAsText(y), ')', sep = '')}, d, pctile)
    #x <- data.frame(x, stringsAsFactors = FALSE)
    
    x <- pctileAsText(pctile)
    colnames(x) <- paste(prefix, basenames, sep = '')
    rownames(x) <- rownames(pctile)
    return(as.data.frame(x, stringsAsFactors = FALSE))
  }
