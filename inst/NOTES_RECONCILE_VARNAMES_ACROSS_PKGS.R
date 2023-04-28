# NOTES ON WHAT TO UPDATE
# WHEN NEW ENVT OR DEMOG VARIABLES ARE ADDED TO EJSCREEN / PACKAGE

# also see:
#   .../ejscreen/inst/NOTES_UPDATING_VARNAMES_YEARLY.R
#   ...\Downloads\-0 mc notes on weekly reg etc
#   ...\2022-05 TO DO EJ.txt

# update these packages:  EJAM, batch.summarizer, ejscreen, ejscreenapi, or other packages.

# Check what API provides versus old batch tool provided - did counts get created that we need for aggregating by GIS toolbox code but not by API??

#  A June 2023 release?

#  2.11?

#'  EJScreen 2.1 was released circa August 2022.
#'    EJScreen 2.1 uses ACS2020, which is from 2016-2020 (released March 17 2022, delayed from Dec 2021).
#'    It was to be called the 2022 version of EJScreen, and
#'    here is called bg22.
#'
#'  EJScreen 2.0 was released by EPA 2022-02-18 (delayed from mid/late 2021).
#'    EJScreen 2.0 used ACS2019, which is from 2015-2019 (released Dec 2020).
#'    It was to be called the 2021 version, and here is called bg21 as it was to be a late 2021 version.

#'   The 2020 version of EJSCREEN (confusingly released mid 2021 not late 2020)
#'     used ACS2018, which is from 2014-2018 (released Dec 2019).


####################################
# This will be made easier in the future, but for 6/2022 manually added 2 new EJScreen indicators:
# new Environment variable (UST) and
# new Demographic indicator (percent Unemployed)
# as the   raw counts, percents, percentiles, bins, nice/friendly names,
# and metadata like:  units,  sig figs,  etc....
# in files like:  global.R,  ustotals2 ??,  server.R ?? elsewhere??
# in  datasets/ data files:
#   note on NA vs 0: when E is NA, like cancer resp pm in 593 or pm/o3 in 4258,
#   then raw EJ, and pctile of E and EJ, are NA. But bin for E or EJ is set as 0, not NA.
#   That is inconsistent and might be confusing in some situations.
####################################
#
# ejscreen has formulas and colnames and metadata in ejscreenformulas dataset.
#  batch.summarizer has a file map_batch_to_friendly_fieldnames_2021_EJAM.csv
#  and will replace with data
# and probably replace with just ejscreen::ejscreenformulas
#
# userdefined datasets could use that same format maybe.
####################################


# # batch.summarizer package ####################################

#  batch.summarizer has a file   map_batch_to_friendly_fieldnames_2021_EJAM.csv
#  and will replace with data and probably replace with just ejscreen::ejscreenformulas
# but for now the csv file has these for example:
#
# x[grep('traffic',x$newnames), ]     #  ENVIRONMENTAL INDICATOR EXAMPLE
#
# # A tibble: 12 × 11
#   gdbfieldname    oldnames        newnames                               vartype varcategory longname gdblongname example order0 order1 order2
#   <chr>           <chr>           <chr>                                  <chr>   <chr>       <chr>    <chr>       <chr>    <dbl>  <dbl>  <dbl>
# 1 RAW_E_TRAFFIC   RAW_E_TRAFFIC   traffic.score                          raw     Environmen… Traffic… Raw data f… 130          2      1      1
# 2 n               n               us.med.traffic.score                   usmedi… Environmen… Traffic… National m… 0            2      1      2
# 3 N_E_TRAFFIC     N_E_TRAFFIC     us.avg.traffic.score                   usavg   Environmen… Traffic… National a… 110          2      1      2
# 4 R_E_TRAFFIC     R_E_TRAFFIC     region.avg.traffic.score               region… Environmen… Traffic… Regional a… 190          2      1      3
# 5 S_E_TRAFFIC     S_E_TRAFFIC     state.avg.traffic.score                statea… Environmen… Traffic… State aver… 280          2      1      4
# 6 N_E_TRAFFIC_PER N_E_TRAFFIC_PER pctile.traffic.score                   uspcti… Environmen… Traffic… National p… 80           2      1      5
# 7 R_E_TRAFFIC_PER R_E_TRAFFIC_PER region.pctile.traffic.score            region… Environmen… Traffic… Regional p… 63           2      1      6
# 8 S_E_TRAFFIC_PER S_E_TRAFFIC_PER state.pctile.traffic.score             statep… Environmen… Traffic… State perc… 64           2      1      7
# 9 n               n               us.med.EJ.DISPARITY.traffic.score.eo   usmedi… EJ Index    EJ Inde… National m… 0            3      1      2
# 10 N_P_TRAFFIC     N_P_TRAFFIC     pctile.EJ.DISPARITY.traffic.score.eo   uspcti… EJ Index    EJ Inde… National p… 78           3      1      5
# 11 R_P_TRAFFIC     R_P_TRAFFIC     region.pctile.EJ.DISPARITY.traffic.sc… region… EJ Index    EJ Inde… Regional p… 57           3      1      6
# 12 S_P_TRAFFIC     S_P_TRAFFIC     state.pctile.EJ.DISPARITY.traffic.sco… statep… EJ Index    EJ Inde… State perc… 45           3      1      7

