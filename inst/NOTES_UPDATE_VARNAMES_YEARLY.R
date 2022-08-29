# Update now and yearly
# updating ejscreen-related packages for EJScreen 2.0 or 2.1

#'  EJScreen 2.1 was released circa August 2022.
#'    EJScreen 2.1 uses ACS2020, which is from 2016-2020 (released March 17 2022, delayed from Dec 2021).
#'    It was to be called the 2022 version of EJScreen, and
#'    here is called bg22.
#'
#'  EJScreen 2.0 was released by EPA 2022-02-18 (delayed from mid/late 2021).
#'    EJScreen 2.0 used ACS2019, which is from 2015-2019 (released Dec 2020).
#'    It was to be called the 2021 version, and here is called bg21 as it was to be a late 2021 version.


##################################### #
# **** list of FIPS codes for counties/ tracts/ block groups/ blocks, and block points ****

# ejanalysis::clean.fips() relies on ejanalysis::get.county.info() which relies on proxistat::countiesall dataset

#   for late 2022, EJScreen 2.1 - ACS 2016-2020,
#   UPDATE all packages to use 2020 Census blocks/fips including
# block points and weights
# and
# list of countynames for proxistat or other pkgs.
#
#   (until mid2022, used either 2010 Census blocks/fips, OR ACS5YR 2020 FIPS? - FOR EJScreen 2.0 - ACS 2015-2019. )

##################################### #
#  - *** lookup table files like lookupStates20 etc.  ******
#
#### nice to have but less critical:
#
#  - Get rid of bg21 and bg21Demog... if bg21plus has both, but note that breaks all code looking for bg21 or help files mentioning it.
#     Maybe keep bg21 as just pure ejscreen csv as downloaded, ftp colnames, etc.

##################################### #
#  - RRS files with ratios of means
# RRS.US etc

##################################### #
#  - ejscreenformulas -
#    ** needs ACS variable numbers details for unemployed and unemployedbase
#    ** need new formulas for EJ Index = E * D
#  - ejscreenformulasnoej - same
#  - vars.ejscreen.acs  - not sure needed, but check and update
#  - needed.ejscreen.acs ? need this at all?
#  - FILE .csv ??



#  sapply( grep('^names', ls(envir = parent.env(globalenv())), value=TRUE), get)

# obsolete to remove:  (done 7/2022)
mustdelete <- c(
  'names.ej.burden.eo',
  'names.ej.burden.eo.pctile',
  'names.ej.burden.eo.bin',
  'names.ej.pct.eo',
  'names.ej.pct.eo.pctile',
  'names.ej.pct.eo.bin'
)
for (thisone in mustdelete) {
  file.remove(paste0('./data/', thisone, '.rda'))
  }
rm(mustdelete, thisone)

# to update: (done 7/2022)
# .BURDEN.
# .PCT.
# namesall.ej    namesall.ej.bin  namesall.ej.pctile
namesall.ej <- namesall.ej[grepl('DISPARITY', namesall.ej)]
namesall.ej.bin  <- namesall.ej.bin[grepl('DISPARITY', namesall.ej.bin)]
namesall.ej.pctile <- namesall.ej.pctile[grepl('DISPARITY', namesall.ej.pctile)]
library(usethis)
use_data(namesall.ej, overwrite = TRUE)
use_data(namesall.ej.pctile, overwrite = TRUE)
use_data(namesall.ej.bin, overwrite = TRUE)




##################################### #
# update variables and names of indicators for EJScreen 2.0 and 2.1
# (ust and pctunemployed were added for 2.0 and nothing else for 2.1?)
# 6/2022 all DONE for EJSCREEN 2.0

##################################### #
# SPECIFY NEW NAMES INFO ####
##################################### #

# ENVIRONMENTAL / EJ INDICATORS

