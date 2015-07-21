# CREATE DEMOGRAPHIC/VULNERABILITY INDICES 
# FROM ACS DATA
# THIS DOES NOT YET CREATE EJ INDEXES SINCE THOSE NEED ENVT INDICATORS


# still need **** percentiles and bins for basic DEMOGRAPHIC columns !


# assume that bg is already in memory and has pop, pctmin, pctlowinc, etc.

# MUST FIRST DO source('4a-CREATE US TOTALS FROM ACS.R')

# get.names.ejscreen() # should be done already

# ***** xxxxxxx   in progress .....    This should be replaced with ej.indexes(), except for the bg$VSI.eo and .svi6 calculations (unless some reason we need excess.mins etc.)

############
#   THIS COULD BE MADE INTO A FUNCTION OF D1, D2...D6, POP
# CREATE PRIMARY AND ALT. DEMOGRAPHIC INDICATORS
############

bg$VSI.eo  <- with(bg, (
  pctlowinc + pctmin 
) / 2 )

bg$VSI.svi6  <- with(bg, (
  pctlowinc + pctmin + 
    pctlths + 
    pctlingiso + 
    pctunder5 + 
    pctover64
)  / 6 )

bg$VNI.eo    <-  with(bg, VSI.eo * pop)
bg$VNI.svi6		<- with(bg, VSI.svi6 * pop)

################################################################################################
#  CREATE VDI	Vulnerable Difference/Disparity Index (sum of EXCESS # of people in vulnerable groups) 
################################################################################################

#	This is not exactly the count of excess people in each group, since it uses excess% * pop, and % is not always based on entire pop:
# 	defined here as excess fraction (relative to US avg) times population in this place
#	** NOTE: THIS ASSUMES EXCESS LTHS can apply to ENTIRE POP NOT JUST AGE25+ SO INCLUDES THEIR KIDS IN A SENSE
#	** NOTE: THIS ASSUMES EXCESS LOWINC can apply to ENTIRE POP NOT JUST THOSE WITH POV KNOWN
#	** NOTE: THIS TREATS LINGISO AS IF IT WERE % OF PEOPLE NOT HHLDS
#
# 	(first create an excess metric for each demographic variable)

##############################################################
#   ACTUALLY I ALREADY MADE THIS A FUNCTION .... ej.indexes() 
# that could replace code below....
#	CREATE EXCESS COUNTS TO BE USED TO CREATE DISPARITY INDEX
##############################################################
#***** xxxxxxx   in progress
############   THE CODE BELOW USED places NOT bg ....

attach(bg)

#	WE USE POPULATION-WEIGHTED US MEANS.

excess.mins	= pop * (pctmin		- PCTMIN.US)		
excess.lowinc	= pop * (pctlowinc	- PCTLOWINC.US)
excess.lths	= pop * (pctlths	- PCTLTHS.US)
excess.under5	= pop * (pctunder5	- PCTUNDER5.US)
excess.over64	= pop * (pctover64	- PCTOVER64.US)
excess.lingiso	= pop * (pctlingiso	- PCTLINGISO.US)


detach(bg)


#######	PUT THESE IN PLACES DATABASE ???? no we don't need those there
if (1==0) {
  
  bg$excess.mins = excess.mins
  bg$excess.lowinc = excess.lowinc
  bg$excess.lths = excess.lths
  bg$excess.lingiso = excess.lingiso
  bg$excess.under5 = excess.under5
  bg$excess.over64 = excess.over64
  
  rm(
    excess.mins,
    excess.lowinc,
    excess.lths,
    excess.under5,
    excess.over64,	
    excess.lingiso)
  
  detach(places)
  attach(places)
}

##############################################################
#	CREATE DISPARITY-RELATED VULNERABILITY INDEX FOR EACH OF THE 3 OPTIONAL VULNERABILITY INDICES
##############################################################

###############################	BASED ON SVI6 EQUALLY WEIGHTED:

#	THIS VERSION DOES NOT HAVE ADJUSTMENT FACTOR OF 1/(1-VSI.svi6.US) TO MAKE SUM REALLY BE US EXCESS
#	THIS VERSION IS BASED ON POP WTD US MEAN TO CALCULATE EXCESS
#	THIS VERSION USES AVERAGE OF 6, NOT SUM OF 6 FACTORS

bg$VDI.svi6 <- (
  excess.mins + 
    excess.lowinc + 
    excess.lths + 
    excess.under5 + 
    excess.over64 + 
    excess.lingiso 
) / 6

###############################	BASED ON EO2:

#	THIS VERSION DOES NOT HAVE ADJUSTMENT FACTOR OF 1/(1-VSI.svi6.US) TO MAKE SUM REALLY BE US EXCESS
#	THIS VERSION IS BASED ON POP WTD US MEAN TO CALCULATE EXCESS
#	THIS VERSION USES AVERAGE OF 6, NOT SUM OF 6 FACTORS

bg$VDI.eo <- (
  excess.mins + 
    excess.lowinc 
) / 2

###############################
rm(excess.mins, excess.lowinc, excess.lths, excess.under5, excess.over64, excess.lingiso)
# detach(places)
# attach(places)

#############################################################################################

# IDEALLY SHOULD SPECIFY A DATA DIRECTORY - 

filename='ACS 2009-2013 EJSCREEN BG w calc vars via FTP.RData'
save(bg, file=filename)
cat('Done creating demographic indicators '); print(Sys.time())
