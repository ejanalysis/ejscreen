#' @title Get US Totals and Percentages Overall for EJSCREEN Fields
#' @description This function simply takes a data.frame of EJSCREEN demographic data
#'   and returns the total count or overall US percentage for various fields,
#'   by using the appropriate denominator (universe) to calculate any given percentage.
#'   For example, PCTLOWINC.US equals sum(lowinc) / sum(povknownratio), not sum(lowinc) / sum(pop).
#'   This function is hard-coded to use specified field names referring to EJSCREEN variables.
#'   This function is not needed to create an EJSCREEN dataset, but is convenient if one wants US summary values.
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
#' usapprox=data.frame(pop=rep(1419.767,217739),lowinc=464.4692,mins=515.4554,under5=92.48634,
#'  over64=186.7899,lths=134.0128,lingiso=24.68058, pre1960=183.3237,hisp=232.1370,
#'  nhwa=904.3119,nhba=173.5408,nhaiana=9.418460, nhaa=67.47893,nhnhpia=2.204764,
#'  nhotheralone=2.829952,nhmulti=27.84555, povknownratio=1383.92,age25up=938.4447,
#'  hhlds=529.1969,builtunits=604.5883)
#' cbind( ustotals(usapprox) )
#' @export
ustotals <- function(bg) {

  x <- list(
    POP.US		  = sum(bg$pop),
    LOWINC.US	  = sum(bg$lowinc),
    MINS.US		  = sum(bg$mins),
    UNDER5.US	  = sum(bg$under5),
    OVER64.US	  = sum(bg$over64),
    LTHS.US		  = sum(bg$lths),
    LINGISO.US	= sum(bg$lingiso),
    PRE1960.US	= sum(bg$pre1960),
    HISP.US		  = sum(bg$hisp),
    NHWA.US		  = sum(bg$nhwa ),
    NHBA.US		  = sum(bg$nhba ),
    NHAIANA.US	= sum(bg$nhaiana ),
    NHAA.US		  = sum(bg$nhaa ),
    NHNHPIA.US	= sum(bg$nhnhpia ),
    NHOTHERALONE.US	= sum(bg$nhotheralone ),
    NHMULTI.US	= sum(bg$nhmulti )
  )

  x <- c(
    x,
    PCTLOWINC.US	= x$LOWINC.US / sum(bg$povknownratio),
    PCTMIN.US	= x$MINS.US / x$POP.US,
    PCTUNDER5.US	= x$UNDER5.US / x$POP.US,
    PCTOVER64.US	= x$OVER64.US / x$POP.US,
    PCTLTHS.US	= x$LTHS.US / sum(bg$age25up),
    PCTLINGISO.US	= x$LINGISO.US / sum(bg$hhlds),
    PCTPRE1960.US	= x$PRE1960.US / sum(bg$builtunits),

    PCTHISP.US	= x$HISP.US/ x$POP.US,
    PCTNHWA.US	=  x$NHWA.US/ x$POP.US,
    PCTNHBA.US	=  x$NHBA.US/ x$POP.US,
    PCTNHAIANA.US	=  x$NHAIANA.US/ x$POP.US,
    PCTNHAA.US	=  x$NHAA.US/ x$POP.US,
    PCTNHNHPIA.US	=  x$NHNHPIA.US/ x$POP.US,
    PCTNHOTHERALONE.US	=  x$NHOTHERALONE.US/ x$POP.US,
    PCTNHMULTI.US	=  x$NHMULTI.US/ x$POP.US
  )

  return(x)

  #  Note that the essential parts of this are now built into ejscreenformulas which is available as data() in this package
  # > require(ejscreen)
  # Loading required package: ejscreen
  # > x=ejscreenformulas
  # > x$formula[grepl('US', x$formula)]
  # [1] "VSI.eo.US <- ( sum(mins) / sum(pop)  +  sum(lowinc) / sum(povknownratio) ) / 2"
  # [2] "VSI.svi6.US <- (sum(mins) / sum(pop) + sum(lowinc) / sum(povknownratio) + sum(lths) / sum(age25up) + sum(lingiso) / sum(hhlds) + sum(over64) / sum(pop) + sum(under5) / sum(pop) ) / 6"
  # [3] "VDI.eo <- (VSI.eo - VSI.eo.US) * pop"
  # [4] "VDI.svi6 <- (VSI.svi6 - VSI.svi6.US) * pop"

  #########################################################
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
  #########################################################
}
