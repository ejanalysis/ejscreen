#' Convert EJSCREEN R variable names to more descriptive labels from glossary
#'
#' Provides more descriptive variable names drawn from the {\link{ejscreenformulas}},
#' using the ejscreenformulas$glossaryfieldname that corresponds to each ejscreenformulas$Rfieldname in x
#' For example it provides "% low-income (i.e., with income below 2 times poverty level)"
#' if given "pctlowinc"
#'
#' @param x EJSCREEN variable names as found in ejscreenformulas$Rfieldnames, one or more as character vector
#' @return character vector same shape as x, with nice name if avail or unchanged x where otherwise
#' @export
#'
#' @examples
#'  nicenames(names.e)
#'  nicenames(names.d)
#'  nicenames(names.d.subgroups)
nicenames <- function(x) {
  y <- ejscreen::ejscreenformulas$glossaryfieldname[match(x, ejscreen::ejscreenformulas$Rfieldname)]
  y[is.na(y)] <- x[is.na(y)]
  y
}

