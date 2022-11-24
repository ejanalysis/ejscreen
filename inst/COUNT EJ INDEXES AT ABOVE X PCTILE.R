# COUNT ENVT, DEMOG, and EJ INDEXES AT/ABOVE X PCTILE or Raw Cutoffs ####
#    COUNT EJ INDEXES AT ABOVE X PCTILE.R
# maybe Add these useful summary stats to ejscreen block group dataset
# or just calculate them in batch.summarize() code

############################################################################# #
# **** for USEFUL BENCHMARKS SUMMARY see  ####
#   "SUMMARY STATS ON EJScreen2.1 single E and D as high scores - pctiles - ratios.R" FOR SUMMARY OF THIS.

############################################################################# # 
# which blockgroup dataset to add this to? ####

bg <- ejscreen::bg22plus # or EJAM::blockgroupstats  or EJAMejscreendata:: etc

library(EJAM) 

############################################################################# # 
# SEE   ?analyze.stuff::colcounter_summary_all() and its examples too. 

df <- bg[ , ejscreen::names.ej.pctile]
bench <- 5 * (0:20)
a3 <- colcounter_summary_all(df, bench)
a3

 
#  NOTE:  THE MEAN (AVERAGE) IN EJSCREEN LOOKUP TABLES IS NOW THE BLOCKGROUP MEAN 
# NOT THE POPULATION MEAN, SO IT IS NOT THE AVG RESIDENT. IT IS THE AVERAGE BLOCKGROUP.

############################################################################# #
# Function to count SCORES ABOVE BENCHMARK(S) at each place
# 
# colcounter is like analyze.stuff::colcounter   or    analyze.stuff::cols.above.count # but they may not be identical anymore 

colcounter <- function(x, cutoff, or.tied=TRUE, na.rm=TRUE, below=FALSE, one.cut.per.col=FALSE) {
  if (is.null(dim(x))) {numcols <- 1; stop('expected data.frame as x but has only 1 dimension')} else {numcols <- dim(x)[2]}
  if (missing(cutoff)) {
    if (one.cut.per.col) {
      cutoff <- colMeans(x, na.rm = na.rm)
    } else {
      cutoff <- rowMeans(x, na.rm = na.rm)
    }
  }
  if (one.cut.per.col) {
    if (length(cutoff) != NCOL(x)) {stop('length of cutoff should be same as number of columns in x if one.cut.per.col=T')}
    x <- t(as.matrix(x)) # this allows it to compare vector of N cutoffs to N columns
  } else {
    if (length(cutoff) != NROW(x) & length(cutoff) != 1) {stop('length of cutoff should be 1 or same as number of columns in x, if one.cut.per.col=F')}
  }
  if (below) {
    if  (or.tied) { y <- ( x <= cutoff) }
    if (!or.tied) { y <- ( x <  cutoff) }
  } else {
    if  (or.tied) { y <- ( x >= cutoff) }
    if (!or.tied) { y <- ( x >  cutoff) }
  }
  if (one.cut.per.col) {y <- t(y)}
  count.per.row <- rowSums(y, na.rm = na.rm)
  return(count.per.row)
}

# 060371998012
# one place has 12 EJ >=99th percentile: 
# t(ejscreen::bg22[which( analyze.stuff::colcounter(ejscreen::bg22[ , ejscreen::names.ej.pctile], 99) == 12 ), c('FIPS',  'countyname', 'pctlowinc', 'pctmin', ejscreen::names.ej.pctile)])
# 16778                           
# FIPS                                   "060371998012"                  
# countyname                             "Los Angeles County, California"
# pctlowinc                              "0.8923163"                     
# pctmin                                 "0.9871004"                     
# pctile.EJ.DISPARITY.pm.eo              "99"                            
# pctile.EJ.DISPARITY.o3.eo              "99"                            
# pctile.EJ.DISPARITY.cancer.eo          "99"                            
# pctile.EJ.DISPARITY.resp.eo            "99"                            
# pctile.EJ.DISPARITY.dpm.eo             "99"                            
# pctile.EJ.DISPARITY.pctpre1960.eo      "99"                            
# pctile.EJ.DISPARITY.traffic.score.eo   "99"                            
# pctile.EJ.DISPARITY.proximity.npl.eo   "99"                            
# pctile.EJ.DISPARITY.proximity.rmp.eo   "99"                            
# pctile.EJ.DISPARITY.proximity.tsdf.eo  "99"                            
# pctile.EJ.DISPARITY.proximity.npdes.eo "99"                            
# pctile.EJ.DISPARITY.ust.eo             "99"   

