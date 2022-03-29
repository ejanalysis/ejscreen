#' @title Get US Totals and Percentages Overall for EJSCREEN Fields
#' 
#' @description NOTE: May replace with ustotals2 from batch.summarizer pkg, 
#'   and or replace to be more generic by using ejscreenformulas style formulas
#'   rather than formulas and variable names hard coded in this function.
#' 
#'   This function simply takes a data.frame of EJSCREEN demographic data
#'   and returns the total count or overall US percentage for various fields,
#'   by using the appropriate denominator (universe) to calculate any given percentage.
#'   For example, PCTLOWINC.US equals sum(lowinc) / sum(povknownratio), not sum(lowinc) / sum(pop).
#'   This function is hard-coded to use specified field names referring to EJSCREEN variables.
#'   This function is not needed to create an EJSCREEN dataset, but is convenient if one wants US summary values.
#' 
#' @param bg Must be a data.frame that has the following colnames:
#'   \itemize{
#'     \item pop,
#'     \item lowinc,
#'     \item mins,
#'     \item under5,
#'     \item over64,
#'     \item lths,
#'     \item lingiso,
#'     \item pre1960,
#'     \item hisp,
#'     \item nhwa,
#'     \item nhba,
#'     \item nhaiana,
#'     \item nhaa,
#'     \item nhnhpia,
#'     \item nhotheralone,
#'     \item nhmulti,
#'     \item povknownratio,
#'     \item age25up,
#'     \item hhlds,
#'     \item builtunits
#'   }
#' @return Returns a named list of US totals and percentages (as fractions 0-100) (e.g., POP.US=xxxx, etc.): \cr
#'   \itemize{
#'     \item POP.US,
#'     \item LOWINC.US,
#'     \item MINS.US,
#'     \item UNDER5.US,
#'     \item OVER64.US,
#'     \item LTHS.US,
#'     \item LINGISO.US,
#'     \item POVKNOWNRATIO.US # denominator FOR PCTLOWINC,
#'     \item BUILTUNITS.US # denominator FOR PCTPRE1960,
#'     \item HHLDS.US  # denominator FOR LINGISO,
#'     \item PRE1960.US,
#'     \item HISP.US,
#'     \item NHWA.US,
#'     \item NHBA.US,
#'     \item NHAIANA.US,
#'     \item NHAA.US,
#'     \item NHNHPIA.US,
#'     \item NHOTHERALONE.US,
#'     \item NHMULTI.US,
#'     \item PCTLOWINC.US,
#'     \item PCTMIN.US,
#'     \item PCTUNDER5.US,
#'     \item PCTOVER64.US,
#'     \item PCTLTHS.US,
#'     \item PCTLINGISO.US,
#'     \item PCTPRE1960.US,
#'     \item PCTHISP.US,
#'     \item PCTNHWA.US,
#'     \item PCTNHBA.US,
#'     \item PCTNHAIANA.US,
#'     \item PCTNHAA.US,
#'     \item PCTNHNHPIA.US,
#'     \item PCTNHOTHERALONE.US,
#'     \item PCTNHMULTI.US
#'   }
#' @examples
#' \dontrun{
#' # See EJSCREEN demographic variables plus some race/ethnicity subgroups
#' c1 = ejscreen::ustotals(ejscreen::bg20DemographicSubgroups2014to2018)
#' c1 = cbind(c1[c1 != 0 & !is.na(c1)])
#' c2 = ejscreen::ustotals(ejscreen::bg20[!is.na(ejscreen::bg20$ST),])
#' ### c2 = ejscreen::ustotals(ejscreen::bg20[!is.na(ejscreen::bg20$ST) & ejscreen::bg20$ST != 'PR',])
#' c2 = cbind(c2[c2 != 0 & !is.na(c2)])
#' US_2014to2018 = unique(rbind(c1, c2))
#' colnames(US_2014to2018) = 'total_count_or_fraction'
#' print(US_2014to2018)
#'
#'
#'  # Display as a nice table with two columns, rounded numbers, rownames and colnames
#'  tots <- ustotals(bg20)
#'  tots <- round(cbind(unlist(tots)), 3)
#'  totrownames <- rownames(tots)[1:16]
#'  tots <- cbind(tots[1:16], 100 * c(1, tots[17:31]))
#'  rownames(tots) <- totrownames
#'  colnames(tots) <- c('count', 'pct')
#'  tots
#' }
#' @export
ustotals <- function(bg) {

  x <- list(
    POP.US		  = sum(bg$pop, na.rm = TRUE),

    LOWINC.US	  = sum(bg$lowinc, na.rm = TRUE),
    MINS.US		  = sum(bg$mins, na.rm = TRUE),
    LINGISO.US	= sum(bg$lingiso, na.rm = TRUE),
    LTHS.US     = sum(bg$lths, na.rm = TRUE),
    UNDER5.US	  = sum(bg$under5, na.rm = TRUE),
    OVER64.US	  = sum(bg$over64, na.rm = TRUE),

    HISP.US		  = sum(bg$hisp, na.rm = TRUE),
    NHWA.US		  = sum(bg$nhwa , na.rm = TRUE),
    NHBA.US		  = sum(bg$nhba , na.rm = TRUE),
    NHAIANA.US	= sum(bg$nhaiana , na.rm = TRUE),
    NHAA.US		  = sum(bg$nhaa , na.rm = TRUE),
    NHNHPIA.US	= sum(bg$nhnhpia , na.rm = TRUE),
    NHOTHERALONE.US	= sum(bg$nhotheralone , na.rm = TRUE),
    NHMULTI.US	= sum(bg$nhmulti , na.rm = TRUE),

    POVKNOWNRATIO.US = sum(bg$povknownratio, na.rm = TRUE), # denominator FOR PCTLOWINC
    HHLDS.US         = sum(bg$hhlds, na.rm = TRUE),         # denominator FOR PCTLINGISO
    AGE25UP.US	     = sum(bg$age25up, na.rm = TRUE),       # denominator FOR PCTLTHS
    BUILTUNITS.US    = sum(bg$builtunits, na.rm = TRUE),   # denominator FOR PCTPRE1960

    PRE1960.US	= sum(bg$pre1960, na.rm = TRUE)
  )





  x <- c(
    x,
    PCTLOWINC.US	= x$LOWINC.US      / x$POVKNOWNRATIO.US,
    PCTMIN.US	    = x$MINS.US   / x$POP.US,
    PCTLINGISO.US	= x$LINGISO.US    / x$HHLDS.US,
    PCTLTHS.US	  = x$LTHS.US       / x$AGE25UP.US,
    PCTUNDER5.US	= x$UNDER5.US / x$POP.US,
    PCTOVER64.US	= x$OVER64.US / x$POP.US,

    PCTHISP.US	       = x$HISP.US         / x$POP.US,
    PCTNHWA.US	       = x$NHWA.US         / x$POP.US,
    PCTNHBA.US	       = x$NHBA.US         / x$POP.US,
    PCTNHAIANA.US      = x$NHAIANA.US      / x$POP.US,
    PCTNHAA.US	       = x$NHAA.US         / x$POP.US,
    PCTNHNHPIA.US	     = x$NHNHPIA.US      / x$POP.US,
    PCTNHOTHERALONE.US = x$NHOTHERALONE.US / x$POP.US,
    PCTNHMULTI.US	     = x$NHMULTI.US      / x$POP.US,

    PCTPRE1960.US	= x$PRE1960.US    / x$BUILTUNITS.US
  )

  return(x)

  #  Note that the essential parts of this are now built into ejscreenformulas which is available as data() in ejscreen package
  # > require(ejscreen)
  # Loading required package: ejscreen
  # > x=ejscreen::ejscreenformulas
  # > x$formula[grepl('US', x$formula)]
  # [1] "VSI.eo.US <- ( sum(mins) / sum(pop)  +  sum(lowinc) / sum(povknownratio) ) / 2"
  # [2] "VSI.svi6.US <- (sum(mins) / sum(pop) + sum(lowinc) / sum(povknownratio) + sum(lths) / sum(age25up) + sum(lingiso) / sum(hhlds) + sum(over64) / sum(pop) + sum(under5) / sum(pop) ) / 6"
  # [3] "VDI.eo <- (VSI.eo - VSI.eo.US) * pop"
  # [4] "VDI.svi6 <- (VSI.svi6 - VSI.svi6.US) * pop"

  ######################################################## #
  # TO CREATE NATIONAL PERSON-LEVEL SUMMARY STATS BASED ON ONLY TRACTS OR ONLY BLOCKGROUPS:
  #
  # Calculate
  #   USA overall total counts and then
  #   USA overall percents
  #
  # PCTMIN.US and PCTLOWINC.US are needed to calculate the EJ Index (the excess metric called VDI.eo).
  # plus PCTOVER64.US PCTUNDER5.US PCTLTHS.US PCTLINGISO.US are needed to calculate the Supplementary/Alternative EJ Indexes that use all 6 demographics (VDI.svi6).
  #
  #	BE CAREFUL INTERPRETING SOME OF THESE COUNTS and percents:
  #	  LOWINC.US, LTHS.US, and LINGISO.US
  #	  AS CALCULATED HERE ARE NOT THE SAME AS PCTLOWINC.US * POP.US, etc.
  #	  SINCE THEY ARE COUNTS AMONG THE RELEVANT UNIVERSE.
  #   NOT THE SAME AS THE WAY A SIMPLISTIC EJ METRIC MIGHT INTERPRET COUNTS AND PERCENTS.
  #	  For example, LOWINC.US HERE CORRECTLY INCLUDES ONLY THOSE FOR WHOM POVERTY STATUS IS KNOWN, for example,
  #	  AND IS NOT quite THE SAME AS THE NATIONAL AVG % LOWINC TIMES TOTAL US POPULATION
  ######################################################## #
}
