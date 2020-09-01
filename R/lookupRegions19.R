#' @name lookupRegions19
#' @docType data
#' @title The EPA-Region-level 2019 version of the EJSCREEN percentile lookup table.
#' @description
#'   Note the 2018 version of EJSCREEN (released late 2018)
#'     actually uses ACS2016, which is from 2012-2016 (released late 2017).
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'   This is from the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package.
#'   It can be used with for example ejanalysis::lookup.pctile(13, varname.in.lookup.table = 'pm', lookup = lookupUSA19)
#'   It shows what the cutpoints are for each variable at percentiles 0,1,2 through 99, 100.
#'   For example, if the traffic.score is 1000 in a given location,
#'   you can look where that falls in the percentiles and see that 81% of the US population had lower scores:
#'   lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA19)
#'
#' @examples lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA19)
#'     lookup.pctile(c(1000, 3000), varname.in.lookup.table = 'traffic.score',
#'       lookup = lookupStates19, zone = 'NY')
#'       # Those traffic scores are at the 62d and 83d percentiles within NY State (83 percent
#'       # of the NY State population had a traffic score lower than 3000).
#'    \dontrun{
#'     bg <- bg19[sample(1:NROW(bg19), 100), ]
#'     state.pctile.pm <- ejanalysis::lookup.pctile(myvector = bg$pm, varname.in.lookup.table = 'pm',
#'        lookup = lookupStates19, zone = bg$ST)
#'     plot(state.pctile.pm, bg$pctile.pm, pch = '.')
#'     text(state.pctile.pm, bg$pctile.pm, labels = paste(bg$ST, round(bg$pm,1)), cex = 0.8)
#'     abline(0,1)
#'     lookupStates19[lookupStates19$PCTILE == 'mean', c('REGION', 'pm')]
#'     lookupUSA19[lookupUSA19$PCTILE == 'mean', c('REGION', 'pm')]
#'   }
#' @seealso lookupUSA19 lookupRegions19 lookupStates19 \code{\link[ejanalysis]{lookup.pctile}}
#' @details
#'   It was created for this package as follows: \cr\cr
#'     \code{require(ejscreen)} \cr
#'     \code{require(analyze.stuff); require(ejanalysis); require(readr)} \cr
#'      \cr
#'   \cr Get EJSCREEN geodatabase downloaded from public FTP site
#'   \cr as gdb format (zipped)
#'   \cr EJSCREEN_V2019.gdb.zip
#'   \cr then unzipped to
#'   \cr EJSCREEN_V2019.gdb
#'   \cr Opened EJSCREEN_V2019.gdb file in ESRI's ArcGIS
#'   \cr
#'   \cr Opened attribute tables USA, Regions, and States
#'   \cr Exported all records as text format to files named
#'   \cr EJSCREEN_USA_2019_Export_Output.csv, etc.
#'   \cr
#'   \code{ lookupUSA19 <- readr::read_csv('USA_2019_Export_Output.csv') }\cr
#'   \code{ lookupRegions19 <- readr::read_csv('Regions_2019_Export_Output.csv') }\cr
#'   \code{ lookupStates19 <- readr::read_csv('States_2019_Export_Output.csv') }\cr
#'   \cr
#'   \code{ names(lookupStates19)  }\cr
#'   \code{ # [1] "OBJECTID"   "REGION"     "PCTILE"     "MINORPCT"   "LOWINCPCT"  "LESSHSPCT"  "LINGISOPCT" "UNDER5PCT"  "OVER64PCT"  "PRE1960PCT" "VULEOPCT" }\cr
#'   \code{ # [12] "VULSVI6PCT" "DSLPM"      "CANCER"     "RESP"       "PTRAF"      "PWDIS"      "PNPL"       "PRMP"       "PTSDF"      "OZONE"      "PM25" }\cr
#'   \code{ # [23] "D_LDPNT_2"  "LDPNT_D6"   "LDPNT_B2"   "LDPNT_B6"   "LDPNT_P2"   "LDPNT_P6"   "D_DSLPM_2"  "DSLPM_D6"   "DSLPM_B2"   "DSLPM_B6"   "DSLPM_P2" }\cr
#'   \code{ # [34] "DSLPM_P6"   "D_CANCR_2"  "CANCR_D6"   "CANCR_B2"   "CANCR_B6"   "CANCR_P2"   "CANCR_P6"   "D_RESP_2"   "RESP_D6"    "RESP_B2"    "RESP_B6" }\cr
#'   \code{ # [45] "RESP_P2"    "RESP_P6"    "D_PTRAF_2"  "PTRAF_D6"   "PTRAF_B2"   "PTRAF_B6"   "PTRAF_P2"   "PTRAF_P6"   "D_PWDIS_2"  "PWDIS_D6"   "PWDIS_B2" }\cr
#'   \code{ # [56] "PWDIS_B6"   "PWDIS_P2"   "PWDIS_P6"   "D_PNPL_2"   "PNPL_D6"    "PNPL_B2"    "PNPL_B6"    "PNPL_P2"    "PNPL_P6"    "D_PRMP_2"   "PRMP_D6" }\cr
#'   \code{ # [67] "PRMP_B2"    "PRMP_B6"    "PRMP_P2"    "PRMP_P6"    "D_PTSDF_2"  "PTSDF_D6"   "PTSDF_B2"   "PTSDF_B6"   "PTSDF_P2"   "PTSDF_P6"   "D_OZONE_2" }\cr
#'   \code{ # [78] "OZONE_D6"   "OZONE_B2"   "OZONE_B6"   "OZONE_P2"   "OZONE_P6"   "D_PM25_2"   "PM25_D6"    "PM25_B2"    "PM25_B6"    "PM25_P2"    "PM25_P6" } \cr
#'    \cr
#'   \code{ names(lookupUSA19) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupUSA19)) }\cr
#'   \code{ names(lookupRegions19) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupRegions19)) }\cr
#'   \code{ names(lookupStates19) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupStates19)) }\cr
#'   \cr
#'   \code{ # c('','',names(lookupUSA19)) }\cr
#'   \code{ # [1] ""                                  ""                                  "OBJECTID"                          "REGION"                            "PCTILE"                            "pctmin"                            }\cr
#'   \code{ # [7] "pctlowinc"                         "pctlths"                           "pctlingiso"                        "pctunder5"                         "pctover64"                         "pctpre1960"                        }\cr
#'   \code{ # [13] "VSI.eo"                            "VSI.svi6"                          "dpm"                               "cancer"                            "resp"                              "traffic.score"                     }\cr
#'   \code{ # [19] "proximity.npdes"                   "proximity.npl"                     "proximity.rmp"                     "proximity.tsdf"                    "o3"                                "pm"                                }\cr
#'   \code{ # [25] "EJ.DISPARITY.pctpre1960.eo"        "EJ.DISPARITY.pctpre1960.svi6"      "EJ.BURDEN.pctpre1960.eo"           "EJ.BURDEN.pctpre1960.svi6"         "EJ.PCT.pctpre1960.eo"              "EJ.PCT.pctpre1960.svi6"            }\cr
#'   \code{ # [31] "EJ.DISPARITY.dpm.eo"               "EJ.DISPARITY.dpm.svi6"             "EJ.BURDEN.dpm.eo"                  "EJ.BURDEN.dpm.svi6"                "EJ.PCT.dpm.eo"                     "EJ.PCT.dpm.svi6"                   }\cr
#'   \code{ # [37] "EJ.DISPARITY.cancer.eo"            "EJ.DISPARITY.cancer.svi6"          "EJ.BURDEN.cancer.eo"               "EJ.BURDEN.cancer.svi6"             "EJ.PCT.cancer.eo"                  "EJ.PCT.cancer.svi6"                }\cr
#'   \code{ # [43] "EJ.DISPARITY.resp.eo"              "EJ.DISPARITY.resp.svi6"            "EJ.BURDEN.resp.eo"                 "EJ.BURDEN.resp.svi6"               "EJ.PCT.resp.eo"                    "EJ.PCT.resp.svi6"                  }\cr
#'   \code{ # [49] "EJ.DISPARITY.traffic.score.eo"     "EJ.DISPARITY.traffic.score.svi6"   "EJ.BURDEN.traffic.score.eo"        "EJ.BURDEN.traffic.score.svi6"      "EJ.PCT.traffic.score.eo"           "EJ.PCT.traffic.score.svi6"         }\cr
#'   \code{ # [55] "EJ.DISPARITY.proximity.npdes.eo"   "EJ.DISPARITY.proximity.npdes.svi6" "EJ.BURDEN.proximity.npdes.eo"      "EJ.BURDEN.proximity.npdes.svi6"    "EJ.PCT.proximity.npdes.eo"         "EJ.PCT.proximity.npdes.svi6"       }\cr
#'   \code{ # [61] "EJ.DISPARITY.proximity.npl.eo"     "EJ.DISPARITY.proximity.npl.svi6"   "EJ.BURDEN.proximity.npl.eo"        "EJ.BURDEN.proximity.npl.svi6"      "EJ.PCT.proximity.npl.eo"           "EJ.PCT.proximity.npl.svi6"         }\cr
#'   \code{ # [67] "EJ.DISPARITY.proximity.rmp.eo"     "EJ.DISPARITY.proximity.rmp.svi6"   "EJ.BURDEN.proximity.rmp.eo"        "EJ.BURDEN.proximity.rmp.svi6"      "EJ.PCT.proximity.rmp.eo"           "EJ.PCT.proximity.rmp.svi6"         }\cr
#'   \code{ # [73] "EJ.DISPARITY.proximity.tsdf.eo"    "EJ.DISPARITY.proximity.tsdf.svi6"  "EJ.BURDEN.proximity.tsdf.eo"       "EJ.BURDEN.proximity.tsdf.svi6"     "EJ.PCT.proximity.tsdf.eo"          "EJ.PCT.proximity.tsdf.svi6"        }\cr
#'   \code{ # [79] "EJ.DISPARITY.o3.eo"                "EJ.DISPARITY.o3.svi6"              "EJ.BURDEN.o3.eo"                   "EJ.BURDEN.o3.svi6"                 "EJ.PCT.o3.eo"                      "EJ.PCT.o3.svi6"                    }\cr
#'   \code{ # [85] "EJ.DISPARITY.pm.eo"                "EJ.DISPARITY.pm.svi6"              "EJ.BURDEN.pm.eo"                   "EJ.BURDEN.pm.svi6"                 "EJ.PCT.pm.eo"                      "EJ.PCT.pm.svi6"    }\cr
#'   \cr
#'   \code{ lookupUSA19 <- as.data.frame(lookupUSA19) }\cr
#'   \code{ lookupRegions19 <- as.data.frame(lookupRegions19) }\cr
#'   \code{ lookupStates19 <- as.data.frame(lookupStates19) }\cr
#'   \cr
#'   # Then for this package, could get rid of some nonessential fields as follows:  \cr
#'   # (But note svi6 fields - which combine all 6 demog indicators not just 2 - were named in names.d) \cr\cr
#'   #   x <- lookupStates19
#'   \code{#x <- x[ , !grepl(pattern = 'svi6', x = names(x))]} \cr
#'   \code{#x <- x[ , !grepl(pattern = 'pctile\\\\.text', x = names(x))]} \cr
#'   \code{#x <- x[ , !grepl(pattern = 'EJ\\\\.PCT', x = names(x))]} \cr
#'   \code{#x <- x[ , !grepl(pattern = 'EJ\\\\.BURDEN', x = names(x))]} \cr
#'   # lookupStates19 <- x
#'   \cr
#'   \code{ save(lookupUSA19, file = 'lookupUSA19.rdata') }\cr
#'   \code{ save(lookupRegions19, file = 'lookupRegions19.rdata') }\cr
#'   \code{ save(lookupStates19, file = 'lookupStates19.rdata') }\cr
#'
#' @concept datasets
NULL