new.e      <- 'ust'
new.e.nice <- 'Underground Storage Tanks (UST) Indicator'
new.e.glossaryfieldname = 'Underground Storage Tanks Indicator'
new.e.gdbfieldname = 'UST'
new.e.popunits <- 'UST indicator' # could be, e.g., ppb
new.esigfigs = 2

# DEMOGRAPHIC INDICATORS

new.d.pct   <- 'pctunemployed'
new.d.nice  <- '% Unemployed'

new.d.info <- data.frame(
  gdbfieldname = c(
    "ACSUNEMPBAS",
    "UNEMPLOYED",
    "UNEMPPCT",
    "P_UNEMPPCT",
    "B_UNEMPPCT",
    "T_UNEMPPCT"
  ),
  Rfieldname = c(
    "unemployedbase",
    "unemployed",
    "pctunemployed",
    "pctile.pctunemployed",
    "bin.unemployed",
    "pctile.text.unemployed"
  ),
  acsfieldname = rep(NA_character_, 6),
  type = rep('Demographic Supplementary', 6),
  glossaryfieldname = c(
    "Count of denominator for percent unemployed",
    "Count of people unemployed",
    "Percent Unemployed",
    "Percentile for % unemployed",
    "Map color bin for percent unemployed",
    "Map popup text for percent unemployed"
  ),
  formula = c(
    NA,
    NA,
    "pctunemployed <- ifelse(unemployedbase==0, 0, as.numeric(unemployed) / unemployedbase)",
    NA,
    NA,
    NA
  ),
  acsfieldnamelong = rep(NA_character_, 6),
  universe = rep(NA_character_, 6)
)
# DEMOG INFO for the ejscreenformulas table:
#     "gdbfieldname"          "Rfieldname" "acsfieldname"      "type"              "glossaryfieldname"       "formula"           "acsfieldnamelong"  "universe"
#
# 1100  ACSUNEMPBAS         unemployedbase         <NA> Demographic Supplementary Count of denominator for percent unemployed
# 2100   UNEMPLOYED             unemployed         <NA> Demographic Supplementary                  Count of people unemployed
# 3100     UNEMPPCT          pctunemployed         <NA> Demographic Supplementary                          Percent Unemployed
# 610    P_UNEMPPCT   pctile.pctunemployed         <NA> Demographic Supplementary                 Percentile for % unemployed
# 910    B_UNEMPPCT         bin.unemployed         <NA> Demographic Supplementary        Map color bin for percent unemployed
# 1210   T_UNEMPPCT pctile.text.unemployed         <NA> Demographic Supplementary       Map popup text for percent unemployed



###################################################################### #
# Update lists of names of variables (based on the specified new names) ####
###################################################################### #

# done

library(ejscreen)
library(usethis)
# usethis::use_data_raw


###################################################################### #
# esigfigs & popupunits - significant digits & units for new ENVT indicator  ####
###################################################################### #

popupunits <- rbind(popupunits, data.frame(evar = new.e, units = new.e.popunits)); popupunits <- unique(popupunits)
use_data(popupunits, overwrite=TRUE)
esigfigs   <- rbind(esigfigs,   data.frame(evar = new.e, sigfigs = new.esigfigs));    esigfigs <- unique(esigfigs)
use_data(esigfigs, overwrite=TRUE)

###################################################################### #
# names.d.nice - nice name to use on graph labels etc. for new indicator  ####
###################################################################### #

names.d.nice <- union(names.d.nice, new.d.nice)
use_data(names.d.nice, overwrite=TRUE)
# These were similar but not identical:

# > ejscreenformulas$glossaryfieldname[match(names.d, ejscreenformulas$Rfieldname)]
# [1] "Demographic Index (based on 2 factors, % low-income and % people of color (aka minority)"
# [2] "% people of color (aka minority)"
# [3] "% low-income (i.e., with income below 2 times poverty level)"
# [4] "% less than high school"
# [5] "% of households (interpreted as individuals) in linguistic isolation"
# [6] "% under age 5"
# [7] "% over age 64"