# > x[grep('lowinc',x$newnames),]   #  DEMOGRAPHIC INDICATOR EXAMPLE
#
# # A tibble: 8 × 11
#   gdbfieldname   oldnames       newnames                vartype      varcategory longname              gdblongname example order0 order1 order2
#   <chr>          <chr>          <chr>                   <chr>        <chr>       <chr>                 <chr>       <chr>    <dbl>  <dbl>  <dbl>
# 1 RAW_D_INCOME   RAW_D_INCOME   pctlowinc               raw          Demographic Low Income Population Raw data f… 0.19         1      2      1
# 2 n              n              us.med.pctlowinc        usmedian     Demographic Low Income Population National m… 0            1      2      2
# 3 N_D_INCOME     N_D_INCOME     us.avg.pctlowinc        usavg        Demographic Low Income Population National a… 0.34         1      2      2
# 4 R_D_INCOME     R_D_INCOME     region.avg.pctlowinc    regionavg    Demographic Low Income Population Regional a… 0.35         1      2      3
# 5 S_D_INCOME     S_D_INCOME     state.avg.pctlowinc     stateavg     Demographic Low Income Population State aver… 0.25         1      2      4
# 6 N_D_INCOME_PER N_D_INCOME_PER pctile.pctlowinc        uspctile     Demographic Low Income Population National p… 29           1      2      5
# 7 R_D_INCOME_PER R_D_INCOME_PER region.pctile.pctlowinc regionpctile Demographic Low Income Population Regional p… 29           1      2      6
# 8 S_D_INCOME_PER S_D_INCOME_PER state.pctile.pctlowinc  statepctile  Demographic Low Income Population State perc… 41           1      2      7


# # EJAM package ####################################

# data(package='EJAM')

# EJAM::blockgroupstats  EJSCREEN demographic and enviromental indicators for Census block groups,  # created from the ejscreen::bg21 data, for example
# EJAM::regionstats      data.table of 100 percentiles and means, within each EPA Region,
# EJAM::statestats       data.table of 100 percentiles and means, within each state, across all locations
# EJAM::usastats         data.table of 100 percentiles and means, in the USA overall




# # ejscreen package ####################################

#   list.files('./data')  # in ejscreen package
#
#   bg21plus which combines these 2: "bg21.rdata"   "bg21DemographicSubgroups2015to2019.rdata"
#      THESE WERE REMOVED: "lookupRegions20.rdata"   "lookupStates20.rdata"    "lookupUSA20.rdata"
#      REPLACED WITH JUST lookupStates  and  lookupUSA
#
#   "ejscreenformulas.rda"  "ejscreenformulasnoej.rda"
#
#   "esigfigs.RData"  "popupunits.RData"
# "vars.ejscreen.acs.RData"
#
# [11] "names.d.nice.rdata", &  "names.dvars.RData" # now just names.d.rda
# [13] "names.e.nice.RData",  & "names.evars.RData" # now just names.e.rda
# [15] "names.ejvars.RData"      # now just names.ej.rda

# "RRS.county20.rdata"   "RRS.REGIONS20.rdata"  "RRS.ST20.rdata"  "RRS.US20.rdata"


# data(package='ejscreen')    # showing details of variables within the above data files.
#
#   bg21                           EJScreen 2.0 dataset, plus additional variables, minus some nonessential fields
#  bg21DemographicSubgroups2015to2019  Demographic subgroups of race/ethnicity by block group (ACS2015-2019 for bg21 and late 2021v of EJSCREEN)
#
# lookupRegions (not lookupRegions20)   The EPA-Region-level latest version of the EJSCREEN percentile lookup table.
# lookupStates  (not lookupStates20)    The State-level latest version of the EJSCREEN percentile lookup table.
# lookupUSA     (not lookupUSA20)       The nationwide most recent version of the EJSCREEN percentile lookup table.

