#' @title Change colnames of csv file on EJSCREEN FTP site to nicer colnames
#' @description Just a wrapper to help easily change colnames used in csv file on EJSCREEN FTP site
#'   into friendlier, preferred colnames for work in R. Uses analyze.stuff::change.fieldnames()
#' @param mynames A character vector of colnames from a data.frame, like names(mydf). No default.
#' @return Returns a character vector of colnames, same length as input parameter
#' @seealso \code{\link{ejscreenformulas}} \code{\link{ejscreen.acs.rename}} analyze.stuff::change.fieldnames()
#' @examples
#'  \dontrun{
#'  gdbtable <- ejscreen.download()
#'  names(gdbtable) <- change.fieldnames.ejscreen.csv(names(gdbtable))
#'  }
#' @export
change.fieldnames.ejscreen.csv <- function(mynames) {
  # just wrapper to change colnames in csv file on ejscreen ftp site to preferred colnames for work in R
  analyze.stuff::change.fieldnames(
    allnames = mynames,
    oldnames = ejscreen::ejscreenformulas$gdbfieldname, # from data()
    newnames = ejscreen::ejscreenformulas$Rfieldname   # from data()
  )
}
