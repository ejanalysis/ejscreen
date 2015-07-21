############################################################
#
#	CODE TO ANALYZE THE DISTRIBUTION OF EACH VARIABLE
#	SHOW 100 PERCENTILES AND MEANS FOR EACH OF SEVERAL VARIABLES
#	FOR USA OVERALL AND THEN FOR EACH REGION OR STATE
#	AND SAVE TABLES AS CSV FILES
# FOR EJSCREEN
#
#	Mark A. Corrales, 2014
#
############################################################

#################################
#
# To use this code in R, see 'How to run EJSCREEN R scripts 2014-05.R'
#
#################################

# NOTE: THIS IS WRITTEN ASSUMING THE DATA.FRAME CALLED places IS ALREADY IN MEMORY
# As of 5/8/2014, -9999999  is the missing value indicator the contractor & EPA agreed to use.

default.MISSING.VALUE.SYMBOL <- -9999999

if (exists('places')) {
  cat('Started creating NA values for missing data... ') ; print(Sys.time())
  places[places==default.MISSING.VALUE.SYMBOL] <- NA  
  cat('Finished creating NA values for missing data... '); print(Sys.time())
} else {stop('Must have the data.frame called places already in memory. See instructions in How to run EJSCREEN R... ')}

##############################################################################################
##############################################################################################

# *** HOW NA / MISSING VALUES ARE HANDLED IN THE DATA.FRAME AND THE CSV FILES AND ARCGIS ***

# NOTE: There should be no NA values in the output tables, because they are excluded so even the minimum value or the 1th percentile is not NA -- 
# None of the places represented by percentiles have NA values.
# *** That means they are not precisely percentiles of the entire US population. ***
# *** They are technically percentiles of the population where we have valid data for that indicator. ***

# na.rm=TRUE was put in in as of 5/14/2014 below as a new way to handle NA values (once they are NA instead of -9999999)
#  to ensure that NA values are left out of the calculation of weighted percentiles, mean, sd; for US and each zone.
# Old way was to use x[!is.na(x)] everywhere that x is used, and wts[!is.na(x)] whenever wts is used. 

# *** In testing there seemed to be problems where wtd.mean would be NA even if na.rm=TRUE,  ****
# That was due to integer overflow, where integer raw field * integer weights ACSTOTPOP could create problem and NA would be returned.
# *** So as of 5/16/2014, now functions do as.numeric()  for raw data columns and weights.

##############################################################################################
##############################################################################################

#####################################
#	DEFINE THE BASIC FUNCTIONS 
#	THAT FIND 100 PERCENTILE VALUES, MEAN, AND MAYBE EVEN STANDARD DEVIATION, 
#	FOR DISTRIBUTION OF BLOCK GROUPS, AND THEN FOR DISTRIBUTION OF PEOPLE (POPULATION-WEIGHTED STATS ACROSS BLOCK GROUPS)
#####################################

#########################################################
#	DEFINE FUNCTION TO SHOW
#	TABLE OF POPULATION-WEIGHTED CUTOFF VALUES FOR THE DECILES OR QUINTILES
#########################################################

require(Hmisc)
# The Hmisc package provides the function called wtd.quantile()

################################
#	NOTE THESE FUNCTIONS ARE WRITTEN ASSUMING THE DATA IS IN A DATAFRAME CALLED places (more generic code that requires passing the data.frame is elsewhere)
################################

#################################################################################################
# BASIC FUNCTION TO CALCULATE A LOOKUP TABLE OF 100 POPULATION PERCENTILES FOR THOSE PLACES WITH VALID DATA
#################################################################################################

table.pop.pctile	<- function(x,wt) { wtd.quantile(x, weights=wt, probs=seq(0,1,by=0.01), type='i/n', na.rm=TRUE ) }

#################################################################################################
#  TO CREATE BASIC LIST OF PERCENTILES (not used in EJSCREEN)
#################################################################################################

pctiles.unrounded = function(x) { cbind(quantile(x, probs=(1:100)/100, na.rm=TRUE)) }

#################################################################################################
#	TO WRITE (unweighted) CSV FILE WITH PERCENTILES AND MEAN, AND MAYBE STD DEVIATION (not used in EJSCREEN)
#################################################################################################