# ejscreenformulas             EJSCREEN Formulas and Fieldnames
# ejscreenformulasnoej         EJSCREEN Formulas and Fieldnames Excluding EJ Index Formulas
# #      "needed.ejscreen.acs.RData"  -- I do not think this is used anyore anywhere
# needed.ejscreen.acs
# vars.ejscreen.acs

#21# esigfigs                     How many signif digits to show
#
  # Dlist            Fieldnames of demographic columns in ejscreen package data
  # Elist            Fieldnames of environmental indicator columns in ejscreen package data
#
# names.d.nice                            Nicer names for demog fields in ejscreen data
# names.d                    Fieldnames of demographic columns in ejscreen package data
# names.d.bin
# names.d.pctile
# names.d.eo
# names.d.eo.bin
# names.d.eo.pctile
# names.d.subgroups          Fieldnames of demographic columns in ejscreen package data
# names.d.subgroups.count
# names.d.subgroups.pct
#
# names.e.nice                        Nicer names for envt fields in ejscreen data
# names.e                Fieldnames of environmental indicator columns in ejscreen package data
# names.e.bin
# names.e.pctile

# names.ej              Fieldnames of environmental justice indicator columns in ejscreen package data
# names.ej.bin
# names.ej.pctile
# namesall.ej
# namesall.ej.bin
# namesall.ej.pctile
#
# names.ej.burden.eo
# names.ej.burden.eo.bin
# names.ej.burden.eo.pctile
# names.ej.pct.eo
# names.ej.pct.eo.bin
# names.ej.pct.eo.pctile

# popupunits                          Units of measurement for environmental indicators

# RRS.REGIONS (RRS.REGIONS20)  Ratios of mean indicator values across demographic groups by EPA Region
# RRS.ST (RRS.ST20)            Ratios of mean indicator values across demographic groups by State
# RRS.US (RRS.US20)            Ratios of mean indicator values across demographic groups
# RRS.county (RRS.county20)    Ratios of mean indicator values across demographic groups by US County




# > ejscreen::ejscreenformulas[grep('unemp', ejscreenformulas$Rfieldname), 1:5]  #  DEMOGRAPHIC INDICATOR EXAMPLE
#
#      gdbfieldname             Rfieldname acsfieldname                      type                           glossaryfieldname
# 1100  ACSUNEMPBAS         unemployedbase         <NA> Demographic Supplementary Count of denominator for percent unemployed
# 2100   UNEMPLOYED             unemployed         <NA> Demographic Supplementary                  Count of people unemployed
# 3100     UNEMPPCT          pctunemployed         <NA> Demographic Supplementary                          Percent Unemployed
# 610    P_UNEMPPCT   pctile.pctunemployed         <NA> Demographic Supplementary                 Percentile for % unemployed
# 910    B_UNEMPPCT         bin.unemployed         <NA> Demographic Supplementary        Map color bin for percent unemployed
# 1210   T_UNEMPPCT pctile.text.unemployed         <NA> Demographic Supplementary       Map popup text for percent unemployed

# > ejscreen::ejscreenformulas[grep('ust', ejscreenformulas$Rfieldname), 1:5]    #  ENVIRONMENTAL INDICATOR EXAMPLE
#
#      gdbfieldname                      Rfieldname acsfieldname          type                                                   glossaryfieldname
# 482           UST                             ust         <NA> Environmental                                 Underground Storage Tanks Indicator
# 710         P_UST                      pctile.ust         <NA> Environmental                  Percentile for Underground Storage Tanks Indicator
# 1010        B_UST                         bin.ust         <NA> Environmental               Map color bin for Underground Storage Tanks Indicator
# 1310        T_UST                 pctile.text.ust         <NA> Environmental              Map popup text for Underground Storage Tanks Indicator
# 510       D_UST_2             EJ.DISPARITY.ust.eo         <NA>            EJ                    EJ Index for Underground Storage Tanks Indicator
# 810      P_UST_D2      pctile.EJ.DISPARITY.ust.eo         <NA>            EJ     Percentile for EJ Index for Underground Storage Tanks Indicator
# 1110     B_UST_D2         bin.EJ.DISPARITY.ust.eo         <NA>            EJ  Map color bin for EJ Index for Underground Storage Tanks Indicator
# 1410     T_UST_D2 pctile.text.EJ.DISPARITY.ust.eo         <NA>            EJ Map popup text for EJ Index for Underground Storage Tanks Indicator



