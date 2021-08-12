# to do in ejscreen package
# 2020
#
# create and UPDATE THE LOOKUP TABLES LIKE lookupUSA to be from 2020 version not 2019.
# and later 2021v.
# from gdb, or perhaps can replicate via write.wtd.mean...

# ensure bg20 matches July update of 2020v from ftp site.

# get 2021version in late 2021? when available.



# PUERTO RICO IS IN bg20 but not in bg20Demog... and not in lookupUSA mean, percentiles.
#

# > sum(bg20DemographicSubgroups2014to2018$mins) / sum(bg20DemographicSubgroups2014to2018$pop)
# [1] 0.3893486  ***** NO PR BECAUSE MISSING FROM THIS DATASET

# > cbind(ustotals(bg20[bg20$ST != 'PR',]))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3893486  ***** NO PR BECAUSE REMOVEDD

# > cbind(ustotals(bg20))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3956014  ***** with PR

# > sum(bg20$pctmin * bg20$pop) / sum(bg20$pop)
# [1] 0.3956014  ***** with PR

# > tail(lookupUSA20[,1:4],2)
# Error in tail(lookupUSA20[, 1:4], 2) : object 'lookupUSA20' not found
# >

##########3

# > sum(bg19$pctmin * bg19$pop) / sum(bg19$pop)
# [1] 0.3919248  *****

# > cbind(ustotals(bg19))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3919248  ***** why does it not match the lookup table?
#

# > cbind(ustotals(bg19[bg19$ST != 'PR', ]))['PCTMIN.US',]
# $PCTMIN.US
# [1] 0.3853958  *****  IF YOU REMOVE PR, IT MATCHES LOOKUP TABLE MEAN

# > tail(lookupUSA[,1:4],2)
# OBJECTID REGION  PCTILE    pctmin
# 102      102    USA    mean 0.3854359   *****  same as 2019 version, mean is for US minus PR
# 103      103    USA std.dev 0.3096625

# > tail(lookupUSA19[,1:4],2)
# OBJECTID REGION  PCTILE    pctmin
# 102      102    USA    mean 0.3854359  ***** 2019v, mean is for US minus PR
# 103      103    USA std.dev 0.3096625
#########3




  #'   was created for this package via \code{x <- ejscreen::ejscreen.lookuptables(bg20)}



# clarify differences between bg20 vs ejscreen.download() colnames and extra fields, PR, etc.

# ideally merge/ reconcile
#  batch.summarizer pkg's csv file with map of names
# with ejscreen::ejscreenformulas

# bg19$TSDF_CNT AND NPL version colnames in bg19 do not match what ejscreenformulas says... I prefer count.TSDF and count.NPL

# maybe need clean up or update EJSCREEN_columns_explained.csv in inst folder
# but ideally it is just subset of ejscreenformulas


# Shrank bg19 (and bg20) to fit in repo limit of 100MB
# **  had TO KEEP DEMOG SUBGRPS SEPARATELY but ideally would like it all in 1 file or easier to merge
#  and with PR in both or neither? or NA values for PR in demog file so list of FIPS is identical in both.

# check / fix  bg20 if needed (July 2021 update on FTP site might have had changes)
#

#  Check sample dataset if OK to pub

# put it on CRAN not just github


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