# > cbind(names.d.nice)  #  THESE ARE VERY SHORT - USEFUL ON GRAPHICS
# names.d.nice
# [1,] "Demog.Ind."
# [2,] "% Low-inc."
# [3,] "% Minority"
# [4,] "% <High School"
# [5,] "% Linguistic Isol."
# [6,] "% < age 5"
# [7,] "% > age 64"

###################################################################### #
# DEMOG  lists of variables related to the new DEMOG indicator  ####
###################################################################### #

#__  names.d  etc ####
names.d <- union(names.d, new.d.pct) ######################### #
names.d.bin    <- paste0('bin.',    names.d)
names.d.pctile <- paste0('pctile.', names.d)
Dlist   <- as.list(names.d)

names.d.eo <- c("pctmin", "pctlowinc")  # ok.  ############## #
names.d.eo.bin     <- paste0('bin.',       names.d.eo)
names.d.eo.pctile  <- paste0('pctile.',    names.d.eo)

names.d.subgroups.count <- c("nhwa", "hisp", "nhba", "nhaa", "nhaiana", "nhnhpia", "nhotheralone", "nhmulti") # done (names.dvars)
names.d.subgroups.pct  <- paste0('pct', names.d.subgroups.count) # done (names.dvars)
names.d.subgroups <- names.d.subgroups.pct  # done (names.dvars)

# (names.dvars)   : *************************************************************************
usethis::use_data( # done ################################ #
  names.d ,
  names.d.bin ,
  names.d.pctile    ,
  Dlist,
  names.d.eo   ,
  names.d.eo.bin  ,
  names.d.eo.pctile ,
  names.d.subgroups.count ,
  names.d.subgroups.pct  ,
  names.d.subgroups
)



###################################################################### #
# ENVT & EJ lists of variable namess ####
# related to the new ENVT indicator  ### #
# had been saved in names.evars.RData and names.ejvars.RData
# now each is in its own .rda file
###################################################################### #

###################################################################### #
# names.e.nice - nice name to use on graph labels etc. for new ENVT indicator  ####
###################################################################### #
# names.e.nice <- c(names.e.nice, 'Underground storage tanks (UST) indicator')
names.e.nice <- union(names.e.nice, new.e.nice)
use_data(names.e.nice, overwrite=TRUE)
# or
# names.e.nice <- ejscreenformulas$glossaryfieldname[match(names.e, ejscreenformulas$Rfieldname)]

# These were similar but not identical:  - NEITHER IS ALWAYS VERY SHORT

# > names.e.nice
# [1] "PM2.5 level in air"
# [2] "Ozone level in air"
# [3] "Air toxics cancer risk"
# [4] "Air toxics respiratory hazard index"
# [5] "Diesel particulate matter level in air"
# [6] "% pre-1960 housing (lead paint indicator)"
# [7] "Traffic proximity and volume"
# [8] "Proximity to National Priorities List (NPL) sites"
# [9] "Proximity to Risk Management Plan (RMP) facilities"
# [10] "Proximity to Treatment Storage and Disposal (TSDF) facilities"
# [11] "Proximity to major direct dischargers to water"
# had not add it yet here

# > ejscreenformulas$glossaryfieldname[match(names.e, ejscreenformulas$Rfieldname)]
# [1] "PM2.5 ug/m3 in air"
# [2] "Ozone ppm in air"
# [3] "Air toxics cancer risk per mill."
# [4] "Air toxics respiratory hazard index"
# [5] "Diesel particulate matter level in air"
# [6] "% pre-1960 housing (lead paint indicator)"
# [7] "Traffic proximity and volume"
# [8] "Proximity to National Priorities List (NPL) sites"
# [9] "Proximity to Risk Management Plan (RMP) facilities"
# [10] "Proximity to Treatment Storage and Disposal (TSDF) facilities"
# [11] "Indicator for major direct dischargers to water"
# [12] "Underground Storage Tanks Indicator"  ### #