############################################################################# #
# get DEMOG percentiles table  ####

keystats_d = EJAM::usastats[, c('PCTILE', EJAM::names_d)]
keystats_d = keystats_d[match( c('mean', 80, 95), keystats_d$PCTILE), ]
keystats_d = keystats_d[ , EJAM::names_d]
# keystats_d = round(keystats_d,3)
rownames(keystats_d) <- c('mean', 80, 95)
keystats_d
############################################################################# #
# get ENVT percentiles table  ####

keystats_e = EJAM::usastats[, c('PCTILE', EJAM::names_e)]
keystats_e = keystats_e[match( c('mean', 80, 95), keystats_e$PCTILE), ]
keystats_e = keystats_e[,EJAM::names_e]
# keystats_e = round(keystats_e,3)
rownames(keystats_e) <- c('mean', 80, 95)


############################################################################# #
# specify DEMOG score benchmarks we could call "high" scores: ####
# 
keystats_d = rbind(keystats_d, meanx2 = keystats_d[1,]*2)
keystats_d = rbind(keystats_d, meanx3 = keystats_d[1,]*3)

  ## **see DEMOG benchmarks as RAW SCORES ####

round(keystats_d, 3)
#        VSI.eo pctmin pctlowinc pctlths pctlingiso pctunder5 pctover64 pctunemployed
# mean    0.347  0.405     0.302   0.116      0.049     0.060     0.161         0.055
# 80      0.561  0.726     0.498   0.196      0.069     0.089     0.244         0.092
# 95      0.789  0.977     0.728   0.366      0.246     0.140     0.375         0.187
# meanx2  0.694  0.810     0.604   0.232      0.097     0.120     0.322         0.109
# meanx3  1.041  1.215     0.906   0.348      0.146     0.180     0.482         0.164

############################################################################# #
# specify ENVT score benchmarks we could call "high" scores: ####
#
#  within 1 mile for RMP/TSDF/NPL
#  >1x US average for PM/O3/cancer risk
#  >2x US average for all others

keystats_e = rbind(keystats_e, meanx2 = keystats_e[1,]*2)
keystats_e = rbind(keystats_e, meanx3 = keystats_e[1,]*3)

#  within 1 mile (proximity score = 0.6213712) for RMP/TSDF/NPL
# > proxistat::convert(1, from = 'miles', towhat = 'km')
# [1] 1.609344 
# score of 1/1.609344 km = 1/1 mile = 0.6213712 score
 
keystats_e <- rbind(miles1 = c(NA,NA,NA,NA,NA,NA,NA,0.6213712,0.6213712,0.6213712,NA,NA), keystats_e)
keystats_e['highcut', c('proximity.npl', 'proximity.tsdf', 'proximity.rmp')] <- 
  keystats_e['miles1', c('proximity.npl', 'proximity.tsdf', 'proximity.rmp')]

#  >1x US average for PM/O3/cancer risk
keystats_e['highcut', c('pm', 'o3', 'cancer')] <-
  keystats_e['mean', c('pm', 'o3', 'cancer')]

#  >2x US average for all others
keystats_e['highcut', c('pctpre1960', 'resp', 'dpm', 'traffic.score', 'proximity.npdes', 'ust')] <-
  keystats_e['meanx2', c('pctpre1960','resp', 'dpm', 'traffic.score', 'proximity.npdes', 'ust')]

## **see ENVT benchmarks as RAW SCORES ####

