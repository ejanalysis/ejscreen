# to do in ejscreen package


#  break up ejscreen.download into smaller functions that download, unzip, read, rename, drop fields, add fields


# Clarify differences between bg20  vs  ejscreen.download()
# in terms of colnames and extra columns, rows for PR, etc.

# ******create and UPDATE THE LOOKUP TABLES LIKE lookupUSA lookupStates lookupRegions
#   to be from 2020 version not 2019,
#   (and then also from  2021v when available).
#  Usually just get it from the gdb file on the ftp site (see SCRIPT_read-downloaded-pctile-lookups.R)
# **It also should be possible to replicate those lookup tables using
#   ejscreen::ejscreen.lookuptables()   which in turn relies on
#   ejanalysis::write.wtd.pctiles.by.zone()


#ejscreen::ejscreen.download(justreadname = '~/Dropbox/2021 EJ EPA/2021-02 EJSCREEN 2020v RR/EJSCREEN_2020_USPR.csv')

############ ANNUAL UPDATE ################
# get 2021version dataset in late 2021? when available.
# create bg21.rdata and bg21.R (data and help docs), maybe with ejscreen::ejscreen.download()
# update lookupUSA, states, regions, maybe with ejscreen::ejscreen.lookuptables()
# update default endyear in various functions
###########################################

# Clarify differences between bg20 vs ejscreen.download()
# in terms of colnames and extra columns, rows for PR, etc.

# Ideally merge/ reconcile column names in
#     batch.summarizer pkg's csv file with map of names
#and
#     ejscreen::ejscreenformulas

# bg19$TSDF_CNT AND NPL version colnames in bg19 do not match what ejscreenformulas says... I prefer count.TSDF and count.NPL


# put it on CRAN not just github


# maybe need clean up or update EJSCREEN_columns_explained.csv in inst folder
# but ideally it is just subset of ejscreenformulas


##############
# > dim(bg20)
# [1] 220333    118
# > dim(bg20DemographicSubgroups2014to2018)
# [1] 217739     21

# If possible, get demographic race/ethnic subgroups for Puerto Rico
# Already noted in docs that PUERTO RICO is in bg20 but not in bg20Demog...
# and PR is not in lookupUSA mean, percentiles.
# so it can be confusing:
# > sum(bg20DemographicSubgroups2014to2018$mins) / sum(bg20DemographicSubgroups2014to2018$pop)
# [1] 0.3893486  ***** NO PR BECAUSE MISSING FROM THIS DATASET
#
# > cbind(ustotals(bg20[bg20$ST != 'PR',]))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3893486  ***** NO PR BECAUSE REMOVEDD
#
# > cbind(ustotals(bg20))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3956014  ***** with PR
#
# > sum(bg20$pctmin * bg20$pop) / sum(bg20$pop)
# [1] 0.3956014  ***** with PR
##########
#
# > sum(bg19$pctmin * bg19$pop) / sum(bg19$pop)
# [1] 0.3919248  *****
#
# > cbind(ustotals(bg19))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3919248  ***** why does it not match the lookup table?
#
# > cbind(ustotals(bg19[bg19$ST != 'PR', ]))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3853958  *****  IF YOU REMOVE PR, IT MATCHES LOOKUP TABLE MEAN
#
# > tail(lookupUSA[,1:4],2)
# OBJECTID REGION  PCTILE    pctmin
# 102      102    USA    mean 0.3854359   *****  same as 2019 version, mean is for US minus PR
# 103      103    USA std.dev 0.3096625
#
# > tail(lookupUSA19[,1:4],2)
# OBJECTID REGION  PCTILE    pctmin
# 102      102    USA    mean 0.3854359  ***** 2019v, mean is for US minus PR
# 103      103    USA std.dev 0.3096625
###############################################################


