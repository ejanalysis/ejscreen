#########################################################
#  NOTES ON FORMULAS / SCRIPTS TO CREATE NATIONAL PERSON-LEVEL SUMMARY STATS BASED ON ONLY TRACTS OR ONLY BLOCKGROUPS:
#########################################################
#

#  These are now built into ejscreenformulas which is available as data() in this package

# Calculates
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

if (1==0) {

  POP.US		= sum(bg$pop)

  MINS.US		= sum(bg$mins)
  PCTMIN.US	= MINS.US / POP.US  #; NONMINS.US	= POP.US - MINS.US

  OVER64.US	= sum(bg$over64)
  PCTOVER64.US	= OVER64.US / POP.US

  UNDER5.US	= sum(bg$under5)
  PCTUNDER5.US	= UNDER5.US / POP.US

  LOWINC.US	= sum(bg$lowinc)
  PCTLOWINC.US	= LOWINC.US / sum(bg$povknownratio)  # note denominator

  LTHS.US		= sum(bg$lths)
  PCTLTHS.US	= LTHS.US / sum(bg$age25up)  # note denominator

  LINGISO.US	= sum(bg$lingiso)
  PCTLINGISO.US	= LINGISO.US / sum(bg$hhlds)   #	NOTE THIS TOTAL IS TOTAL HOUSEHOLDS NOT TOTAL PEOPLE

  PRE1960.US	= sum(bg$pre1960)
  PCTPRE1960.US	= PRE1960.US/sum(bg$builtunits) # NOTE THIS IS # OF built units NOT PEOPLE

  ##########################################################################################################
  #	Also may want these:

  HISP.US		= sum(bg$hisp)
  PCTHISP.US	= HISP.US/ POP.US
  NHWA.US		= sum(bg$nhwa )
  PCTNHWA.US	=  NHWA.US/ POP.US
  NHBA.US		= sum(bg$nhba )
  PCTNHBA.US	=  NHBA.US/ POP.US
  NHAIANA.US	= sum(bg$nhaiana )
  PCTNHAIANA.US	=  NHAIANA.US/ POP.US
  NHAA.US		= sum(bg$nhaa )
  PCTNHAA.US	=  NHAA.US/ POP.US
  NHNHPIA.US	= sum(bg$nhnhpia )
  PCTNHNHPIA.US	=  NHNHPIA.US/ POP.US
  NHOTHERALONE.US	= sum(bg$nhotheralone )
  PCTNHOTHERALONE.US	=  NHOTHERALONE.US/ POP.US
  NHMULTI.US	= sum(bg$nhmulti )
  PCTNHMULTI.US	=  NHMULTI.US/ POP.US
}
