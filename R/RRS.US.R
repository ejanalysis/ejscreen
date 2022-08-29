#' @name RRS.US
#' @docType data
#' @title Ratios of mean indicator values across demographic groups
#' @description
#'   Based on the latest EJSCREEN dataset
#'
#'     See \code{\link[ejanalysis]{RR.table}} for how this was created and can be used.
#'  \preformatted{
#'     bg <- ejscreen::bg21plus # or ejscreen::bg21 ?
#'     names.dplus <- c(ejscreen::names.d, ejscreen::names.d.subgroups.pct)
#'
#'     RRS.US21 <- ejanalysis::RR.table(
#'       mydat =  bg,
#'       Enames = ejscreen::names.e,
#'       Dnames = names.dplus,
#'       popcolname = 'pop'
#'     )
#'  }
#'
NULL