# There had been 13 bad rows in an early version of bg20, because proxistat::countiesall was obsolete and missing 2 new counties FIPS
#'    # HOW THE 13 PROBLEM ROWS WERE 1st manually FIXED IN  bg18, bg19
#'    # and later redid bg20 ??
#'
#'    newfips <- y$FIPS[is.na(y$ST)]
#'    newfips
#'      [1] "021580001001" "021580001002" "021580001003" "021580001004" "461029405001" "461029405002
#'      [7] "461029405003" "461029408001" "461029408002" "461029408003" "461029409001" "461029409002"
#'      [13] "461029409003"
#'    bad <- which(is.na(y$ST))
#'    nastuff <- analyze.stuff::na.check(y[bad,])[ , c('count', 'na')]; nastuff[order(nastuff$na),]
#'    ###  FIPS.TRACT, FIPS.COUNTY ,FIPS.ST, ST, statename, REGION, countyname , lat  , lon
#'
#'    ###### *** TO BE FIXED... CONTINUED...
#'
#'    y[bad] <- bg19[bad,]  # ??
#'
#'    y['FIPS.TRACT'] <- substr(y$FIPS,1,11)
#'    y['FIPS.COUNTY'] <- substr(y$FIPS,1,5)
#'    y['FIPS.ST'] <- substr(y$FIPS,1,2)
#'    y['ST'] <- ejanalysis::get.state.info(substr(y$FIPS,1,2))$ST
#'    y['statename'] <- ejanalysis::get.state.info(substr(y$FIPS,1,2))$statename
#'    y['REGION'] <- ejanalysis::get.state.info(substr(y$FIPS,1,2))$REGION
#'
#'
#'
# ****
# DONE - CHANGE "minority" to "people of color" in glossary (ejscreen::ejscreenformulas and noej version)
# but not the actual Rfieldnames

# DONE I THINK - change names.e, names.d, enames, etc data to remove SVI6 type fields now
# data("names.dvars")
# Dlist[[2]] <- NULL
# names.d <- names.d[!grepl('svi6',names.d,ignore.case = TRUE)]
# # and same for other related variables
# save(Dlist, names.d, names.d.bin, names.d.eo, names.d.eo.bin, names.d.eo.pctile, names.d.pctile, names.d.subgroups, names.d.subgroups.count, names.d.subgroups.pct,
#   file = 'names.dvars.RData')
#
# namesall.ej <- namesall.ej[!grepl('svi6', namesall.ej)]
# namesall.ej.bin <- namesall.ej.bin[!grepl('svi6', namesall.ej.bin)]
# namesall.ej.pctile <- namesall.ej.pctile[!grepl('svi6', namesall.ej.pctile)]
# save(names.ej, names.ej.bin,
#      names.ej.burden.eo, names.ej.burden.eo.bin, names.ej.burden.eo.pctile,
#      names.ej.pctile,
#      names.ej.pct.eo, names.ej.pct.eo.bin, names.ej.pct.eo.pctile,
#      namesall.ej, namesall.ej.bin, namesall.ej.pctile,
#      file = 'names.ejvars.RData')

# DONE I THINK:
# updated name of water indicator
#
# ejscreen::ejscreenformulas$glossaryfieldname <- gsub('Proximity to major', 'Indicator for major', ejscreen::ejscreenformulas$glossaryfieldname)
# ejscreen::ejscreenformulasnoej$glossaryfieldname <- gsub('Proximity to major', 'Indicator for major', ejscreen::ejscreenformulasnoej$glossaryfieldname)
# save(ejscreenformulas, file = 'ejscreenformulas.RData')
# save(ejscreenformulasnoej, file = 'ejscreenformulasnoej.RData')
#
# x = read.csv('inst/EJSCREEN_columns_explained.csv', stringsAsFactors = FALSE)
# x$glossaryfieldname <- gsub('Proximity to major', 'Indicator for major', x$glossaryfieldname)
# write.csv(x, file = 'inst/EJSCREEN_columns_explained.csv', row.names = FALSE)


