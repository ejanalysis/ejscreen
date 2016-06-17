#' @title Utility function in showing a percentile as popup text
#'
#' @description
#'   Converts numeric percentiles (0-100) into character (text)
#'   that converts 95.3124 to '95%ile' for example.
#' @param x vector or data.frame of numeric values 0 to 100 (not 0 to 1), 
#'   representing percentiles from EJSCREEN dataset
#' @return Returns matrix/vector of same shape as x if x was data.frame/vector
#' @examples
#'  \dontrun{
#'  (bg2[ 125:126, c('pctile.pctmin', 'pctile.EJ.DISPARITY.pm.eo') ])
#'  (bg2[ 125:126, c('pctile.text.pctmin', 'pctile.text.EJ.DISPARITY.pm.eo') ])
#'  pctileAsText(bg2[ 125:126, c('pctile.pctmin', 'pctile.EJ.DISPARITY.pm.eo') ])
#'  }
#' @export
pctileAsText <- function(x) {
  # note: x should be a vector or data.frame of percentiles from 0 to 100, not 0 to 1
  result <- sapply(x, function(z) {paste(floor(z), '%ile', sep = '')})
  result[is.na(x)] <- NA
  return(result)
  
  # Returns a matrix not a data.frame if given a data.frame
  
  #   > (bg2[ 125:126, c('pctile.pctmin', 'pctile.EJ.DISPARITY.pm.eo') ])
  #       pctile.pctmin pctile.EJ.DISPARITY.pm.eo
  #   125     23.107679                  23.44361
  #   126      1.747692                        NA
  # 
  #   > (bg2[ 125:126, c('pctile.text.pctmin', 'pctile.text.EJ.DISPARITY.pm.eo') ])
  #       pctile.text.pctmin pctile.text.EJ.DISPARITY.pm.eo
  #   125        9% (23%ile)                         23%ile
  #   126         0% (1%ile)                           <NA>
  #
  #   > pctileAsText(bg2[ 125:126, c('pctile.pctmin', 'pctile.EJ.DISPARITY.pm.eo') ])
  #        pctile.pctmin pctile.EJ.DISPARITY.pm.eo
  #   [1,] "23%ile"      "23%ile"                 
  #   [2,] "1%ile"       NA                       
  #
}
