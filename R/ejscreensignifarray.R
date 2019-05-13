#' @title Specify Significant Digits for Each Column of EJSCREEN Indicators
#' @description
#'  Given a matrix or numeric data.frame, round each column to a specified column-specific number of significant digits.
#'  This function provides default values significant digits to use for an EJSCREEN environmental dataset.
#'  This is a wrapper for analyze.stuff::signifarray which is a wrapper that applies signif() to a matrix or data.frame.
#' @param dat Required, matrix or numeric data.frame with the values to be rounded.
#' @param digits Optional, 'ejscreen' by default. Can be a vector as long as the number of columns in dat, where each elements specifies the
#'   number of significant digits to retain for numbers in the corresponding column of dat.
#'   If 'ejscreen' it specifies using the default settings described below in details, 
#'   in which case all colnames(dat) must be among (but in any order) defaultcolnames below.
#' @return Returns dat, but with numbers rounded based on digits parameter.
#' @seealso \code{\link{esigfigs}} \code{\link[analyze.stuff]{signifarray}} \code{\link{signif}}
#' @examples
#'  ejscreensignifarray(data.frame(a=rnorm(10), b=rnorm(10), c=rnorm(10)), 1:3)
#'  envirodata <- data.frame(matrix(rnorm(11*10), ncol=11))
#'    # data("names.evars"); names(envirodata) <- names.e
#'    names(envirodata) <- c("pm", "o3", "cancer", "resp", "dpm", "pctpre1960", "traffic.score", 
#'    "proximity.npl", "proximity.rmp", "proximity.tsdf", "proximity.npdes")
#'  ejscreensignifarray(envirodata)
#' @details  Sig figs used if digits specified as 'ejscreen' are those stored in data(esigfigs)
#' @export
ejscreensignifarray <- function(dat, digits = 'ejscreen') {
  if (is.vector(digits) && tolower(digits) == 'ejscreen') {
    ################################################################################## #
    # DEFAULT RULES FOR SIGNIFICANT DIGITS ON DEFAULT RAW ENVT INDICATORS
    ################################################################################## #
    ###### data(names.evars, package = 'ejanalysis', envir = environment()) # this should be in ejscreen as data lazyloaded
    #defaultsigfigs <- data.frame(defaultcolname=names.e, dig=c(3,3,2,2,2,3,2,2,2,2,2,2))
    #     if (any(!(colnames(dat) %in% defaultsigfigs$defaultcolname))) {
    #       stop('if digits is specified as "ejscreen" then colnames of dat must be exactly these (in any order):\n', paste(defaultsigfigs$defaultcolname, collapse = ' '), '\n')
    #     }
    if (any(!(colnames(dat) %in% esigfigs$evar))) {
      stop('if digits parameter is unspecified or specified as "ejscreen" then colnames of dat must be among these (in any order):\n',
        paste(esigfigs$evar, collapse = ' '),
        '\n'
      )
    }
    
    # put default digits in correct order (and maybe only a subset that matches) 
    # in case dat has right colnames but in a different order than default here assumed
    digits <-
      esigfigs[match(colnames(dat), esigfigs$evar), 'sigfigs']
  }
  
  return(analyze.stuff::signifarray(dat = dat, digits = digits))
}
