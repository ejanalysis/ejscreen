#' Scatter plot of median of Environmental score percentiles for each Demographic score percentile
#' Does Environmental score tend to be higher where Demographic percent is higher?
#' @aliases qq
#' Shows median envt percentile of places within each percentile of demog
#'
#' @param x_demog_percentile demographic scores of block groups, as percentiles 0-100
#' @param y_envt_percentile environmental indicator scores of block groups, as percentiles 0-100
#' @param main optional main title for plot
#' @param xlab optional x axis text for demographic percentile variable
#' @param ylab optional y axis text for environmental percentile variable
#' @param ... passed to plot(), such as col='red'
#' @import data.table
#' @export
#'
#' @examples
#' bg <- bg22
#' ileile_plot(
#'   ejscreen::bg$pctile.pctmin,
#'   ejscreen::bg$pctile.proximity.tsdf,
#'   xlab='low income percentile',
#'   ylab='median pctile of environmental score at that level of % Demographics'
#'  )
#'  # also see 
#'  # cars::qqPlot(  something_like_pctile.proximity.rmp_at_some_sites, main="How close to US distribution of scores are scores at these sites?", ylab="RMP proximity scores at these sites (as US %ile)", xlab = "Normal quantiles")
#'
#'  pj(1,3)
#'
#'
ileile_plot <- function(x_demog_percentile, y_envt_percentile, xlab='Demographic percentile (binned by rounding)', ylab='median of Environmental percentiles',
                        main='Does Environmental indicator tend to be higher where Demographic % is higher?', ...) {
  yp <- y_envt_percentile
  xp <- round(x_demog_percentile, 0)
  dtab <- data.table::data.table(xp=xp, yp=yp)
  xyplot <- dtab[ , stats::median(yp, na.rm = TRUE), by=xp]
  colnames(xyplot) <- c('x','y')
  plot(xyplot$x, xyplot$y,  main=main, xlab=xlab, ylab=ylab, ...)
}
