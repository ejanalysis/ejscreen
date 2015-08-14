#' @title Specify Significant Digits for Each Column of EJSCREEN Indicators
#' @description
#'  Given a matrix or numeric data.frame, round each column to a specified column-specific number of significant digits.
#'  This function provides default values significant digits to use for an EJSCREEN environmental dataset.
#'  This is a wrapper for analyze.stuff::signifarray which is a wrapper that applies signif() to a matrix or data.frame.
#' @param dat Required, matrix or numeric data.frame with the values to be rounded.
#' @param digits Optional, 'ejscreen' by default. Can be a vector as long as the number of columns in dat, where each elements specifies the
#'   number of significant digits to retain for numbers in the corresponding column of dat.
#'   If 'ejscreen' it specifies using the default settings described below in details, in which case colnames(dat) must be exactly the same (but in any order) as defaultcolnames below.
#' @return Returns dat, but with numbers rounded based on digits parameter.
#' @seealso \code{\link[analyze.stuff]{signifarray}} \code{\link{signif}}
#' @examples
#'  ejscreensignifarray(data.frame(a=rnorm(10), b=rnorm(10), c=rnorm(10)), 1:3)
#'  envirodata <- data.frame(matrix(rnorm(12*10), ncol=12)); data("names.evars"); names(envirodata) <- names.e
#'  ejscreensignifarray(envirodata)
#' @details  Sig figs used if digits specified as 'ejscreen' are: \cr
#'         defaultcolname dig \cr
#'     1               pm   3 \cr
#'     2               o3   3 \cr
#'     3           cancer   2 \cr
#'     4            neuro   2 \cr
#'     5             resp   2 \cr
#'     6              dpm   3 \cr
#'     7       pctpre1960   2 \cr
#'     8    traffic.score   2 \cr
#'     9    proximity.npl   2 \cr
#'     10   proximity.rmp   2 \cr
#'     11  proximity.tsdf   2 \cr
#'     12 proximity.npdes   2 \cr
#' @export
ejscreensignifarray <- function(dat, digits='ejscreen') {

  if (is.vector(digits) && tolower(digits)=='ejscreen') {
    ###################################################################################
    # DEFAULT RULES FOR SIGNIFICANT DIGITS ON DEFAULT RAW ENVT INDICATORS
    ###################################################################################
    data(names.evars, package='ejanalysis', envir = environment())
    defaultsigfigs <- data.frame(defaultcolname=names.e, dig=c(3,3,2,2,2,3,2,2,2,2,2,2))
    if (any(!(colnames(dat) %in% defaultsigfigs$defaultcolname))) {
      stop('if digits is specified as "ejscreen" then colnames of dat must be exactly these (in any order):\n', paste(defaultsigfigs$defaultcolname, collapse = ' '), '\n')
    }

    #         defaultcolname dig
    #     1               pm   3
    #     2               o3   3
    #     3           cancer   2
    #     4            neuro   2
    #     5             resp   2
    #     6              dpm   3
    #     7       pctpre1960   2
    #     8    traffic.score   2
    #     9    proximity.npl   2
    #     10   proximity.rmp   2
    #     11  proximity.tsdf   2
    #     12 proximity.npdes   2
    #
    # or using gdbfieldnames:
    # "PM25": digSig = 3
    # "OZONE":digSig = 3
    # "DSLPM":digSig = 3
    #
    # "CANCER":digSig = 2
    # "RESP":digSig = 2
    # "NEURO":digSig = 2
    # "PRE1960PCT":digSig = 2
    # "PTRAF":digSig = 2
    # "PNPL":digSig = 2
    # "PRMP":digSig = 2
    # "PTSDF":digSig = 2
    # "PWDIS":digSig = 2

    # put default digits in correct order (and maybe only a subset that matches) in case dat has right colnames but in a different order than default here assumed
    digits <- defaultsigfigs[ match(colnames(dat), defaultsigfigs$defaultcolname), 'dig']
  }

  return(analyze.stuff::signifarray(dat = dat, digits = digits))
}
