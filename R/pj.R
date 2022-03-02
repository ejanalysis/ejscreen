#' plot ej percentiles vs percentiles from EJSCREEN data
#'
#' @param enum which of the envt indicators to use, such as 1
#' @param dnum which of the demog indicators to use, such as 3
#' @param dat data.frame of ejscreen data, default is bg20
#'
#' @export
#'
#' @examples
#'   pj(1,3)
#'   pj(1,6, col='blue', main='My Graphic')
#' 
pj <- function(enum, dnum, dat=ejscreen::bg20, ...) {
  
  # or dat=blockgroupstats ?
  EVARS <- ejscreen::names.e # c("pm", "o3", "cancer", "resp", "dpm", "pctpre1960", "traffic.score", "proximity.npl", "proximity.rmp", "proximity.tsdf", "proximity.npdes", "ust")
  DVARS <- ejscreen::names.d # c("VSI.eo", "pctmin", "pctlowinc", "pctlths", "pctlingiso", "pctunder5", "pctover64")
  EVARS_ILE <- ejscreen::names.e.pctile # paste0('pctile.', EVARS)
  DVARS_ILE <- ejscreen::names.d.pctile # paste0('pctile.', DVARS)
  EVARS_NICE <- ejscreen::names.e.nice
  DVARS_NICE <- ejscreen::names.d.nice
  
  ileile_plot(
    dat[ , DVARS_ILE[dnum]],
    dat[ , EVARS_ILE[enum]],
    xlab = paste0(DVARS_NICE[dnum], ' (percentile)'),
    ylab = paste0(EVARS_NICE[enum], ' (median of percentiles)'), ...)
}