write.pctiles = function(column.names, filename, MISSING.VALUE.SYMBOL=NA) {

  rawcols <- places[, column.names ] # wastes some RAM to make a copy, but easier

  # if special missing value symbol used, convert to NA for the calculations
  if (!is.na(MISSING.VALUE.SYMBOL)) {
    rawcols[rawcols==MISSING.VALUE.SYMBOL] <- NA    
  }

  r = data.frame(sapply(rawcols, function(x) pctiles.unrounded(x) ) )
	r = rbind(r, t(data.frame(mean=sapply(rawcols, function(x) mean(x, na.rm=TRUE) ) ) ))
	r = rbind(r, t(data.frame(std.dev=sapply(rawcols, function(x) sd(x, na.rm=TRUE) ) ) ))

  # replace NA in tables with missing value symbol if necessary
  if (!is.na(MISSING.VALUE.SYMBOL)) {
    r[is.na(r)] <- MISSING.VALUE.SYMBOL
  }
  
  write.csv(r, file=paste(filename, ".csv", sep=""))
  return(r)
}

#####################################
#  DEFINE FUNCTION TO SHOW THOSE unweighted STATS STRATIFIED BY REGION (OR STATE),  (not used in EJSCREEN)
#	SAVING A FILE OF STATS FOR EACH REGION OR STATE
#####################################

write.pctiles.by.zone = function(column.names, filename, zone.vector, MISSING.VALUE.SYMBOL=NA) {

  rawcols <- places[, column.names ] # wastes some RAM to make a copy, but easier
  
  # if special missing value symbol used, convert to NA for the calculations
  if (!is.na(MISSING.VALUE.SYMBOL)) {
    rawcols[rawcols==MISSING.VALUE.SYMBOL] <- NA    
  }
  
  for (z in unique(zone.vector)) {
    r = data.frame(sapply(rawcols[zone.vector==z, ], function(x) pctiles.unrounded(x) ) )
    r = rbind(r, t(data.frame(mean=sapply(rawcols[zone.vector==z,  ], function(x) mean(x, na.rm=TRUE) ) ) ))
    r = rbind(r, t(data.frame(std.dev=sapply(rawcols[zone.vector==z, ], function(x) sd(x, na.rm=TRUE) ) ) ))

    # replace NA in tables with missing value symbol if necessary
    if (!is.na(MISSING.VALUE.SYMBOL)) {
      r[is.na(r)] <- MISSING.VALUE.SYMBOL
    }
    
    write.csv(r, file=paste(filename, "-notpopwtd-for zone ", z, ".csv", sep=""))
  }
  return(unique(zone.vector))
}

#################################################################################################
#  TO WRITE (POPULATION-)WEIGHTED CSV FILE WITH ***wtd*** PERCENTILES AND wtd MEAN, AND wtd STD DEVIATION
#################################################################################################

# NOTE na.rm=TRUE is done in table.pop.pctile, so needn't do that below as well.

write.wtd.pctiles = function(column.names, wts, filename, MISSING.VALUE.SYMBOL=NA) {

  # as.numeric() is to avoid integer overflow if integer and wts huge
  rawcols <- as.data.frame(lapply(places[, column.names ], as.numeric)) # to be more generic, column.names would be cols, replacing places[,column.names]
  wts <- as.numeric(wts)

  # if special missing value symbol used, convert to NA for the calculations
  if (!is.na(MISSING.VALUE.SYMBOL)) {
    rawcols[rawcols==MISSING.VALUE.SYMBOL] <- NA    
    wts[wts==MISSING.VALUE.SYMBOL] <- NA
  }

  # If every element of a column is NA, these all fail: wtd.mean, wtd.var, table.pop.pctile that uses wtd.quantile
  # Use a simple way to allow wtd functions below to still work -- resulting pctiles and mean will all be zero.
  rawcol.is.all.na <- sapply(rawcols, function(x) all(is.na(x)))
  rawcols[ , rawcol.is.all.na] <- 0 

  r = data.frame(sapply(rawcols, function(x) table.pop.pctile(x, wts) ) )
	r = rbind(r, t(data.frame(mean=sapply(rawcols, function(x) wtd.mean(x, wts, na.rm=TRUE) ) ) ))
	r = rbind(r, t(data.frame(std.dev=sapply(rawcols, function(x) sqrt(wtd.var(x, wts, na.rm=TRUE)) ) ) ))

  # fix columns where all were NA values so don't say zero
  r[ , rawcol.is.all.na] <- NA

  # replace NA in tables with missing value symbol if necessary
  if (!is.na(MISSING.VALUE.SYMBOL)) {
    r[is.na(r)] <- MISSING.VALUE.SYMBOL
  }

	write.csv(r, file=paste(filename, ".csv", sep=""))
  return(r)
}

