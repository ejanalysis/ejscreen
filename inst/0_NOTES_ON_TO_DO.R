# to do in ejscreen package
# 2020

# Shrink bg19 (and bg20) to fit in repo limit of 100MB  !!!
# **  HAVE TO KEEP DEMOG SUBGRPS SEPARATELY
# ** need redo documentation if so.
# ** maybe bg19 or bg20  has to be only subset of what is on ftp site
# (e.g. already cut popup text fields)
# and the extra fields like geo and flag and demog subgroups have to be in a
# separate bg19extra that has the same length and sort order by FIPS so it is easy to merge or just use in parallel

# add bg20 when available
# I already created documentation for it but not .rdata file yet
#
# Note:   For most of 2020 (through at least September),
#     the newest EJSCREEN version available is the
#     2019 release of EJSCREEN, released in late 2019, which
#     uses demographic data released in late 2018,
#     covering the 5 years through 2017
#     (2013-2017 ACS 5-year summary file from Census).


#  Check sample dataset if OK to pub

#  Make it a public repo again

# put it on CRAN not just github

# ideally merge/ reconcile
 #  batch.summarizer pkg's csv file with map of names
 # with ejscreen::ejscreenformulas

# bg19$TSDF_CNT AND NPL version colnames in bg19 do not match what ejscreenformulas says... I prefer count.TSDF and count.NPL

# maybe need clean up or update EJSCREEN_columns_explained.csv in inst folder
# but ideally it is just subset of ejscreenformulas

# decide if really need to maintain files for older versions or only latest one


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


