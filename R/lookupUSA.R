#' @name lookupUSA
#' @docType data
#' @title The nationwide most recent version of the EJSCREEN percentile lookup table.
#' @description
#'   Note the 2020 version of EJSCREEN released late 2020 (actually Jan 2021)
#'     actually uses ACS2018, which is from 2014-2018 (released late 2019).
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'   Note the 2018 version of EJSCREEN (released late 2018)
#'     actually uses ACS2016, which is from 2012-2016 (released late 2017).
#'
#'   This is from the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package.
#'   It can be used with for example ejanalysis::lookup.pctile(13, varname.in.lookup.table = 'pm', lookup = lookupUSA19)
#'   It shows what the cutpoints are for each variable at percentiles 0,1,2 through 99, 100.
#'   For example, if the traffic.score is 1000 in a given location,
#'   you can look where that falls in the percentiles and see that 81% of the US population had lower scores:
#'   ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA19)
#'
#' @examples ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA19)
#'     ejanalysis::lookup.pctile(c(1000, 3000), varname.in.lookup.table = 'traffic.score',
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
#' @seealso lookupUSA lookupRegions lookupStates \code{\link[ejanalysis]{lookup.pctile}}
#' @details
#'   It was created for this package from the EJSCREEN geodatabase
#'   \cr downloaded from the EJSCREEN public FTP site as .gdb format (zipped).
#'   \cr A script can be used to import and clean it up from that point:
#'   \cr see SCRIPT_read-downloaded-pctile-lookups.R in the inst folder of this pkg
#'   \cr
#'   \cr The fieldnames in the 2019 version for example: \cr\cr
#'
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
#'
#'
#' @concept datasets
NULL