#__ related to  names.e  ####
names.e        <- union(names.e, new.e) # done ########## ###################### #
names.e.bin    <- paste0('bin.',    names.e)
names.e.pctile <- paste0('pctile.', names.e)
Elist <- as.list(names.e)
# names.ejvars
usethis::use_data( # done ################################ #
  names.e ,
  names.e.bin ,
  names.e.pctile,
  Elist
)




###################################################################### #

#__ names.ej etc   ####
names.ej <- paste0('EJ.DISPARITY.',   names.e, '.eo')
names.ej.bin     <- paste0('bin.',    names.ej)
names.ej.pctile  <- paste0('pctile.', names.ej)
## obsolete:
names.ej.burden.eo <- gsub('DISPARITY', 'BURDEN', names.ej)    # obsolete (names.ejvars)
names.ej.burden.eo.bin <- paste0('bin.', names.ej.burden.eo)    # obsolete (names.ejvars)
names.ej.burden.eo.pctile    # obsolete (names.ejvars)
names.ej.pct.eo <- gsub('DISPARITY', 'PCT', names.ej)   # obsolete (names.ejvars)
names.ej.pct.eo.bin <- paste0('bin.', names.ej.pct.eo)   # obsolete (names.ejvars)
names.ej.pct.eo.pctile   <- paste0('pctile.', names.ej.pct.eo)  # obsolete (names.ejvars)
namesall.ej <- c(names.ej, names.ej.burden.eo, names.ej.pct.eo)  # obsolete
namesall.ej.bin <- paste0('bin.', namesall.ej)  # obsolete
namesall.ej.pctile <- paste0('pctile.', namesall.ej)  # obsolete

usethis::use_data(  # done ################################ #

  names.ej ,
  names.ej.bin ,
  names.ej.burden.eo ,
  names.ej.burden.eo.bin ,
  names.ej.burden.eo.pctile ,
  names.ej.pct.eo ,
  names.ej.pct.eo.bin  ,
  names.ej.pct.eo.pctile ,
  names.ej.pctile ,
  namesall.ej  ,
  namesall.ej.bin   ,
  namesall.ej.pctile
)

# use_data()  # cannot put several in one data file


################################################################ #
# ACS VARIABLES needed ####
################################################################ #

#   variables needed template.csv
#
#??? needed.ejscreen.acs  # NEED TO ADD B23025 UNEMPLOYED AND DENOMINATOR FOR THIS
# use_data(needed.ejscreen.acs, overwrite=TRUE)

#
#     prior to 2022 and EJScreen 2.0, the ACS Summary File tables used were
#       "B01001" "B03002" "B15002" "B16001" "B16002" "B25034" "C17002"
#      in EJScreen 2.0 (mid 2022),  they are
#         c("B01001", "B03002", "B15002", "C16002", "C17002", "B25034", 'B23025')
#            added B23025 unemployement and lingiso info moved to c16002
#   #C17002  RATIO OF INCOME TO POVERTY LEVEL IN THE PAST 12 MONTHS
#
#  # NOTE ACS table C16002 (not B16002 not B16004)
# C16002 replaced B16004 that was older ACS source for what had been called linguistic isolation, now called limited English speaking households.
#
# New Tables in ACS SF 2016-2020
#            C16002  HOUSEHOLD LANGUAGE BY HOUSEHOLD LIMITED ENGLISH SPEAKING STATUS
#     https://data.census.gov/cedsci/table?text=c16002&tid=ACSDT5Y2020.C16002
# https://www.census.gov/programs-surveys/acs/technical-documentation/table-and-geography-changes/2020/5-year.html
# Language [ejscreen had been using B16002, but that has been renamed as C16002, so code updates need to reflect that]
# A new Collapsed Table C16002 provides household-level language estimates for four non-English language categories.
# The format of table C16002 is the same as table B16002 from 2015 and before.  For more information, view the 2016 Language Tables Update user note.
# Modified Tables -  Language
# The rows presented in Base Tables B16001 and C16001 have been updated to reflect the most commonly spoken languages in 2016. For more information, view the 2016 Language Tables Update user note.
# Detailed Table B16001 provides individual-level language estimates for 42 non-English language categories, tabulated by English-speaking ability.  New geographical restrictions have been applied to this table to protect data privacy for the speakers of smaller languages.  Areas published include: Nation (010), States (040), Metropolitan Statistical Area-Metropolitan Divisions (341), Combined Statistical Areas (330), Congressional Districts (500), and Public Use Microdata Areas (PUMAs) (795).  Learn more in the 2016 Language Tables Update user note.
# Collapsed Table C16001 provides individual-level language estimates for twelve non-English language categories, tabulated by English-speaking ability.
# Detailed Table B16002 has been renamed to C16002.

