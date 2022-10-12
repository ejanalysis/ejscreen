# COUNT EJ INDEXES AT/ABOVE X PCTILE ####
# add useful summary stats to ejscreen block group dataset

##############################################################################
# which blockgroup dataset to add this to? ####

bg = ejscreen::bg22plus # or EJAM::blockgroupstats  or EJAMejscreendata:: etc

library(EJAM)

# could also add EJAM::bgpts to this ####

##############################################################################
# get percentiles table  ####

statsej = EJAM::usastats[, c('PCTILE', EJAM::names_e)]
keystats = statsej[match( c('mean', 80, 95), statsej$PCTILE), ]
keystats = keystats[,EJAM::names_e]
# keystats = round(keystats,3)
rownames(keystats) <- c('mean', 80, 95)
keystats = rbind(keystats, meanx2 = keystats[1,]*2)
keystats = rbind(miles1 = c(NA,NA,NA,NA,NA,NA,NA,1.609,1.609,1.609,NA,NA), keystats)
keystats

##############################################################################
# specify cutoffs that are high scores: ####
#
#  within 1 mile for RMP/TSDF/NPL
#  >1x US average for PM/O3/cancer risk
#  >2x US average for all others
keystats['highcut', c('proximity.npl', 'proximity.tsdf', 'proximity.rmp')] <- 
  keystats['miles1', c('proximity.npl', 'proximity.tsdf', 'proximity.rmp')]
keystats['highcut', c('pm', 'o3', 'cancer')] <- 
  keystats['mean', c('pm', 'o3', 'cancer')]
keystats['highcut', c('pctpre1960', 'resp', 'dpm', 'traffic.score', 'proximity.npdes', 'ust')] <- 
  keystats['meanx2', c('pctpre1960','resp', 'dpm', 'traffic.score', 'proximity.npdes', 'ust')]
keystats


##############################################################################
# translate those into percentiles ####
#
# library(ejscreen) 
# lookfun <- lookup.pctile.US
# or
lookfun <- function(myvector, varname.in.lookup.table, lookup) {
  # simplified version of ejscreen::lookup.pctile.US
  lookup <- lookup[lookup$PCTILE != "std.dev", ]
  lookup <- lookup[lookup$PCTILE != "mean", ]
  whichinterval <- findInterval(myvector, lookup[ , varname.in.lookup.table])
  belowmin <- (whichinterval == 0)
  if (any(belowmin, na.rm = TRUE)) {
    whichinterval[!is.na(belowmin) & belowmin]  <- 1
    warning('One or more values were below the minimum, or zeroeth percentile, but are reported by this function as being at the 0 percentile.')
  }
  whichinterval[is.na(belowmin)] <- NA
  # returns NA if belowmin is NA
  return(as.numeric(lookup$PCTILE[whichinterval]))
}

keystats.pctile <- keystats # to get the right form
for (i in 1:12) keystats.pctile[,i] <- (lookfun(keystats[,i], EJAM::names_e[i], EJAM::usastats))
keystats.pctile
keystats

##############################################################################
# How many of 12 Envt indicators are at/above the specified cutoffs? ####

# define function to count that
# colcount <- analyze.stuff::cols.above.count # or 
colcount <- function(x, cutoff, or.tied=TRUE, na.rm=TRUE) {
  if  (or.tied) { count.per.row <- rowSums( x >= cutoff, na.rm=na.rm) }
  if (!or.tied) { count.per.row <- rowSums( x >  cutoff, na.rm=na.rm) }
  invisible(count.per.row)
}

mycuts = as.vector(keystats['highcut', ])
# Simple func colcount above cannot handle one cut per column, so need to do this:
high = t(t(as.matrix( bg[ , names_e]) ) >= mycuts) # one cut per column 
counthigh = rowSums(high, na.rm = TRUE)
# or analyze.stuff::cols.above.count()
# mycuts <- unlist(mycuts)
counthigh2 <- cols.above.count(bg[ , names_e], mycuts, or.tied = TRUE, one.cut.per.col = TRUE)
all.equal(counthigh, counthigh2)

library(ejscreen)
# spot check 
# round(t(rbind(bg[z <- sample(1:nrow(bg) , 1) , names_e], mycuts, high[z,])),2)
# table(counthigh)
# counthigh
#     0     1     2     3     4     5     6     7     8     9    10 
# 25488 49710 54884 41099 28604 20365 13454  6522  2014   194     1 

# cbind(sort(table(bg[bg$counthigh>8, 'countyname'])))
# [,1]
# Bernalillo County, New Mexico        1
# Fulton County, Georgia               1
# Kent County, Michigan                1
# Maricopa County, Arizona             1
# Middlesex County, New Jersey         1
# Camden County, New Jersey            2
# DuPage County, Illinois              2
# Franklin County, Ohio                2
# Hudson County, New Jersey            2
# Madison County, Illinois             2
# Riverside County, California         2
# Union County, New Jersey             2
# Baltimore city, Maryland             3
# Marion County, Indiana               3
# Denver County, Colorado              5
# Bergen County, New Jersey            6
# Bronx County, New York               8
# Montgomery County, Pennsylvania      8
# Los Angeles County, California       9
# St. Louis city, Missouri            12
# Hamilton County, Ohio               15
# Philadelphia County, Pennsylvania   19
# Cook County, Illinois               88

##############################################################################
# ADD THAT HIGH SCORES COLUMN TO THE BLOCKGROUP DATASET ####

bgsum <- bg[ , c('FIPS', 'bgid')]

bgsum$counthigh <- counthigh


##############################################################################
# COUNT US PERCENTILES EJ SCORE HIGH ####

