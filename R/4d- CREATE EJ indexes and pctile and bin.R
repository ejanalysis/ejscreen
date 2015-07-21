###########################################################################
#	CODE TO CREATE/ REPLICATE EJ INDEXES FROM RAW ENVT & DEMOG DATA
#	THEN ASSIGN PERCENTILES FOR THOSE,
#	THEN ASSIGN BINS FOR THOSE
###########################################################################

#   THIS REQUIRES THE ENVIRONMENTAL INDICATORS TO BE IN bg ALREADY

# names.e is from get.names.e()

myej <- with(bg, ej.indexes(bg[, names.e], VSI.eo, pop)

#us.pctile.myej 	<- make.pctile.cols(myej, bg$pop)
#us.bin.myej 	<- make.bin.cols(us.pctile.myej)

# This also might be useful:
# region.pctile.myej <- 
# county.pctile.myej <- 
# region.bin.myej <- 
# county.bin.myej <- 

bg <- cbind(bg, myej, make.bin.pctile.cols(myej, bg$pop))

filename='ACS 2009-2013 EJSCREEN BG w EJ indexes via FTP.RData'

save(bg, file=filename)
cat('Done creating EJ indexes and their percentiles and bins '); print(Sys.time())

###############################################################################################
# Now just the 


# percentiles and bins for Environmental columns 

# text fields need to be created for popups in arcgis if those are needed here.
# flag
# etc.?















# could collect those like this:
#   bg.my <- data.frame(myej, pctile.myej, bin.myej, stringsAsFactors=FALSE)
#