round(keystats_e, 2)
#            pm     o3 cancer resp  dpm pctpre1960 traffic.score proximity.npl proximity.rmp proximity.tsdf proximity.npdes   ust
# miles1     NA     NA     NA   NA   NA         NA            NA          0.62          0.62           0.62              NA    NA
# mean     8.67  42.47  28.50 0.36 0.29       0.27        755.36          0.13          0.77           2.17           11.73  3.95
# 80       9.69  45.44  29.22 0.40 0.42       0.60        912.88          0.16          1.21           3.20            0.04  5.65
# 95      12.16  56.42  37.93 0.50 0.70       0.86       3154.46          0.50          2.88           9.26            2.20 17.70
# meanx2  17.34  84.95  57.00 0.72 0.59       0.55       1510.73          0.27          1.54           4.34           23.46  7.89
# meanx3  26.01 127.42  85.50 1.08 0.88       0.82       2266.09          0.40          2.31           6.51           35.19 11.84
# highcut  8.67  42.47  28.50 0.72 0.59       0.55       1510.73          0.62          0.62           0.62           23.46  7.89

# What distance or count is US AVERAGE block group  for NPL RMP TSDF?
# [1] 2.3013748 0.4034878 0.1431731
# >  1/meanx2.miles
# [1] 0.4345229 2.4783898 6.9845530
# >   meanx1.per.km = c( 0.13         , 0.77,           2.17 )
# > meanx1.km = 1/ meanx1.per.km
# > meanx1.miles = meanx1.km/1.609344
# > meanx1.miles
# [1] 4.7797784 0.8069756 0.2863462
# > 1/meanx1.miles
# [1] 0.2092147 1.2391949 3.4922765
# > # about 1 at 5 miles, 0.8 miles (just under a mile), 0.28 miles (roughly 1/4-1/3 of a mile)
  
# > # What distance is 2x AVERAGE for NPL RMP TSDF?
#   meanx2.per.km = c(0.27,         1.54,           4.34 )
# meanx2.km = 1/ meanx2.per.km
# meanx2.miles = meanx2.km/1.609344
# meanx2.miles
# [1] 2.3013748 0.4034878 0.1431731
 # 1/meanx2.miles
# [1] 0.43 2.478 6.98 
#
# The US average block group is equivalent of ...
#  about 1 NPL at 5 miles, 1 RMP at just under a mile, 1 TSDF at roughly 1/4-1/3 of a mile. ***
#
# The score that is 2x US avg is equivalent of N sites at distance of x miles:  ****
#  2.3 miles from 1 NPL.
#  0.4 miles (< 1/2 mile) from 1 RMP  or like  **  2-3 RMPs at 1 mile away.**
#  0.14 miles (1/7th of a mile) from 1 TSDF, OR ** 7 TSDFs at 1 mile away.**

############################################################################# #
# AS PERCENTILES ####
# CONVERT TO PERCENTILES
# see EJAM::lookup_pctile
library(EJAM)

