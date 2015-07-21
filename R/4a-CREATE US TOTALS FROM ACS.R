#########################################################
#  CREATE NATIONAL PERSON-LEVEL SUMMARY STATS BASED ON ONLY TRACTS OR ONLY BLOCKGROUPS:   
#
#########################################################

####	    US numbers (total counts of people)
#### 	and US percents (% of people as avg person, not avg place)
# created here because they are needed to calculate the excess metrics

POP.US		= sum(bg$pop)
MINS.US		= sum(bg$mins)
PCTMIN.US	= MINS.US/POP.US 
NONMINS.US	= POP.US - MINS.US

OVER64.US	= sum(bg$over64)
PCTOVER64.US	= OVER64.US/POP.US
UNDER5.US	= sum(bg$under5)
PCTUNDER5.US	= UNDER5.US/POP.US

##########################################################################################################
#	NOTE: THESE NATIONAL TOTAL FORMULAS WERE CORRECTED/ CHANGED ON 4/26/2011 AS FOLLOWS:
##########################################################################################################

#	IF WE WANT A DISPARITY METRIC THAT ASSUMES EVERY % METRIC IS A % OF ALL PEOPLE, BE CAREFUL INTERPRETING THESE COUNTS:
#	THE COUNTS LIKE LOWINC.US, LTHS.US, LINGISO.US
#	AS CALCULATED HERE AT LEAST, ARE NOT THE SAME AS PCTLOWINC.US * POP.US, 
#	SINCE THEY ARE COUNTS AMONG THE RELEVANT UNIVERSE, NOT THE SAME AS THE WAY THE SVI AND EJ METRICS INTERPRET # VULNERABLE!
#	LOWINC.US INCLUDES ONLY THOSE FOR WHOM POVERTY STATUS IS KNOWN, 
#	AND IS NOT THE SAME AS THE NATIONAL AVG % LOWINC TIMES TOTAL US POPULATION
#	WHICH MAY BE AN ISSUE OR CONFUSING FOR SOME SVI OR EJ METRICS.

LOWINC.US	= sum(bg$lowinc)			
PCTLOWINC.US	= LOWINC.US/sum(bg$povknownratio)
### denominator is the right one for <2x pov
# NOTE: TRYING TO RECREATE PCTLOWINC.US from just each bg's pop and pctlowinc won't work right.
# because it would be just popwtd avg = sum(pctlowinc * pop)/sum(pop) which isn't quite the same as
# the true sum(pctlowinc * povknownratio)/sum(povknownratio) = LOWINC.US

LTHS.US		= sum(bg$lths)
PCTLTHS.US	= LTHS.US/sum(bg$age25up)

#	NOTE THIS TOTAL IS TOTAL HOUSEHOLDS NOT TOTAL PEOPLE
LINGISO.US	= sum(bg$lingiso)
PCTLINGISO.US	= LINGISO.US/sum(bg$hhlds)

##########################################################################################################

####### NOTE THIS IS # OF built units NOT PEOPLE !

PRE1960.US	= sum(bg$pre1960)
PCTPRE1960.US	= PRE1960.US/sum(bg$builtunits)

##########################################################################################################

#	maybe want these:

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

#######################################################################
#  to LOOK AT THE VALUES CREATED
#######################################################################
#  for (v in (ls()[grep("US", ls())]) ) print(paste(v, " ", get(v))) 
# rm(v)