bgsum$countej80up <- colcount(bg[, names_ej_pctile], 80)
bgsum$countej90up <- colcount(bg[, names_ej_pctile], 90)
bgsum$countej95up <- colcount(bg[, names_ej_pctile], 95)
bgsum$countej99up <- colcount(bg[, names_ej_pctile], 99)

bgsum$anyej80up <- colcount(bg[, names_ej_pctile], 80) > 0
bgsum$anyej90up <- colcount(bg[, names_ej_pctile], 90) > 0
bgsum$anyej95up <- colcount(bg[, names_ej_pctile], 95) > 0
bgsum$anyej99up <- colcount(bg[, names_ej_pctile], 99) > 0

# > table(bgsum$countej95up)
# 
#      0      1      2      3      4      5      6      7      8      9     10     11     12 
# 207327   7838   5719   4573   3689   3169   2770   2501   2050   1465    863    334     37 

# > table(bgsum$countej99up)
# 
#      0      1      2      3      4      5      6      7      8      9     10     11     12 
# 231723   4025   2352   1451   1020    685    504    315    162     78     16      3      1 


##############################################################################
# COUNT US PERCENTILES - ENVIRONMENTAL ALONE NOT EJ - SCORE HIGH ####

bgsum$counte80up <- colcount(bg[, names_e_pctile], 80)
bgsum$counte90up <- colcount(bg[, names_e_pctile], 90)
bgsum$counte95up <- colcount(bg[, names_e_pctile], 95)
bgsum$counte99up <- colcount(bg[, names_e_pctile], 99)

bgsum$anye80up <- colcount(bg[, names_e_pctile], 80) > 0
bgsum$anye90up <- colcount(bg[, names_e_pctile], 90) > 0
bgsum$anye95up <- colcount(bg[, names_e_pctile], 95) > 0
bgsum$anye99up <- colcount(bg[, names_e_pctile], 99) > 0

# table(bgsum$counte80up)
# 
#     0     1     2     3     4     5     6     7     8     9    10    11    12 
# 34080 36610 49180 33743 26577 19906 15734 11925  8267  4545  1484   259    25 

# > table(bgsum$counte95up)
# 
#      0      1      2      3      4      5      6      7      8      9     10 
# 143976  45763  27866  11329   6849   3854   1834    671    174     18      1 

 cumsum(rev(table(bgsum$counte95up)))
# 10      9      8      7      6      5      4      3      2      1      0 
#  1     19    193    864   2698   6552  13401  24730  52596  98359 242335 
# ****  This shows that 2698 places have 6+ of the 12 Envt indicators at/above 95th pctile. ***
 
 cumsum(rev(table(bgsum$counte99up)))
# 5      4      3      2      1      0 
# 8    132    838   5050  24842 242335 
# 24842 have 1 or more, and 8 have 5 or more Envt indicators at 99+ percentile.

##############################################################################
# 
#  anyej80up       anyej90up       anyej95up       anyej99up        anye80up        anye90up        anye95up      
#  Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode :logical  
#  FALSE:147373    FALSE:185253    FALSE:207327    FALSE:231723    FALSE:34080     FALSE:109082    FALSE:143976   
#  TRUE :94962     TRUE :57082     TRUE :35008     TRUE :10612     TRUE :208255    TRUE :133253    TRUE :98359    
#  anye99up      
#  Mode :logical  
#  FALSE:217493   
#  TRUE :24842    
#  > summary(bgsum[,grep('count',names(bgsum))])
#  counthigh       countej80up      countej90up      countej95up       countej99up        counte80up    
#  Min.   : 0.000   Min.   : 0.000   Min.   : 0.000   Min.   : 0.0000   Min.   : 0.0000   Min.   : 0.000  
#  1st Qu.: 1.000   1st Qu.: 0.000   1st Qu.: 0.000   1st Qu.: 0.0000   1st Qu.: 0.0000   1st Qu.: 1.000  
#  Median : 2.000   Median : 0.000   Median : 0.000   Median : 0.0000   Median : 0.0000   Median : 3.000  
#  Mean   : 2.654   Mean   : 2.312   Mean   : 1.156   Mean   : 0.5779   Mean   : 0.1156   Mean   : 3.074  
#  3rd Qu.: 4.000   3rd Qu.: 4.000   3rd Qu.: 0.000   3rd Qu.: 0.0000   3rd Qu.: 0.0000   3rd Qu.: 5.000  
#  Max.   :10.000   Max.   :12.000   Max.   :12.000   Max.   :12.0000   Max.   :12.0000   Max.   :12.000  
#  counte90up       counte95up        counte99up    
#  Min.   : 0.000   Min.   : 0.0000   Min.   :0.0000  
#  1st Qu.: 0.000   1st Qu.: 0.0000   1st Qu.:0.0000  
#  Median : 1.000   Median : 0.0000   Median :0.0000  
#  Mean   : 1.301   Mean   : 0.8229   Mean   :0.1274  
#  3rd Qu.: 2.000   3rd Qu.: 1.0000   3rd Qu.:0.0000  
#  Max.   :11.000   Max.   :10.0000   Max.   :5.0000  
#  > 

##############################################################################
# COUNT STATE PERCENTILES EJ SCORE HIGH ####
#
# same for State percentiles requires this file:
#  EJAMejscreendata::EJSCREEN_StatePct_with_AS_CNMI_GU_VI

bg22states <- EJAMejscreendata::EJSCREEN_StatePct_with_AS_CNMI_GU_VI
names(bg22states) <- ejscreen::change.fieldnames.ejscreen.csv(names(bg22states))
names(bg22states)