#####################################
#	DEFINE FUNCTION TO SHOW THOSE STATS STRATIFIED BY REGION (OR STATE), 
#	SAVING A FILE OF STATS FOR EACH REGION OR STATE
#####################################

write.wtd.pctiles.by.zone = function(column.names, wts, filename, zone.vector, MISSING.VALUE.SYMBOL=NA) {

  # as.numeric() is to avoid integer overflow if integer and wts huge
  rawcols <- as.data.frame(lapply(places[, column.names ], as.numeric)) # to be more generic, column.names would be cols, replacing places[,column.names]
  wts <- as.numeric(wts)
  
  # if special missing value symbol used, convert to NA for the calculations
  if (!is.na(MISSING.VALUE.SYMBOL)) {
    rawcols[rawcols==MISSING.VALUE.SYMBOL] <- NA    
    wts[wts==MISSING.VALUE.SYMBOL] <- NA
  }
  
  # r <- list(1:length(unique(zone.vector))) # if we wanted to save all the tables, one per zone, in a list, could say r[[z]] <- .... below

  for (z in unique(zone.vector)) { 

    # WITHIN A GIVEN ZONE ***
    # If every element of a column is NA, these all fail: wtd.mean, wtd.var, table.pop.pctile that uses wtd.quantile
    # Use a simple way to allow wtd functions below to still work -- resulting pctiles and mean will all be zero.
    rawcol.is.all.na <- sapply(rawcols[zone.vector==z,  ], function(x) all(is.na(x)))
    rawcols[zone.vector==z, rawcol.is.all.na] <- 0 

    r = data.frame(sapply(rawcols[zone.vector==z,  ], function(x) table.pop.pctile(x, wts[zone.vector==z]) ) )
		r = rbind(r, t(data.frame(mean=sapply(rawcols[zone.vector==z,  ], function(x) wtd.mean(x, wts[zone.vector==z], na.rm=TRUE) ) ) ))
		r = rbind(r, t(data.frame(std.dev=sapply(rawcols[zone.vector==z,  ], function(x) sqrt(wtd.var(x, wts[zone.vector==z], na.rm=TRUE)) ) ) ))

		# fix columns where all were NA values so don't say zero
		r[ , rawcol.is.all.na] <- NA

    # replace NA in tables with missing value symbol if necessary
		if (!is.na(MISSING.VALUE.SYMBOL)) {
		  r[is.na(r)] <- MISSING.VALUE.SYMBOL
		}
		
		write.csv(r, file=paste(filename, "-popwtd-for zone ", z, ".csv", sep=""))
	}
  return(unique(zone.vector))
  # return(r[z])  #  if we wanted to compile & then return all the tables, one per zone, in a list
}

# zone.vector should be a vector that is the data in the column to use for grouping, e.g. zone.vector <- places$REGION

#############################################################################################################



