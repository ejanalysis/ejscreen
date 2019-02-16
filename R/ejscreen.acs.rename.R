#' @title Rename Fields of ACS Data for Use in EJSCREEN
#'
#' @description
#'   Start with raw counts from demographic survey data, and environmental data,
#'   and rename fields to use friendly variable names.
#'
#' @param acsraw Data.frame of raw data counts for each block group, such as population or number of Hispanics.
#' @param folder Default is getwd(). Specifies path for where to read from (if formulafile specified) and write to.
#' @param formulafile Default if this is blank is to use data(ejscreenformulas). Otherwise filename must be specified.
#'   If not specified, function loads this as data().
#' @return Returns a data.frame with some or all of input fields, plus calculated new fields.
#' @examples
#'  # (no examples yet)
#' @export
ejscreen.acs.rename <-
  function(acsraw, folder = getwd(), formulafile) {
    # RENAME FIELDS FROM CENSUS NAMES TO EPA'S EJSCREEN FIELDNAMES
    if (missing(formulafile)) {
      # get formulafile via data()...?
      names(acsraw) <-
        suppressWarnings(
          analyze.stuff::change.fieldnames(
            names(acsraw),
            oldnames = ejscreenformulas$acsfieldname,
            newnames = ejscreenformulas$Rfieldname
          )
        )
    } else {
      names(acsraw) <-
        suppressWarnings(analyze.stuff::change.fieldnames(names(acsraw), file =
                                                            file.path(folder, formulafile)))
      # Note old versions:
      # 'EJSCREEN_FIELDNAMES_AND_FORMULAS_20150505.csv'
      # 'MAP OF CENSUS VS EJSCREEN-EPA FIELDNAMES.CSV' was for demographics only, and a different fieldnames map was available for EJ/envt/etc.:
      # names(bg) <- change.fieldnames('saved fieldnames maps Contractor to EPA varnames 2014-05-22.csv')
    }
    
    return(acsraw)
  }