# needed.ejscreen.acs
# seq  table varnum  table.var                                                      varname colnum keep
# 1     2 B01001      1 B01001.001                                             Total population      1    Y
# 2     2 B01001      2 B01001.002                                                        Male:      2    0
# 3     2 B01001      3 B01001.003                                                Under 5 years      3    Y
# 4     2 B01001      4 B01001.004                                                 5 to 9 years      4    Y

#???   vars.ejscreen.acs  # NEED TO ADD UNEMPLOYED AND DENOMINATOR FOR THIS - B23025
# use_data(vars.ejscreen.acs, overwrite=TRUE)
#
# needed.ejscreen.acs
# vars.ejscreen.acs

# ejscreenformulas             EJSCREEN Formulas and Fieldnames
# ejscreenformulasnoej         EJSCREEN Formulas and Fieldnames Excluding EJ Index Formulas
# #      "needed.ejscreen.acs.RData"  -- I do not think this is used anyore anywhere

###################################################################### #
# FORMULAS: ejscreenformulas data file  ####
###################################################################### #

#??? need to add rows for each new variable, in ejscreenformulas (and the noej version of that)
#
# names(ejscreenformulas)
# [1] "gdbfieldname"      "Rfieldname"        "acsfieldname"      "type"              "glossaryfieldname"
# [6] "formula"           "acsfieldnamelong"  "universe"
#

##################################### #
#__ ENVT: Add rows to ejscreenformulas for a new environmental indicator and its EJ index ####
##################################### #

# ENVIRONMENTAL INDICATOR

# ejscreenformulas[ grepl('ust', ejscreenformulas$Rfieldname), ]
#
#      gdbfieldname                      Rfieldname acsfieldname          type
# 482           UST                             ust         <NA> Environmental
# 710         P_UST                      pctile.ust         <NA> Environmental
# 1010        B_UST                         bin.ust         <NA> Environmental
# 1310        T_UST                 pctile.text.ust         <NA> Environmental
# 510       D_UST_2             EJ.DISPARITY.ust.eo         <NA>            EJ
# 810      P_UST_D2      pctile.EJ.DISPARITY.ust.eo         <NA>            EJ
# 1110     B_UST_D2         bin.EJ.DISPARITY.ust.eo         <NA>            EJ
# 1410     T_UST_D2 pctile.text.EJ.DISPARITY.ust.eo         <NA>            EJ

#                                                          glossaryfieldname                                        formula acsfieldnamelong
#   482                                  Underground Storage Tanks Indicator                                           <NA>             <NA>
#   710                   Percentile for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1010               Map color bin for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1310              Map popup text for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   510                     EJ Index for Underground Storage Tanks Indicator EJ.DISPARITY.ust.eo <-            VDI.eo * ust             <NA>
#   810      Percentile for EJ Index for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1110  Map color bin for EJ Index for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1410 Map popup text for EJ Index for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   universe
# 482      <NA>
#   710      <NA>
#   1010     <NA>
#   1310     <NA>
#   510      <NA>
#   810      <NA>
#   1110     <NA>
#   1410     <NA>
#

