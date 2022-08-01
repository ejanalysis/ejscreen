
# MANUALLY FIX THE 11 ROWS THAT DID NOT GET STATE/COUNTY INFO LOOKED UP RIGHT SINCE
# THERE HAVE BEEN CHANGES IN FIPS SINCE 2010 

library(ejscreen)


bg <- ejscreen::bg21

x = cbind(sapply(bg, function(x) sum(is.na(x)) ))
cbind(sort(x[x[,1] >0,]))

bg[is.na(bg$ST), 'FIPS.ST']     <- substr(bg$FIPS[is.na(bg$ST)], 1, 2)
bg[is.na(bg$ST), 'FIPS.COUNTY'] <- substr(bg$FIPS[is.na(bg$ST)], 1, 5)
bg[is.na(bg$ST), 'FIPS.TRACT']  <- substr(bg$FIPS[is.na(bg$ST)], 1, 11)
bg[is.na(bg$ST), 'statename']   <- 'Alaska'
bg[is.na(bg$ST), 'REGION']      <- 10
bg[is.na(bg$ST), 'countyname']      <- NA
bg[is.na(bg$ST), 'ST']   <- 'AK'
attr(bg,    which = 'released') <- 2022 # it was late- should have been 2021
attr(bg,    which = 'ejscreen_version') <- '2.0'
attr(bg,    which = 'ACS') <- '2015-2019'
x = cbind(sapply(bg, function(x) sum(is.na(x)) ))
cbind(sort(x[x[,1] >0,]))

bg21 <- bg ; rm(bg)
usethis::use_data(bg21, overwrite = TRUE)

############################ #
# Now fix bg21plus ... but ... had no info at all so must use the 11 from bg21

eleven <- bg21[is.na(bg21$countyname), ]
bg21plus <- bg21plus[!is.na(bg21plus$FIPS),] 
new11 <- bg21plus[1:11,]
new11[1:11, ] <- NA
# new11$FIPS <- eleven$FIPS
new11[ , names(new11)[names(new11) %in% names(eleven)]] <- eleven[ , names(new11)[names(new11) %in% names(eleven)]]
bg21plus <- rbind(bg21plus, new11)


bg <- bg21plus # THESE HAD NOT EVEN FIPS. 

x = cbind(sapply(bg, function(x) sum(is.na(x)) ))
cbind(sort(x[x[,1] >0,]))

# bg[is.na(bg$ST), 'FIPS.ST']     <- substr(bg$FIPS[is.na(bg$ST)], 1, 2)
# bg[is.na(bg$ST), 'FIPS.COUNTY'] <- substr(bg$FIPS[is.na(bg$ST)], 1, 5)
# bg[is.na(bg$ST), 'FIPS.TRACT']  <- substr(bg$FIPS[is.na(bg$ST)], 1, 11)
# bg[is.na(bg$ST), 'statename']   <- 'Alaska'
# bg[is.na(bg$ST), 'REGION']      <- 10
# bg[is.na(bg$ST), 'countyname']      <- NA
# bg[is.na(bg$ST), 'ST']   <- 'AK'
attr(bg,    which = 'released') <- 2022 # it was late- should have been 2021
attr(bg,    which = 'ejscreen_version') <- '2.0'
attr(bg,    which = 'ACS') <- '2015-2019'
x = cbind(sapply(bg, function(x) sum(is.na(x)) ))
cbind(sort(x[x[,1] >0,]))

bg21plus <- bg ; rm(bg)
usethis::use_data(bg21plus, overwrite = TRUE)

