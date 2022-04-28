
## These functions are to take a raw scores dataset and...

## 1) Assign every blockgroup a percentile, by E (e.g., traffic.score), by zonetype (e.g., S)

#       ejanalysis::make.bin.pctile.cols(bg = bg, zone = 0,wtsvarname = 0,keyvarname = 0,datavarnames = 0)

## 2) write lookup tables of percentiles

#       ejanalysis::write.wtd.pctiles(mydf = 0, wts = 0, filename = 0, zone.vector = 0)

## 3) use those lookup tables to express buffer raw score as a percentile. 
#  
#    What is percentile of given environmental score?
# ejanalysis::lookup.pctile(myvector = 40, varname.in.lookup.table = 'cancer', lookup = ejscreen::lookupStates, zone = 'WV')
# lookup.pctile(40, 'cancer', lookupStates, 'WV')
# ejscreen::lookupUSA[lookupUSA$PCTILE=='84' ,'cancer']
# # [1] 39.83055
# ejscreen::lookupStates[lookupStates$PCTILE=='84' & lookupStates$REGION =='WV','cancer']
# # [1] 33.36371


########################################################################### #
# below was other WORK IN PROGRESS - NOT TESTED/ NOT WORKING
# Some attempts to replace those or do them differently: - not working

# like ejanalysis::assign.pctiles(values = indicator, weights = bg$pop, zone = '', na.rm = T)
exact <- function(indicator, pop) {
  mysort <- order(indicator, decreasing = TRUE)
  origorder <- (1:length(indicator))[mysort]
  return((1-cumsum(pop[mysort]) / sum(pop, na.rm = TRUE))[origorder])
  # returns fraction 0 to 1
}

cuts0to100 <- function(exact_percentiles, raw) {
  # for one indicator's percentiles and raw values, not data.frames
  reportedpctile <- floor(100 * exact_percentiles)
  mysort <- order(exact_percentiles, decreasing = FALSE)
  cutoff <- raw[mysort][match(0:100, reportedpctile[mysort])]
  # fill in gaps in table
  for (plevel in 0:100) {
    # note index would be 1-101 for PCTILE 0:100
    if (is.na(cutoff[plevel + 1])) {
      browser()
      if (plevel == 0) {
        cutoff[1] <- 0
      } else {
        cutoff[plevel + 1] <- cutoff[plevel] 
      }
    }
    # returns as 0 to 100
  }
  return(cutoff)
}

# myexact <- exact(indicator=bg21$pm, pop=bg21$pop)
# myreported <- floor(myexact)
# mycuts <- cuts0to100(myexact) # creates this for the lookup table
if (1 == 0) {
  
  rawdf <- ejscreen::bg21[ , ejscreen::names.e]
  mypop <- ejscreen::bg21$pop
  
  exacts <- sapply(X = rawdf, FUN = function(y) exact(y, mypop))
  reporteds <- floor(exacts)
  
  mylookup <- list()
  for (i in 1:NCOL(exacts)) {
    mylookup[[i]] <- cuts0to100(exacts[ , i], rawdf[ , i])
  }
  
}
