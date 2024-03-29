#' @title Create Calculated EJSCREEN Variables
#'
#' @description
#'   Use specified formulas to create calculated, derived variables such as percent low income.
#'   Relies upon analyze.stuff::calc.fields() from \pkg{analyze.stuff} package.
#' @param bg Data.frame of raw demographic data counts, and environmental indicators, for each block group, such as population or number of Hispanics.
#' @param folder Default is getwd(). Specifies path for where to read from (if formulafile specified) and write to.
#' @param formulafile Name of optional csv file with column called formula, providing R syntax formulas as character fields.
#'  If not specified, function gets this from data(ejscreenformulas).
#'  Example of one formula: 'pctunder5 <- ifelse( pop==0,0, under5/pop)'
#'   Use a result of zero in cases where the denominator is zero, to avoid division by zero.
#'   For example, the formula \code{'pctmin <- ifelse(pop==0,0, as.numeric(mins ) / pop)'}
#'   indicates that percent minority is calculated as the ratio of number of minorities
#'   over total population of a block group, but is set to zero if the population is zero.
#' @param formulas Options vector of formulas as character strings that contain R statements in the form "var1 <- var2 + var3" for example.
#'   Either formulafile or formulas can be specified (or neither) but not both (error).
#'   Formulas should be in the same format as a formulafile field or the contents of ejscreenformulas (via data(ejscreenformulas) or lazy loading like x <- ejscreenformulas).
#' @param keep.old Vector of variables names from names(bg), indicating which to return (retain, not drop). Default is to keep only the ones that match the list of default names in this code. Or this can be simply 'all' which means keep all input fields.
#' @param keep.new Vector of variables names of new created variables, indicating which to return (retain, not drop). Default is to keep a specific list of fields (see source code). Or this can be simply 'all' which means keep all new fields.
#' @return Returns a data.frame with some or all of input fields (those in keep.old), plus calculated new fields (those in keep.new).
#' @examples
#'  set.seed(99)
#'  envirodata=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12),
#'    air=rlnorm(1000), water=rlnorm(1000)*5, stringsAsFactors=FALSE)
#'  demogdata=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12),
#'    pop=rnorm(n=1000, mean=1400, sd=200), mins=runif(1000, 0, 800),
#'    num2pov=runif(1000, 0,500), stringsAsFactors=FALSE)
#'  demogdata$povknownratio <- demogdata$pop
#'  x=ejscreen.acs.calc(bg=demogdata)
#' @export
ejscreen.acs.calc <-
  function(bg,
           folder = getwd(),
           keep.old,
           keep.new,
           formulafile,
           formulas) {
    if (!missing(formulafile) &
        !missing(formulas)) {
      stop('Cannot specify both formulafile and formulas.')
    }

    if (missing(formulafile) & missing(formulas)) {
      #both missing so use default built in formulas and fieldnames
      x <- ejscreen::ejscreenformulas  # lazy loads as data
      myformulas <- x$formula
    }

    if (!missing(formulafile) & missing(formulas)) {
      if (!file.exists(file.path(folder, formulafile))) {
        stop(paste(
          'formulafile not found at',
          file.path(folder, formulafile)
        ))
        # x <- ejscreen::ejscreenformulas  # or could lazy load as data the defaults here
      } else {
        x <-
          read.csv(file = file.path(folder, formulafile),
                   stringsAsFactors = FALSE)
        myformulas <- x$formula
      }
    }

    if (missing(formulafile) & !missing(formulas)) {
      myformulas <- formulas
      # could add error checking here
    }

    # ejscreen::ejscreenformulas as of 8/2015:
    #
    # 'data.frame':	470 obs. of  8 variables:
    #   $ gdbfieldname     : chr  NA NA NA NA ...
    #   $ Rfieldname       : chr  "ageunder5m" "age5to9m" "age10to14m" "age15to17m" ...
    #   $ acsfieldname     : chr  "B01001.003" "B01001.004" "B01001.005" "B01001.006" ...
    #   $ type             : chr  "ACS" "ACS" "ACS" "ACS" ...
    #   $ glossaryfieldname: chr  NA NA NA NA ...
    #   $ formula          : chr  NA NA NA NA ...
    #   $ acsfieldnamelong : chr  "Under 5 years|SEX BY AGE" "5 to 9 years|SEX BY AGE" "10 to 14 years|SEX BY AGE" "15 to 17 years|SEX BY AGE" ...
    #   $ universe         : chr  "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" "Universe:  Total population" ...


    if (missing(keep.old)) {
      keep.old <- c(
        'FIPS',
        'ST',
        'pop',
        'builtunits',
        'age25up',
        'povknownratio',
        'hhlds',

        'hisp',
        'nhwa',
        'nhba',
        'nhaiana',
        'nhaa',
        'nhnhpia',
        'nhotheralone',
        'nhmulti'
      )
    }
    if (keep.old[1] == 'all') {
      keep.old <- names(bg)
    }
    # don't try to keep fields not supplied in bg
    keep.old <- keep.old[keep.old %in% names(bg)]


    if (missing(keep.new)) {
      keep.new <- c(
        names.d,   # "VSI.eo"        "pctmin"        "pctlowinc"  etc.
        names.d.subgroups, # "pctnhwa"         "pcthisp" etc.
        names.d.subgroups.count, # "nhwa"         "hisp"  etc.

        'pctpre1960', # from ACS, unlike other Envt vars
        'pre1960',   # from ACS, unlike other Envt vars

        'lowinc',
        'mins',
        'nonmins',
        'lths',
        'lingiso',
        'under5',
        'over64'
      )

    ejfields <- c(
      names.ej
    )

    keep.new <- c(keep.new, ejfields)
  }
    # if any of these are not successfully created by analyze.stuff::calc.fields(), they just won't be returned by that function.
    if (keep.new[1] == 'all') {
      # all the new ones (calc.fields returns all new and none of old by default)
      newfieldsonly <-
        analyze.stuff::calc.fields(bg, formulas = myformulas)
      bg <-
        data.frame(bg[, keep.old], newfieldsonly, stringsAsFactors = FALSE)
    } else {
      # just some of the new ones
      bg <-
        analyze.stuff::calc.fields(bg,
                                   formulas = myformulas,
                                   keep = c(keep.old, keep.new))
    }

    #new.fields <- analyze.stuff::calc.fields(bg, formulas=myformulas, keep=keep.new)
    #print('keep.new: '); print(keep.new)
    #print(names(new.fields))
    # don't try to keep fields not successfully created
    #keep.new <- keep.new[ keep.new %in% names(new.fields)]

    #print('keep.new: '); print(keep.new)
    #print('keep.old: '); print(keep.old)
    #print('names of bg'); print(names(bg))

    #bg <- cbind( bg[ , keep.old], new.fields[ , keep.new] )
    # new.fields would only have cols that were in keep.new
    #bg <- cbind( bg[ , keep.old], new.fields )

    return(bg)
  }
