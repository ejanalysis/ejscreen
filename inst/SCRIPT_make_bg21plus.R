# creating bg21plus or maybe just call it the new bg21

# merge EJScreen dataset with Demographic subgroups from ACS

library(ejanalysis)
library(ejscreen)

# cbind(sapply(bg21, function(x) sum(is.na(x))))
# 11 bad blockgroups, so replacing bg21 with cleaned one now.
# > xx=cbind(sapply(bg21, function(x) sum(is.na(x))))
# > xx[xx[,1]==11,]
# FIPS.TRACT  FIPS.COUNTY FIPS.ST     ST   statename      REGION  countyname
# 11          11          11          11          11          11          11
# 11 bg in AK got assigned NA as state code because  
#  ejscreen.download() relied on 
#  ejanalysis::addFIPScomponents() to get those, which used 
#  data(lookup.states, package='proxistat') and  ejanalysis::get.county.info
# and those rely on  proxistat::countiesall   
NROW(bg21[is.na(bg21$ST), c(1:9,153:160)]) 
# There are a different 13 bg in AK,SD that were not in proxistat bg.pts list. 
NROW(bg21[ !(bg21$FIPS %in% proxistat::bg.pts$FIPS),1:9]) 



bg21plus <- merge(ejscreen::bg21, ejscreen::bg21DemographicSubgroups2015to2019, all.x = TRUE, by = 'FIPS', suffixes = c('','.duplicatecolumn'))
bg21plus <- bg21plus[ , !grepl('\\.duplicatecolumn', names(bg21plus))]

# # dropped duplicated columns,  pop, mins, pctmin
# intersect(names(bg21), names(bg21DemographicSubgroups2015to2019))
# # [1] "FIPS"   "pop"    "mins"   "pctmin"
#
# Note that only Puerto Rico (FIPS starting with 72) is missing from this ACS dataset.
# while bg21 has PR, so when merged, the PR rows would be NA for pcthisp, etc.
# > dim(ejscreen::bg21)
# [1] 220333    160
# dim(ejscreen::bg21DemographicSubgroups2015to2019)
# [1] 217739     21
# setdiff(substr(bg21$FIPS, 1,2), substr(bg21DemographicSubgroups2015to2019$FIPS,1,2))
# [1] "72"
# > addmargins(table(substr(bg21$FIPS,1,2) != '72'))
# FALSE   TRUE    Sum
# 2594 217739 220333
# > addmargins(table(substr(bg21DemographicSubgroups2015to2019$FIPS,1,2) != '72'))
# TRUE    Sum
# 217739 217739

bg21plus <- bg21plus[bg21plus$ST != 'PR',]

#   usethis::use_data(bg21plus)

names(bg21plus)

usethis::use_data(bg21plus)