if (1==0) {
  
  
  # THE WORK BELOW IS NOW DONE BY THE CODE IN 'How to run EJSCREEN R scripts 2014-05.R'
  
  
#####################################
#	NOW CALL THE FUNCTIONS DEFINED ABOVE TO CREATE FILES WITH THE STATS IN THEM
#####################################


# FOR TESTING, using a sample envt data set:
if (1==0) {
  places <- data.frame(pm=runif(1000,5,20), o3=runif(1000,3,50), pop=rlnorm(1000, meanlog=log(1000),sdlog=1))
  cbind(table.pop.pctile(places$pm, places$pop))
}
#
#	example of results of table.pop.pctile:
#   0%  5.029987
#   1%  5.036916
# ...
#  99% 19.775978
# 100% 19.993567
# FOR TESTING:
if (1==0) {
 cols=c("pm", "o3")
 fname="TESTING results table of WTD pctiles for EJ vars"
 write.wtd.pctiles(cols, p$pop, fname)
}



  
#####################################
#	ANALYZE DEMOGRAPHIC VARIABLES
#####################################

Dlist = list("VSI.eo", "VSI.svi6", "pctmin", "pctlowinc", "pctlths", "pctlingiso", "pctunder5", "pctover64")
cols=unlist(Dlist)

#	FOR THE US OVERALL

fname= "results table of BG pctiles for DEMOG vars"
write.pctiles(cols, fname)

fname= "results table of WTD pctiles for DEMOG vars"
write.wtd.pctiles(cols, places$pop, fname)

#	BY REGION

zone.vector= places$REGION

fname= "results table of BG pctiles for DEMOG vars"
write.pctiles.by.zone(cols, fname, zone.vector)

fname= "results table of WTD pctiles for DEMOG vars"
write.wtd.pctiles.by.zone(cols, places$pop, fname, zone.vector)

#	BY STATE

zone.vector= places$ST

fname= "results table of BG pctiles for DEMOG vars"
write.pctiles.by.zone(cols, fname, zone.vector)

fname= "results table of WTD pctiles for DEMOG vars"
write.wtd.pctiles.by.zone(cols, places$pop, fname, zone.vector)

#####################################
#	ANALYZE ENVT VARIABLES
#####################################

Elist = list(
"pm", 
"o3", 
"cancer",
"neuro",
"resp",
"dpm",
"pctpre1960",
"proximity.npl",
"proximity.rmp",
"proximity.tsdf",
"traffic.score",
  "proximity.npdes"
)

cols=unlist(Elist)

#	FOR THE US OVERALL

fname= "results table of WTD pctiles for ENVT vars"
write.wtd.pctiles(cols, places$pop, fname)

fname= "results table of BG pctiles for ENVT vars"
write.pctiles(cols, fname)

#	BY REGION

zone.vector <- 	places$REGION

fname= "results table of BG pctiles for ENVT vars"
write.pctiles.by.zone(cols, fname, zone.vector)
fname= "results table of WTD pctiles for ENVT vars"
write.wtd.pctiles.by.zone(cols, places$pop, fname, zone.vector)

#	BY STATE

zone.vector <- places$ST

fname= "results table of BG pctiles for ENVT vars"
write.pctiles.by.zone(cols, fname, zone.vector)
fname= "results table of WTD pctiles for ENVT vars"
write.wtd.pctiles.by.zone(cols, places$pop, fname, zone.vector)


#####################################
#	ANALYZE EJ VARIABLES
#####################################

###########	SPECIFY THE COLUMNS THAT CONTAIN THE EJ INDEX SCORES 
# SELECT ALL EJ INDEX FIELDS (RAW OR PERCENTILE)
cols= grep("EJ", names(places))		
# THEN REMOVE THE PERCENTILE FIELDS TO KEEP JUST THE RAW EJ DISPARITY INDEX FIELDS 
cols= cols[-grep("pctile", names(places)[cols])]		
###########

#	FOR THE US OVERALL

fname="results table of WTD pctiles for EJ vars"
write.wtd.pctiles(cols, places$pop, fname)

fname="results table of BG pctiles for EJ vars"
write.pctiles(cols, fname)

#	BY REGION

zone.vector = places$REGION

fname= "results table of WTD pctiles for EJ INDEXES"
write.wtd.pctiles.by.zone(cols, places$pop, fname, zone.vector)

fname= "results table of BG pctiles for EJ INDEXES"
write.pctiles.by.zone(cols, fname, zone.vector)

#	BY STATE

zone.vector = places$ST

fname= "results table of WTD pctiles for EJ INDEXES"
write.wtd.pctiles.by.zone(cols, places$pop, fname, zone.vector)

fname= "results table of BG pctiles for EJ INDEXES"
write.pctiles.by.zone(cols, fname, zone.vector)
}
##############################################################################################
