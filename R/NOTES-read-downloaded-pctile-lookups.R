# NOTES ON HOW TO IMPORT
# EJSCREEN lookup tables of percentile values
# that have been downloaded from EJSCREEN FTP site as gdb (geodatabase)
# opened in ESRI ArcGIS,
# attribute tables exported as text format to csv files

# Then read into R like this:

if (1 == 0) {
  # does not execute this code when it sources all in package
  require(readr)

  setwd('~/../Desktop/EJ 2018 all work/EJSCREEN 2019 DATA')
  lookupUSA19 <- readr::read_csv('USA_2019_Export_Output.csv')
  lookupRegions19 <- readr::read_csv('Regions_2019_Export_Output.csv')
  lookupStates19 <- readr::read_csv('States_2019_Export_Output.csv')

  # names(lookupStates19)
  # [1] "OBJECTID"   "REGION"     "PCTILE"     "MINORPCT"   "LOWINCPCT"  "LESSHSPCT"  "LINGISOPCT" "UNDER5PCT"  "OVER64PCT"  "PRE1960PCT" "VULEOPCT"
  # [12] "VULSVI6PCT" "DSLPM"      "CANCER"     "RESP"       "PTRAF"      "PWDIS"      "PNPL"       "PRMP"       "PTSDF"      "OZONE"      "PM25"
  # [23] "D_LDPNT_2"  "LDPNT_D6"   "LDPNT_B2"   "LDPNT_B6"   "LDPNT_P2"   "LDPNT_P6"   "D_DSLPM_2"  "DSLPM_D6"   "DSLPM_B2"   "DSLPM_B6"   "DSLPM_P2"
  # [34] "DSLPM_P6"   "D_CANCR_2"  "CANCR_D6"   "CANCR_B2"   "CANCR_B6"   "CANCR_P2"   "CANCR_P6"   "D_RESP_2"   "RESP_D6"    "RESP_B2"    "RESP_B6"
  # [45] "RESP_P2"    "RESP_P6"    "D_PTRAF_2"  "PTRAF_D6"   "PTRAF_B2"   "PTRAF_B6"   "PTRAF_P2"   "PTRAF_P6"   "D_PWDIS_2"  "PWDIS_D6"   "PWDIS_B2"
  # [56] "PWDIS_B6"   "PWDIS_P2"   "PWDIS_P6"   "D_PNPL_2"   "PNPL_D6"    "PNPL_B2"    "PNPL_B6"    "PNPL_P2"    "PNPL_P6"    "D_PRMP_2"   "PRMP_D6"
  # [67] "PRMP_B2"    "PRMP_B6"    "PRMP_P2"    "PRMP_P6"    "D_PTSDF_2"  "PTSDF_D6"   "PTSDF_B2"   "PTSDF_B6"   "PTSDF_P2"   "PTSDF_P6"   "D_OZONE_2"
  # [78] "OZONE_D6"   "OZONE_B2"   "OZONE_B6"   "OZONE_P2"   "OZONE_P6"   "D_PM25_2"   "PM25_D6"    "PM25_B2"    "PM25_B6"    "PM25_P2"    "PM25_P6"

names(lookupUSA19) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupUSA19))
names(lookupRegions19) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupRegions19))
names(lookupStates19) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupStates19))
#
#  names(lookupUSA19)
#  c('','',names(lookupUSA19))
#  [1] ""                                  ""                                  "OBJECTID"                          "REGION"                            "PCTILE"                            "pctmin"
#  [7] "pctlowinc"                         "pctlths"                           "pctlingiso"                        "pctunder5"                         "pctover64"                         "pctpre1960"
#  [13] "VSI.eo"                            "VSI.svi6"                          "dpm"                               "cancer"                            "resp"                              "traffic.score"
#  [19] "proximity.npdes"                   "proximity.npl"                     "proximity.rmp"                     "proximity.tsdf"                    "o3"                                "pm"
#  [25] "EJ.DISPARITY.pctpre1960.eo"        "EJ.DISPARITY.pctpre1960.svi6"      "EJ.BURDEN.pctpre1960.eo"           "EJ.BURDEN.pctpre1960.svi6"         "EJ.PCT.pctpre1960.eo"              "EJ.PCT.pctpre1960.svi6"
#  [31] "EJ.DISPARITY.dpm.eo"               "EJ.DISPARITY.dpm.svi6"             "EJ.BURDEN.dpm.eo"                  "EJ.BURDEN.dpm.svi6"                "EJ.PCT.dpm.eo"                     "EJ.PCT.dpm.svi6"
#  [37] "EJ.DISPARITY.cancer.eo"            "EJ.DISPARITY.cancer.svi6"          "EJ.BURDEN.cancer.eo"               "EJ.BURDEN.cancer.svi6"             "EJ.PCT.cancer.eo"                  "EJ.PCT.cancer.svi6"
#  [43] "EJ.DISPARITY.resp.eo"              "EJ.DISPARITY.resp.svi6"            "EJ.BURDEN.resp.eo"                 "EJ.BURDEN.resp.svi6"               "EJ.PCT.resp.eo"                    "EJ.PCT.resp.svi6"
#  [49] "EJ.DISPARITY.traffic.score.eo"     "EJ.DISPARITY.traffic.score.svi6"   "EJ.BURDEN.traffic.score.eo"        "EJ.BURDEN.traffic.score.svi6"      "EJ.PCT.traffic.score.eo"           "EJ.PCT.traffic.score.svi6"
#  [55] "EJ.DISPARITY.proximity.npdes.eo"   "EJ.DISPARITY.proximity.npdes.svi6" "EJ.BURDEN.proximity.npdes.eo"      "EJ.BURDEN.proximity.npdes.svi6"    "EJ.PCT.proximity.npdes.eo"         "EJ.PCT.proximity.npdes.svi6"
#  [61] "EJ.DISPARITY.proximity.npl.eo"     "EJ.DISPARITY.proximity.npl.svi6"   "EJ.BURDEN.proximity.npl.eo"        "EJ.BURDEN.proximity.npl.svi6"      "EJ.PCT.proximity.npl.eo"           "EJ.PCT.proximity.npl.svi6"
#  [67] "EJ.DISPARITY.proximity.rmp.eo"     "EJ.DISPARITY.proximity.rmp.svi6"   "EJ.BURDEN.proximity.rmp.eo"        "EJ.BURDEN.proximity.rmp.svi6"      "EJ.PCT.proximity.rmp.eo"           "EJ.PCT.proximity.rmp.svi6"
#  [73] "EJ.DISPARITY.proximity.tsdf.eo"    "EJ.DISPARITY.proximity.tsdf.svi6"  "EJ.BURDEN.proximity.tsdf.eo"       "EJ.BURDEN.proximity.tsdf.svi6"     "EJ.PCT.proximity.tsdf.eo"          "EJ.PCT.proximity.tsdf.svi6"
#  [79] "EJ.DISPARITY.o3.eo"                "EJ.DISPARITY.o3.svi6"              "EJ.BURDEN.o3.eo"                   "EJ.BURDEN.o3.svi6"                 "EJ.PCT.o3.eo"                      "EJ.PCT.o3.svi6"
#  [85] "EJ.DISPARITY.pm.eo"                "EJ.DISPARITY.pm.svi6"              "EJ.BURDEN.pm.eo"                   "EJ.BURDEN.pm.svi6"                 "EJ.PCT.pm.eo"                      "EJ.PCT.pm.svi6"

lookupUSA19 <- as.data.frame(lookupUSA19)
lookupRegions19 <- as.data.frame(lookupRegions19)
lookupStates19 <- as.data.frame(lookupStates19)

save(lookupUSA19, file = 'lookupUSA19.rdata')
save(lookupRegions19, file = 'lookupRegions19.rdata')
save(lookupStates19, file = 'lookupStates19.rdata')

lookup.pctile(myvector = 3:25, varname.in.lookup.table = 'pm', lookup = lookupStates19, zone = 'NY')




}
