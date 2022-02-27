#' Scatter plot of median of Environmental score percentiles for each Demographic score percentile
#'
#' @param x_demog_percentile demographic scores of block groups, as percentiles 0-100 
#' @param y_envt_percentile environmental indicator scores of block groups, as percentiles 0-100
#' @param main optional main title for plot
#' @param xlab optional x axis text for demographic percentile variable
#' @param ylab optional y axis text for environmental percentile variable
#' @param ... passed to plot(), such as col='red'
#'
#' @export
#'
#' @examples
#' 
#' ileile_plot(
#'   ejscreen::bg20$pctile.pctmin, 
#'   ejscreen::bg20$pctile.proximity.tsdf, 
#'   xlab='low income percentile', 
#'   ylab='median pctile of environmental score at that level of % Demographics'
#'  )
#'  
#'  pj(1,3)
#'  
#'   
ileile_plot <- function(x_demog_percentile, y_envt_percentile, 
                        xlab='Demographic percentile (binned by rounding)',
                        ylab='median of Environmental percentiles',
                        main='Does Environmental indicator tend to be higher where Demographic % is higher?', ...) {
  dt <- data.table::data.table(xp=round(x_demog_percentile, 0), yp=y_envt_percentile)
  xyplot <- dt[ , median(yp, na.rm = TRUE), by=xp]
  colnames(xyplot) <- c('x','y')
  plot(xyplot$x, xyplot$y,  main=main, xlab=xlab, ylab=ylab, ...)
}