# or this simplified version:
lookfun <- function(myvector, varname.in.lookup.table, lookup) {
 # CONVERT raw scores TO PERCENTILES by looking them up in a lookup table of percentiles 0-100
  # simplified version of ejanalysis::lookup.pctile 
  lookup <- lookup[lookup$PCTILE != "std.dev", ] # drop this row if it is there
  lookup <- lookup[lookup$PCTILE != "mean", ] # drop this row if it is there
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

## **see ENVT benchmarks as PERCENTILES ####

keystats_e.pctile <- keystats_e # to get the right form
for (i in 1:12) keystats_e.pctile[,i] <- (lookfun(keystats_e[,i], EJAM::names_e[i], EJAM::usastats))
keystats_e.pctile
#          pm  o3 cancer resp dpm pctpre1960 traffic.score proximity.npl proximity.rmp proximity.tsdf proximity.npdes ust
# miles1   NA  NA     NA   NA  NA         NA            NA            96            64             48              NA  NA
# mean     52  52     76   68  61         55            76            75            69             72              97  72
# 80       80  80     80   80  80         80            80            80            80             80              80  80
# 95       95  95     95   95  95         95            95            95            95             95              95  95
# meanx2   99 100     99   99  92         76            88            90            85             85              98  85
# meanx3  100 100     99   99  97         92            92            93            92             91              98  90
# highcut  52  52     76   99  92         76            88            96            64             48              98  85

 round(keystats_e,2)
#              pm    o3 cancer resp  dpm pctpre1960 traffic.score proximity.npl proximity.rmp proximity.tsdf proximity.npdes   ust
 # miles1     NA     NA     NA   NA   NA         NA            NA          0.62          0.62           0.62              NA    NA
 # mean     8.67  42.47  28.50 0.36 0.29       0.27        755.36          0.13          0.77           2.17           11.73  3.95
 # 80       9.69  45.44  29.22 0.40 0.42       0.60        912.88          0.16          1.21           3.20            0.04  5.65
 # 95      12.16  56.42  37.93 0.50 0.70       0.86       3154.46          0.50          2.88           9.26            2.20 17.70
 # meanx2  17.34  84.95  57.00 0.72 0.59       0.55       1510.73          0.27          1.54           4.34           23.46  7.89
 # meanx3  26.01 127.42  85.50 1.08 0.88       0.82       2266.09          0.40          2.31           6.51           35.19 11.84
 # highcut  8.67  42.47  28.50 0.72 0.59       0.55       1510.73          0.62          0.62           0.62           23.46  7.89
 

## **see DEMOG benchmarks as PERCENTILES ####

# raw scores:   round(keystats_d,3)
keystats_d.pctile <- keystats_d # to get the right form
for (i in 1:length(names_d)) keystats_d.pctile[ , i] <- (lookfun(keystats_d[,i], EJAM::names_d[i], EJAM::usastats))
keystats_d.pctile
# > keystats_d.pctile
#        VSI.eo pctmin pctlowinc pctlths pctlingiso pctunder5 pctover64 pctunemployed
# mean       58     60        54      62         75        59        53            62
# 80         80     80        80      80         80        80        80            80
# 95         95     95        95      95         95        95        95            95

# meanx2     89  * 84*      * 88*      85         84        91        91            84
# meanx3    100  *100*      * 99*      94         89        98        97            93

# ** 40% of US is >avg %POC. 54% of bg have >avg %lowinc.
# *** 2x US avg is 84 - 88 th pctile for %poc and %lowinc (top 12-16% of US blockgroups) ***
# ****3x US avg is top <1% for poc or lowinc, but a little less rare for lingiso.   ***


############################################################################# #
# AS RATIOS ####

## **see ENVT benchmarks as RATIOS ####
# 
ratios.e = round(sapply(keystats_e, function(x) x/x[2]),2) # note mean is second row here but not in demog version
rownames(ratios.e) <- rownames(keystats_e)
ratios.e
#           pm   o3 cancer resp  dpm pctpre1960 traffic.score proximity.npl proximity.rmp proximity.tsdf proximity.npdes  ust
# miles1    NA   NA     NA   NA   NA         NA            NA          4.64          0.81           0.29              NA   NA
# mean    1.00 1.00   1.00 1.00 1.00       1.00          1.00          1.00          1.00           1.00            1.00 1.00

# 80      1.12 1.07   1.03 1.10 1.42       2.20          1.21          1.16          1.58           1.47            0.00 1.43
# 95      1.40 1.33   1.33 1.38 2.39       3.17          4.18          3.76          3.75           4.26            0.19 4.49

# meanx2  2.00 2.00   2.00 2.00 2.00       2.00          2.00          2.00          2.00           2.00            2.00 2.00
# meanx3  3.00 3.00   3.00 3.00 3.00       3.00          3.00          3.00          3.00           3.00            3.00 3.00

# highcut 1.00 1.00   1.00 2.00 2.00       2.00          2.00          4.64          0.81           0.29            2.00 2.00


## **see DEMOG benchmarks as RATIOS ####
  
ratios.d <- round(sapply(keystats_d, function(x) x/x[1]), 3) # note mean 1st row here
rownames(ratios.d) <- rownames(keystats_d)
ratios.d
#        VSI.eo pctmin pctlowinc pctlths pctlingiso pctunder5 pctover64 pctunemployed
 
#        VSI.eo pctmin pctlowinc pctlths pctlingiso pctunder5 pctover64 pctunemployed
# mean    1.000  1.000     1.000   1.000      1.000     1.000     1.000         1.000

# 80      1.618  1.794     1.649   1.688      1.422     1.478     1.519         1.685
# 95      2.274  2.412     2.410   3.157      5.043     2.332     2.334         3.426

# meanx2  2.000  2.000     2.000   2.000      2.000     2.000     2.000         2.000
# meanx3  3.000  3.000     3.000   3.000      3.000     3.000     3.000         3.00
  
  
  # ** Being at 80th pctile bg in US is about 1.6x - 1.8x US avg, for %poc, %lowinc, Demog Indic. *** 
  

############################################ #    
  # Supplementary indexes and life expectancy needed ####
  # we would like to see life expectancy and supplemental Demog Index here too.
############################################################################# #


############################################################################# #
############################################################################# #
# COUNTS OF MULTIPLE ONES >X ####


############################################ #    
  # COUNTS of DEMOG groups >__PCTILE? ####
  #
  # we do not really want to summarize demographics by counting how many of D are high.
  # But that would look like this:
  #
  # 4% of bg have lowinc AND POC at 90th+%ile
  # 16% of bg have lowinc OR POC at 90th+%ile
  # 10% of bg have Demog Indic.  at 90th+%ile
  #
   table(cols.above.count(bg[,names.d.pctile], 80, or.tied = TRUE ))
  #
  #     0     1     2     3     4     5     6     7     8
  # 77160 74413 33357 18924 15295 12771  8132  2242    41
  #
  # round(cumsum(rev(table(cols.above.count(bg[,names.d.pctile], 80,or.tied = TRUE )))) / NROW(bg),2)
  #    8    7    6    5    4    3    2    1    0
  # 0.00 0.01 0.04 0.10 0.16 0.24 0.37 0.68 1.00
  #
  #  68% of bg have 1+/8 demog at 80th+
  #  10% of bg have 5+/8 demog basic at 80th+
  # [1] "VSI.eo"   "pctmin"     "pctlowinc"  "pctlths"   "pctlingiso" "pctunder5"
  # [7] "pctover64"  "pctunemployed"
  
############################################################################# #
# COUNTS of 12 ENVT scores >= Benchmarks ####

mycuts <- as.vector(keystats_e['highcut', ])
# Simple func colcounter previously could not handle one cut per column, so needed to do this:
high <- t(t(as.matrix( bg[ , names_e]) ) >= mycuts) # one cut per column
counthigh <- rowSums(high, na.rm = TRUE)
 

counthigh3 <- colcounter(bg[ , names_e], mycuts, or.tied = TRUE, one.cut.per.col = TRUE)
all.equal(counthigh, counthigh3)

library(ejscreen)
# spot check
# round(t(rbind(bg[z <- sample(1:nrow(bg) , 1) , names_e], mycuts, high[z,])),2)
############################################################################# #



# see count of bg with exactly N/12 high
#
# table(counthigh)
#     0     1     2     3     4     5     6     7     8     9    10    *** 
# 25488 49710 54884 41099 28604 20365 13454  6522  2014   194     1 

## **see count of bg where N+/12 ENVT SCORES "high" ####
#
cumsum(rev(table(counthigh)))
# 10      9      8      7      6      5      4      3      2       1       0 
#  1    195   2209   8731  22185  42550  71154 112253 167137 216,847 242,335 

# **see % of bg where N+/12 ENVT SCORES "high" ####

round(100*cumsum(rev(table(counthigh))) / length(counthigh),0)
   # 10   9   8   7   6   5   4   3   2   1   0 
   #  0   0   1   4   9  18  29  46  69  89 100    

#  *****  only 9% of bg have half (6+)/12 ENV "high", but 90% have any high ***
 

# what counties have 9+ high envt? ####

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
# Baltimore city, Maryland             3 *
# Marion County, Indiana               3 *
# Denver County, Colorado              5 *
# Bergen County, New Jersey            6 *
# Bronx County, New York               8 **
# Montgomery County, Pennsylvania      8 **
# Los Angeles County, California       9 **
# St. Louis city, Missouri            12 ***
# Hamilton County, Ohio               15 ***
# Philadelphia County, Pennsylvania   19  *****
# Cook County, Illinois               88  **********

############################################################################# #
# add column to bg dataset, #of E that are high ####

bgsum <- bg[ , c('FIPS', 'bgid')]

bgsum$counthigh <- counthigh

############################################################################# # 
# COUNT NUM, CUMULATIVE NUM, AND CUMUL PERCENT 
# ABOVE SEVERAL BENCHMARKS
# FOR SEVERAL VARIABLES ALL AT ONCE

mypctiles_cuts <- c(50, 80,90,95,99)
mypctiles_data <- bg[ , names_ej_pctile]

x <- mapply(colcount, mypctiles_data, mypctiles_cuts)
y <- cumsum(x) ?????
  
############################################################################# # 
  
  
############################################################################# #
# COUNT US PERCENTILES - ENVIRONMENTAL ALONE NOT EJ - SCORE HIGH ####

bgsum$counte80up <- colcount(bg[, names_e_pctile], 80)
bgsum$counte90up <- colcount(bg[, names_e_pctile], 90)
bgsum$counte95up <- colcount(bg[, names_e_pctile], 95)
bgsum$counte99up <- colcount(bg[, names_e_pctile], 99)

bgsum$anye80up <- colcount(bg[, names_e_pctile], 80) > 0
bgsum$anye90up <- colcount(bg[, names_e_pctile], 90) > 0
bgsum$anye95up <- colcount(bg[, names_e_pctile], 95) > 0
bgsum$anye99up <- colcount(bg[, names_e_pctile], 99) > 0

############ #
# 80th

# **count of bg with N/12 ENVT >=80th
#
# table(bgsum$counte80up)
# 
#     0     1     2     3     4     5     6     7     8     9    10    11    12 
# 34080 36610 49180 33743 26577 19906 15734 11925  8267  4545  1484   259    25 

## **count of bg with N+/12 ENVT >=80th
#
# cumsum(rev(table(bgsum$counte80up)))
#
# 12     11     10      9      8      7      6      5      4      3      2      1      0 
# 25    284   1768   6313  14580  26505  42239  62145  88722 122465 171645 208255 242335

# **% of bg where N+/12 ENVT >=80 th ####
#
round(100* cumsum(rev(table(bgsum$counte80up)))/nrow(bgsum), 0) 
#
# 12  11  10   9   8   7   6   5   4   3   2   1   0 
#  0   0   1   3   6  11  17  26  37  51  71  86 100 
#
# *** 11% have 7+EJ at 80th+


############ #
# 95

# **count of bg where N/12 ENVT >=95th

# > table(bgsum$counte95up)
# 
#      0      1      2      3      4      5      6      7      8      9     10 
# 143976  45763  27866  11329   6849   3854   1834    671    174     18      1 

# **count of bg where N+/12 ENVT >=95th

cumsum(rev(table(bgsum$counte95up)))
# 10      9      8      7      6      5      4      3      2      1      0 
#  1     19    193    864   2698   6552  13401  24730  52596  98359 242335 
# ****  This shows that 2,698 places have 6+ of the 12 Envt indicators at/above 95th pctile. ***

# **% of bg where N+/12 ENVT >= 95th ####

round(100 * cumsum(rev(table(bgsum$counte95up))) / nrow(bgsum), 0) 






############ #
# 99 

cumsum(rev(table(bgsum$counte99up)))
# 5      4      3      2      1      0 
# 8    132    838   5050  24842 242335 
# 24,842 have 1 or more, and just 8 bg have 5 or more Envt indicators at 99+ percentile.

# **% of bg where N+/12 ENVT >= 99th ####

round(100 * cumsum(rev(table(bgsum$counte99up))) / nrow(bgsum), 0) 










############################################################################# #
############################################################################# #
############################################################################# # 

############################################################################# #
# COUNT US PERCENTILES EJ SCORE HIGH ####

bgsum$countej80up <- colcount(bg[, names_ej_pctile], 80)
bgsum$countej90up <- colcount(bg[, names_ej_pctile], 90)
bgsum$countej95up <- colcount(bg[, names_ej_pctile], 95)
bgsum$countej99up <- colcount(bg[, names_ej_pctile], 99)

bgsum$anyej80up <- colcount(bg[, names_ej_pctile], 80) > 0
bgsum$anyej90up <- colcount(bg[, names_ej_pctile], 90) > 0
bgsum$anyej95up <- colcount(bg[, names_ej_pctile], 95) > 0
bgsum$anyej99up <- colcount(bg[, names_ej_pctile], 99) > 0


# 80 TH EJ 

table(bgsum$counte80up)

#     0     1     2     3     4     5     6     7     8     9    10    11    12
# 34080 36610 49180 33743 26577 19906 15734 11925  8267  4545  1484   259    25


round(100*cumsum(rev(table(bgsum$countej80up))) / nrow(bgsum),1)
#  12    11    10     9     8     7     6     5     4     3     2     1     0 
# 1.3   4.1   7.8  11.3  14.5  17.6  20.5  23.6  26.9  30.3  34.1  39.2 100.0 
# > # about 40% have at least 1 / 12 EJ at 80th+
# ** about 18-20% have 6 or 7+ EJ at 80th+
# about 11% of bg have 9+ EJ at 80+
# about 4% have 11+ EJ at 80+


# 95 TH EJ 

# > table(bgsum$countej95up)
#
#      0      1      2      3      4      5      6      7      8      9     10     11     12
# 207327   7838   5719   4573   3689   3169   2770   2501   2050   1465    863    334     37
cumsum(rev(table(bgsum$countej95up)))




cumsum(rev(table(bgsum$countej80up)))



cumsum(rev(table(bgsum$countej95up)))

# > cumsum(rev(table(bgsum$countej80up)))
#   12     11     10      9      8      7      6      5      4      3      2      1      0 
# 3047  10038  18902  27458  35154  42587  49719  57240  65073  73418  82609  94962 242335 


# **% of bg where N+/12 EJ >= 95th ####




# > cumsum(rev(table(bgsum$countej95up)))
# 12     11     10      9      8      7      6      5      4      3      2      1      0 
# 37    371   1234   2699   4749   7250  10020  13189  16878  21451  27170  35008 242335 






table(bgsum$counte95up)
#
#      0      1      2      3      4      5      6      7      8      9     10
# 143976  45763  27866  11329   6849   3854   1834    671    174     18      1

cumsum(rev(table(bgsum$counte95up)))
# 10      9      8      7      6      5      4      3      2      1      0
#  1     19    193    864   2698   6552  13401  24730  52596  98359 242335
# ****  This shows that 2698 places have 6+ of the 12 Envt indicators at/above 95th pctile. ***

round(100*cumsum(rev(table(bgsum$countej95up))) / nrow(bgsum),1)
#  12    11    10     9     8     7     6     5     4     3     2     1     0 
# 0.0   0.2   0.5   1.1   2.0   3.0   4.1   5.4   7.0   8.9  11.2  14.4 100.0  

# 14% of bg have some EJ at 95th+
# 11% of bg have 2 or more EJ indexes at 95th%ile or higher. ****
# ** Only about 3-4% of bg have 6or7+/12 EJ at 95th+


# 99 TH EJ


cumsum(rev(table(bgsum$counte99up)))
# 5      4      3      2      1      0
# 8    132    838   5050  24842 242335
# 24842 have 1 or more, and 8 have 5 or more Envt indicators at 99+ percentile.


# > table(bgsum$countej99up)
#
#      0      1      2      3      4      5      6      7      8      9     10     11     12
# 231723   4025   2352   1451   1020    685    504    315    162     78     16      3      1




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

############################################################################# #
# COUNT STATE PERCENTILES EJ SCORE HIGH ####
#
# same for State percentiles requires this file:
#  EJAMejscreendata::EJSCREEN_StatePct_with_AS_CNMI_GU_VI

bg22states <- EJAMejscreendata::EJSCREEN_StatePct_with_AS_CNMI_GU_VI
names(bg22states) <- ejscreen::change.fieldnames.ejscreen.csv(names(bg22states))
names(bg22states)


rm(bg)
save.image(file='stats on high E D EJ scores.rda')