ejscreenformulas.newrows <- data.frame(matrix(NA, nrow = 8, ncol = NCOL(ejscreenformulas)))
names(ejscreenformulas.newrows) <- names(ejscreenformulas)
newg <- new.e.gdbfieldname
ejscreenformulas.newrows$gdbfieldname <- c(newg, paste0("P_",newg), paste0("B_",newg), paste0("T_",newg), paste0("D_",newg,"_2"), paste0("P_",newg,"_D2"), paste0("B_",newg,"_D2"), paste0("T_",newg,"_D2"))
ejscreenformulas.newrows$Rfieldname <- c(new.e, paste0(c('pctile.', 'bin.', 'pctile.text.', 'EJ.DISPARITY.', 'pctile.EJ.DISPARITY.', 'bin.EJ.DISPARITY.', 'pctile.text.EJ.DISPARITY.'), new.e))
ejscreenformulas.newrows$Rfieldname <- gsub('(DISPARITY\\..*)','\\1.eo', ejscreenformulas.newrows$Rfieldname)
ejscreenformulas.newrows$type <- c(rep('Environmental',4), rep('EJ', 4))
ejscreenformulas.newrows$glossaryfieldname <- paste0(
  c('', "Percentile for ", "Map color bin for ", "Map popup text for ", "EJ Index for ", "Percentile for EJ Index for ",
    "Map color bin for EJ Index for ", "Map popup text for EJ Index for "), new.e.nice)

# edit/fix the new rows to be added to the info table called ejscreenformulas
ejscreenformulas.newrows <- edit(ejscreenformulas.newrows)
warning('make sure this is right')
#
ejscreenformulas <- rbind(ejscreenformulas, ejscreenformulas.newrows)
use_data(ejscreenformulas)   # do this manually or carefully ##################### #

##################################### #
#__ DEMOG: Add rows to ejscreenformulas for a new Demographic indicator ####
##################################### #

# > ejscreenformulas[grep('unemp', ejscreenformulas$Rfieldname), ]

#      gdbfieldname             Rfieldname acsfieldname                      type                           glossaryfieldname

# 1100  ACSUNEMPBAS         unemployedbase         <NA> Demographic Supplementary Count of denominator for percent unemployed
# 2100   UNEMPLOYED             unemployed         <NA> Demographic Supplementary                  Count of people unemployed
# 3100     UNEMPPCT          pctunemployed         <NA> Demographic Supplementary                          Percent Unemployed
# 610    P_UNEMPPCT   pctile.pctunemployed         <NA> Demographic Supplementary                 Percentile for % unemployed
# 910    B_UNEMPPCT         bin.unemployed         <NA> Demographic Supplementary        Map color bin for percent unemployed
# 1210   T_UNEMPPCT pctile.text.unemployed         <NA> Demographic Supplementary       Map popup text for percent unemployed

#                                                                                       formula acsfieldnamelong universe
#   1100                                                                                   <NA>             <NA>     <NA>
#   2100                                                                                   <NA>             <NA>     <NA>
#   3100 pctunemployed <- ifelse(unemployedbase==0, 0, as.numeric(unemployed) / unemployedbase)             <NA>     <NA>
#   610                                                                                    <NA>             <NA>     <NA>
#   910                                                                                    <NA>             <NA>     <NA>
#   1210                                                                                   <NA>             <NA>     <NA>
#

# ejscreenformulas.newrows <- data.frame(matrix(NA, nrow = 8, ncol = NCOL(ejscreenformulas)))
# names(ejscreenformulas.newrows) <- names(ejscreenformulas)
ejscreenformulas.newrows <- new.d.info


# edit/fix the new rows to be added to the info table called ejscreenformulas
ejscreenformulas.newrows <- edit(ejscreenformulas.newrows)
warning('make sure this is right')
#
ejscreenformulas <- rbind(ejscreenformulas, ejscreenformulas.newrows)
use_data(ejscreenformulas)   # do this manually or carefully ##################### #

###################################################################### #

