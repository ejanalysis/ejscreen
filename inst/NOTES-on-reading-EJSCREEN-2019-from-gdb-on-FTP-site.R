#
# NOTES ON READING THE EJSCREEN 2019 DATASET FROM THE FTP SITE GDB FILE.
# Process by which bg19 dataset created for R package ejscreen:
#

# BUT MUCH OF THIS DUPLICATES NOTES IN bg19.R documentation and
# also what is done by  ejscreen.download()
#
# AND MAY NEED TO SPLIT OFF EXTRA DEMOGRAPHIC ETC INFO FROM essential fields in FTP version, so <100MB .rdata
#

if (1==0) {
  setwd(~/Downloads)
  # See https://www.epa.gov/ejscreen/download-ejscreen-data
  #   and  ftp://newftp.epa.gov/EJSCREEN/
  #   EJSCREEN_2019_USPR.csv.zip  is approx 300 MB
  utils::download.file(url = 'ftp://newftp.epa.gov/EJSCREEN/2019/EJSCREEN_2019_USPR.csv.zip', destfile = 'EJSCREEN_2019_USPR.csv.zip')
  utils::unzip('EJSCREEN_2019_USPR.csv.zip') # zip is approx 300MB, csv approx 764 MB
  bg19ftp <- readr::read_csv('EJSCREEN_2019_USPR.csv', na = 'None') # The word None was used for missing or not applicable
  # bg19 <- read.csv('EJSCREEN_2019_USPR.csv', stringsAsFactors = F) # too slow
  # could cleanup:
  #  file.remove('EJSCREEN_2019_USPR.csv.zip')
  #  file.remove('EJSCREEN_2019_USPR.csv')
  names(bg19ftp) <- ejscreen::change.fieldnames.ejscreen.csv(names(bg19ftp))
  # the rdata file is still 300MB if saved with all the columns we do not really need
  # remove columns that are pctile.text popups in the webapp
  bg19ftp <- bg19ftp[!grepl(pattern = 'pctile\\.text', names(bg19ftp))]
  # remove columns that are just 2 alternative variants of the EJ Index
  bg19ftp <- bg19ftp[!grepl(pattern = '\\.BURDEN\\.', names(bg19ftp))]
  bg19ftp <- bg19ftp[!grepl(pattern = '\\.PCT\\.', names(bg19ftp))]
  bg19ftp <- bg19ftp[!grepl(pattern = 'svi6', names(bg19ftp))]
  # remove columns of "Shape_Length" and land vs water area
  bg19ftp$Shape_Length <- NULL
  bg19ftp$arealand     <- NULL
  bg19ftp$areawater    <- NULL
  bg19ftp$OBJECTID     <- NULL
  # readr::read_csv created a tibble, so make is a normal data.frame here just in case tibble's behavior is not expected by some older code that assumed regular data.frame behavior
  bg19ftp <- as.data.frame(bg19ftp)

  # save(bg19ftp, file = 'testsize.rdata')
  # from ejscreen.create() use these snippets:
  # e$FIPS <- ejanalysis::clean.fips(e$FIPS)
  # bg$flagged <-
  #   ejanalysis::flagged(bg[, thresholdfieldnames] / 100, threshold = threshold)
  # # Add FIPS, countyname, statename, State etc --------
  # add the other FIPS components as individual columns
  # bg <- ejanalysis::addFIPScomponents(bg)

  #bg19 <- bg19ftp
  #save(bg19, file = 'bg19.rdata')
  # Then moved file to  ejscreen/data/  and rebuilt package.
}

# NOTE: THE YEARS CAN BE CONFUSING!

###### @template is now obsolete!    http://127.0.0.1:30244/library/roxygen2/doc/reuse.html

#'   The 2022 version of EJSCREEN "EJScreen 2.1" (released circa August 2022)
#'    uses ACS2020, which is from 2016-2020 (released late 2021).
#'   The 2021 version of EJSCREEN "EJScreen 2.0" (confusingly released mid 2021 not late 2020)
#'     used ACS2019, which is from 2015-2019 (released Dec 2020). *****????
#'   The 2020 version of EJSCREEN (confusingly released mid 2021 not late 2020)
#'     used ACS2018, which is from 2014-2018 (released Dec 2019).
#'   The 2019 version of EJSCREEN (released late 2019)
#'     used ACS2017, which is from 2013-2017 (released Dec 2018).
#'   The 2018 version of EJSCREEN (released late 2018)
#'     used ACS2016, which is from 2012-2016 (released Dec 2017).

# See the help file for bg21 or bg22 e.g., help(bg22, package = 'ejscreen')
# ************* and
# see  ACS_US_TOTALS_2014-2018.R in batch.summarizer package
# see NOTES-on-reading-EJSCREEN-2019-from-gdb-on-FTP-site.R
# see updating EJSCREEN tech doc 2019.R

# Be clear on diff between EJSCREEN vs ACS extra fields & other extra fields in this pkg:
#
# EJSCREEN from FTP site has counts and percents of minority, lowincome, etc.
# but lacks demographic subgroups like non-hispanic white alone (NHWA), etc.
# and also the other useful fields like FIPS.TRACT, countyname, etc.
#
# Note data(bg17, package = 'ejscreen')
# which has the EJSCREEN dataset, but lacks demog subgroups or rollups.
# The EJSCREEN dataset on the FTP site provides envt indicators and EJ indexes etc.

# For bg19, the 2019 version of EJSCREEN,
# 367 Column names in FTP site gdb table vs friendly names as used in ejscreen package:
#
# rown  gdbfieldname   Rfieldname
#
# [1,] "OBJECTID"     "OBJECTID"
# [2,] "ID"           "FIPS"
# [3,] "ACSTOTPOP"    "pop"
# [4,] "ACSIPOVBAS"   "povknownratio"
# [5,] "ACSEDUCBAS"   "age25up"
# [6,] "ACSTOTHH"     "hhlds"
# [7,] "ACSTOTHU"     "builtunits"
# [8,] "MINORPOP"     "mins"
# [9,] "MINORPCT"     "pctmin"
# [10,] "LOWINCOME"    "lowinc"
# [11,] "LOWINCPCT"    "pctlowinc"
# [12,] "LESSHS"       "lths"
# [13,] "LESSHSPCT"    "pctlths"
# [14,] "LINGISO"      "lingiso"
# [15,] "LINGISOPCT"   "pctlingiso"
# [16,] "UNDER5"       "under5"
# [17,] "UNDER5PCT"    "pctunder5"
# [18,] "OVER64"       "over64"
# [19,] "OVER64PCT"    "pctover64"
# [20,] "PRE1960"      "pre1960"
# [21,] "PRE1960PCT"   "pctpre1960"
# [22,] "VULEOPCT"     "VSI.eo"
# [23,] "VULSVI6PCT"   "VSI.svi6"
# [24,] "VULEO"        "VNI.eo"
# [25,] "VULSVI6"      "VNI.svi6"
# [26,] "DISPEO"       "VDI.eo"
# [27,] "DISPSVI6"     "VDI.svi6"
# [28,] "DSLPM"        "dpm"
# [29,] "CANCER"       "cancer"
# [30,] "RESP"         "resp"
# [31,] "PTRAF"        "traffic.score"
# [32,] "PWDIS"        "proximity.npdes"
# [33,] "PNPL"         "proximity.npl"
# [34,] "PRMP"         "proximity.rmp"
# [35,] "PTSDF"        "proximity.tsdf"
# [36,] "OZONE"        "o3"
# [37,] "PM25"         "pm"
# [38,] "D_LDPNT_2"    "EJ.DISPARITY.pctpre1960.eo"
# [39,] "LDPNT_D6"     "EJ.DISPARITY.pctpre1960.svi6"
# [40,] "LDPNT_B2"     "EJ.BURDEN.pctpre1960.eo"
# [41,] "LDPNT_B6"     "EJ.BURDEN.pctpre1960.svi6"
# [42,] "LDPNT_P2"     "EJ.PCT.pctpre1960.eo"
# [43,] "LDPNT_P6"     "EJ.PCT.pctpre1960.svi6"
# [44,] "D_DSLPM_2"    "EJ.DISPARITY.dpm.eo"
# [45,] "DSLPM_D6"     "EJ.DISPARITY.dpm.svi6"
# [46,] "DSLPM_B2"     "EJ.BURDEN.dpm.eo"
# [47,] "DSLPM_B6"     "EJ.BURDEN.dpm.svi6"
# [48,] "DSLPM_P2"     "EJ.PCT.dpm.eo"
# [49,] "DSLPM_P6"     "EJ.PCT.dpm.svi6"
# [50,] "D_CANCR_2"    "EJ.DISPARITY.cancer.eo"
# [51,] "CANCR_D6"     "EJ.DISPARITY.cancer.svi6"
# [52,] "CANCR_B2"     "EJ.BURDEN.cancer.eo"
# [53,] "CANCR_B6"     "EJ.BURDEN.cancer.svi6"
# [54,] "CANCR_P2"     "EJ.PCT.cancer.eo"
# [55,] "CANCR_P6"     "EJ.PCT.cancer.svi6"
# [56,] "D_RESP_2"     "EJ.DISPARITY.resp.eo"
# [57,] "RESP_D6"      "EJ.DISPARITY.resp.svi6"
# [58,] "RESP_B2"      "EJ.BURDEN.resp.eo"
# [59,] "RESP_B6"      "EJ.BURDEN.resp.svi6"
# [60,] "RESP_P2"      "EJ.PCT.resp.eo"
# [61,] "RESP_P6"      "EJ.PCT.resp.svi6"
# [62,] "D_PTRAF_2"    "EJ.DISPARITY.traffic.score.eo"
# [63,] "PTRAF_D6"     "EJ.DISPARITY.traffic.score.svi6"
# [64,] "PTRAF_B2"     "EJ.BURDEN.traffic.score.eo"
# [65,] "PTRAF_B6"     "EJ.BURDEN.traffic.score.svi6"
# [66,] "PTRAF_P2"     "EJ.PCT.traffic.score.eo"
# [67,] "PTRAF_P6"     "EJ.PCT.traffic.score.svi6"
# [68,] "D_PWDIS_2"    "EJ.DISPARITY.proximity.npdes.eo"
# [69,] "PWDIS_D6"     "EJ.DISPARITY.proximity.npdes.svi6"
# [70,] "PWDIS_B2"     "EJ.BURDEN.proximity.npdes.eo"
# [71,] "PWDIS_B6"     "EJ.BURDEN.proximity.npdes.svi6"
# [72,] "PWDIS_P2"     "EJ.PCT.proximity.npdes.eo"
# [73,] "PWDIS_P6"     "EJ.PCT.proximity.npdes.svi6"
# [74,] "D_PNPL_2"     "EJ.DISPARITY.proximity.npl.eo"
# [75,] "PNPL_D6"      "EJ.DISPARITY.proximity.npl.svi6"
# [76,] "PNPL_B2"      "EJ.BURDEN.proximity.npl.eo"
# [77,] "PNPL_B6"      "EJ.BURDEN.proximity.npl.svi6"
# [78,] "PNPL_P2"      "EJ.PCT.proximity.npl.eo"
# [79,] "PNPL_P6"      "EJ.PCT.proximity.npl.svi6"
# [80,] "D_PRMP_2"     "EJ.DISPARITY.proximity.rmp.eo"
# [81,] "PRMP_D6"      "EJ.DISPARITY.proximity.rmp.svi6"
# [82,] "PRMP_B2"      "EJ.BURDEN.proximity.rmp.eo"
# [83,] "PRMP_B6"      "EJ.BURDEN.proximity.rmp.svi6"
# [84,] "PRMP_P2"      "EJ.PCT.proximity.rmp.eo"
# [85,] "PRMP_P6"      "EJ.PCT.proximity.rmp.svi6"
# [86,] "D_PTSDF_2"    "EJ.DISPARITY.proximity.tsdf.eo"
# [87,] "PTSDF_D6"     "EJ.DISPARITY.proximity.tsdf.svi6"
# [88,] "PTSDF_B2"     "EJ.BURDEN.proximity.tsdf.eo"
# [89,] "PTSDF_B6"     "EJ.BURDEN.proximity.tsdf.svi6"
# [90,] "PTSDF_P2"     "EJ.PCT.proximity.tsdf.eo"
# [91,] "PTSDF_P6"     "EJ.PCT.proximity.tsdf.svi6"
# [92,] "D_OZONE_2"    "EJ.DISPARITY.o3.eo"
# [93,] "OZONE_D6"     "EJ.DISPARITY.o3.svi6"
# [94,] "OZONE_B2"     "EJ.BURDEN.o3.eo"
# [95,] "OZONE_B6"     "EJ.BURDEN.o3.svi6"
# [96,] "OZONE_P2"     "EJ.PCT.o3.eo"
# [97,] "OZONE_P6"     "EJ.PCT.o3.svi6"
# [98,] "D_PM25_2"     "EJ.DISPARITY.pm.eo"
# [99,] "PM25_D6"      "EJ.DISPARITY.pm.svi6"
# [100,] "PM25_B2"      "EJ.BURDEN.pm.eo"
# [101,] "PM25_B6"      "EJ.BURDEN.pm.svi6"
# [102,] "PM25_P2"      "EJ.PCT.pm.eo"
# [103,] "PM25_P6"      "EJ.PCT.pm.svi6"
# [104,] "STATE_NAME"   "statename"
# [105,] "ST_ABBREV"    "ST"
# [106,] "REGION"       "REGION"
# [107,] "P_MINORPCT"   "pctile.pctmin"
# [108,] "P_LWINCPCT"   "pctile.pctlowinc"
# [109,] "P_LESHSPCT"   "pctile.pctlths"
# [110,] "P_LNGISPCT"   "pctile.pctlingiso"
# [111,] "P_UNDR5PCT"   "pctile.pctunder5"
# [112,] "P_OVR64PCT"   "pctile.pctover64"
# [113,] "P_LDPNT"      "pctile.pctpre1960"
# [114,] "P_VULEOPCT"   "pctile.VSI.eo"
# [115,] "P_VSVI6PCT"   "pctile.VSI.svi6"
# [116,] "P_DSLPM"      "pctile.dpm"
# [117,] "P_CANCR"      "pctile.cancer"
# [118,] "P_RESP"       "pctile.resp"
# [119,] "P_PTRAF"      "pctile.traffic.score"
# [120,] "P_PWDIS"      "pctile.proximity.npdes"
# [121,] "P_PNPL"       "pctile.proximity.npl"
# [122,] "P_PRMP"       "pctile.proximity.rmp"
# [123,] "P_PTSDF"      "pctile.proximity.tsdf"
# [124,] "P_OZONE"      "pctile.o3"
# [125,] "P_PM25"       "pctile.pm"
# [126,] "P_LDPNT_D2"   "pctile.EJ.DISPARITY.pctpre1960.eo"
# [127,] "P_LDPNT_D6"   "pctile.EJ.DISPARITY.pctpre1960.svi6"
# [128,] "P_LDPNT_B2"   "pctile.EJ.BURDEN.pctpre1960.eo"
# [129,] "P_LDPNT_B6"   "pctile.EJ.BURDEN.pctpre1960.svi6"
# [130,] "P_LDPNT_P2"   "pctile.EJ.PCT.pctpre1960.eo"
# [131,] "P_LDPNT_P6"   "pctile.EJ.PCT.pctpre1960.svi6"
# [132,] "P_DSLPM_D2"   "pctile.EJ.DISPARITY.dpm.eo"
# [133,] "P_DSLPM_D6"   "pctile.EJ.DISPARITY.dpm.svi6"
# [134,] "P_DSLPM_B2"   "pctile.EJ.BURDEN.dpm.eo"
# [135,] "P_DSLPM_B6"   "pctile.EJ.BURDEN.dpm.svi6"
# [136,] "P_DSLPM_P2"   "pctile.EJ.PCT.dpm.eo"
# [137,] "P_DSLPM_P6"   "pctile.EJ.PCT.dpm.svi6"
# [138,] "P_CANCR_D2"   "pctile.EJ.DISPARITY.cancer.eo"
# [139,] "P_CANCR_D6"   "pctile.EJ.DISPARITY.cancer.svi6"
# [140,] "P_CANCR_B2"   "pctile.EJ.BURDEN.cancer.eo"
# [141,] "P_CANCR_B6"   "pctile.EJ.BURDEN.cancer.svi6"
# [142,] "P_CANCR_P2"   "pctile.EJ.PCT.cancer.eo"
# [143,] "P_CANCR_P6"   "pctile.EJ.PCT.cancer.svi6"
# [144,] "P_RESP_D2"    "pctile.EJ.DISPARITY.resp.eo"
# [145,] "P_RESP_D6"    "pctile.EJ.DISPARITY.resp.svi6"
# [146,] "P_RESP_B2"    "pctile.EJ.BURDEN.resp.eo"
# [147,] "P_RESP_B6"    "pctile.EJ.BURDEN.resp.svi6"
# [148,] "P_RESP_P2"    "pctile.EJ.PCT.resp.eo"
# [149,] "P_RESP_P6"    "pctile.EJ.PCT.resp.svi6"
# [150,] "P_PTRAF_D2"   "pctile.EJ.DISPARITY.traffic.score.eo"
# [151,] "P_PTRAF_D6"   "pctile.EJ.DISPARITY.traffic.score.svi6"
# [152,] "P_PTRAF_B2"   "pctile.EJ.BURDEN.traffic.score.eo"
# [153,] "P_PTRAF_B6"   "pctile.EJ.BURDEN.traffic.score.svi6"
# [154,] "P_PTRAF_P2"   "pctile.EJ.PCT.traffic.score.eo"
# [155,] "P_PTRAF_P6"   "pctile.EJ.PCT.traffic.score.svi6"
# [156,] "P_PWDIS_D2"   "pctile.EJ.DISPARITY.proximity.npdes.eo"
# [157,] "P_PWDIS_D6"   "pctile.EJ.DISPARITY.proximity.npdes.svi6"
# [158,] "P_PWDIS_B2"   "pctile.EJ.BURDEN.proximity.npdes.eo"
# [159,] "P_PWDIS_B6"   "pctile.EJ.BURDEN.proximity.npdes.svi6"
# [160,] "P_PWDIS_P2"   "pctile.EJ.PCT.proximity.npdes.eo"
# [161,] "P_PWDIS_P6"   "pctile.EJ.PCT.proximity.npdes.svi6"
# [162,] "P_PNPL_D2"    "pctile.EJ.DISPARITY.proximity.npl.eo"
# [163,] "P_PNPL_D6"    "pctile.EJ.DISPARITY.proximity.npl.svi6"
# [164,] "P_PNPL_B2"    "pctile.EJ.BURDEN.proximity.npl.eo"
# [165,] "P_PNPL_B6"    "pctile.EJ.BURDEN.proximity.npl.svi6"
# [166,] "P_PNPL_P2"    "pctile.EJ.PCT.proximity.npl.eo"
# [167,] "P_PNPL_P6"    "pctile.EJ.PCT.proximity.npl.svi6"
# [168,] "P_PRMP_D2"    "pctile.EJ.DISPARITY.proximity.rmp.eo"
# [169,] "P_PRMP_D6"    "pctile.EJ.DISPARITY.proximity.rmp.svi6"
# [170,] "P_PRMP_B2"    "pctile.EJ.BURDEN.proximity.rmp.eo"
# [171,] "P_PRMP_B6"    "pctile.EJ.BURDEN.proximity.rmp.svi6"
# [172,] "P_PRMP_P2"    "pctile.EJ.PCT.proximity.rmp.eo"
# [173,] "P_PRMP_P6"    "pctile.EJ.PCT.proximity.rmp.svi6"
# [174,] "P_PTSDF_D2"   "pctile.EJ.DISPARITY.proximity.tsdf.eo"
# [175,] "P_PTSDF_D6"   "pctile.EJ.DISPARITY.proximity.tsdf.svi6"
# [176,] "P_PTSDF_B2"   "pctile.EJ.BURDEN.proximity.tsdf.eo"
# [177,] "P_PTSDF_B6"   "pctile.EJ.BURDEN.proximity.tsdf.svi6"
# [178,] "P_PTSDF_P2"   "pctile.EJ.PCT.proximity.tsdf.eo"
# [179,] "P_PTSDF_P6"   "pctile.EJ.PCT.proximity.tsdf.svi6"
# [180,] "P_OZONE_D2"   "pctile.EJ.DISPARITY.o3.eo"
# [181,] "P_OZONE_D6"   "pctile.EJ.DISPARITY.o3.svi6"
# [182,] "P_OZONE_B2"   "pctile.EJ.BURDEN.o3.eo"
# [183,] "P_OZONE_B6"   "pctile.EJ.BURDEN.o3.svi6"
# [184,] "P_OZONE_P2"   "pctile.EJ.PCT.o3.eo"
# [185,] "P_OZONE_P6"   "pctile.EJ.PCT.o3.svi6"
# [186,] "P_PM25_D2"    "pctile.EJ.DISPARITY.pm.eo"
# [187,] "P_PM25_D6"    "pctile.EJ.DISPARITY.pm.svi6"
# [188,] "P_PM25_B2"    "pctile.EJ.BURDEN.pm.eo"
# [189,] "P_PM25_B6"    "pctile.EJ.BURDEN.pm.svi6"
# [190,] "P_PM25_P2"    "pctile.EJ.PCT.pm.eo"
# [191,] "P_PM25_P6"    "pctile.EJ.PCT.pm.svi6"
# [192,] "B_MINORPCT"   "bin.pctmin"
# [193,] "B_LWINCPCT"   "bin.pctlowinc"
# [194,] "B_LESHSPCT"   "bin.pctlths"
# [195,] "B_LNGISPCT"   "bin.pctlingiso"
# [196,] "B_UNDR5PCT"   "bin.pctunder5"
# [197,] "B_OVR64PCT"   "bin.pctover64"
# [198,] "B_LDPNT"      "bin.pctpre1960"
# [199,] "B_VULEOPCT"   "bin.VSI.eo"
# [200,] "B_VSVI6PCT"   "bin.VSI.svi6"
# [201,] "B_DSLPM"      "bin.dpm"
# [202,] "B_CANCR"      "bin.cancer"
# [203,] "B_RESP"       "bin.resp"
# [204,] "B_PTRAF"      "bin.traffic.score"
# [205,] "B_PWDIS"      "bin.proximity.npdes"
# [206,] "B_PNPL"       "bin.proximity.npl"
# [207,] "B_PRMP"       "bin.proximity.rmp"
# [208,] "B_PTSDF"      "bin.proximity.tsdf"
# [209,] "B_OZONE"      "bin.o3"
# [210,] "B_PM25"       "bin.pm"
# [211,] "B_LDPNT_D2"   "bin.EJ.DISPARITY.pctpre1960.eo"
# [212,] "B_LDPNT_D6"   "bin.EJ.DISPARITY.pctpre1960.svi6"
# [213,] "B_LDPNT_B2"   "bin.EJ.BURDEN.pctpre1960.eo"
# [214,] "B_LDPNT_B6"   "bin.EJ.BURDEN.pctpre1960.svi6"
# [215,] "B_LDPNT_P2"   "bin.EJ.PCT.pctpre1960.eo"
# [216,] "B_LDPNT_P6"   "bin.EJ.PCT.pctpre1960.svi6"
# [217,] "B_DSLPM_D2"   "bin.EJ.DISPARITY.dpm.eo"
# [218,] "B_DSLPM_D6"   "bin.EJ.DISPARITY.dpm.svi6"
# [219,] "B_DSLPM_B2"   "bin.EJ.BURDEN.dpm.eo"
# [220,] "B_DSLPM_B6"   "bin.EJ.BURDEN.dpm.svi6"
# [221,] "B_DSLPM_P2"   "bin.EJ.PCT.dpm.eo"
# [222,] "B_DSLPM_P6"   "bin.EJ.PCT.dpm.svi6"
# [223,] "B_CANCR_D2"   "bin.EJ.DISPARITY.cancer.eo"
# [224,] "B_CANCR_D6"   "bin.EJ.DISPARITY.cancer.svi6"
# [225,] "B_CANCR_B2"   "bin.EJ.BURDEN.cancer.eo"
# [226,] "B_CANCR_B6"   "bin.EJ.BURDEN.cancer.svi6"
# [227,] "B_CANCR_P2"   "bin.EJ.PCT.cancer.eo"
# [228,] "B_CANCR_P6"   "bin.EJ.PCT.cancer.svi6"
# [229,] "B_RESP_D2"    "bin.EJ.DISPARITY.resp.eo"
# [230,] "B_RESP_D6"    "bin.EJ.DISPARITY.resp.svi6"
# [231,] "B_RESP_B2"    "bin.EJ.BURDEN.resp.eo"
# [232,] "B_RESP_B6"    "bin.EJ.BURDEN.resp.svi6"
# [233,] "B_RESP_P2"    "bin.EJ.PCT.resp.eo"
# [234,] "B_RESP_P6"    "bin.EJ.PCT.resp.svi6"
# [235,] "B_PTRAF_D2"   "bin.EJ.DISPARITY.traffic.score.eo"
# [236,] "B_PTRAF_D6"   "bin.EJ.DISPARITY.traffic.score.svi6"
# [237,] "B_PTRAF_B2"   "bin.EJ.BURDEN.traffic.score.eo"
# [238,] "B_PTRAF_B6"   "bin.EJ.BURDEN.traffic.score.svi6"
# [239,] "B_PTRAF_P2"   "bin.EJ.PCT.traffic.score.eo"
# [240,] "B_PTRAF_P6"   "bin.EJ.PCT.traffic.score.svi6"
# [241,] "B_PWDIS_D2"   "bin.EJ.DISPARITY.proximity.npdes.eo"
# [242,] "B_PWDIS_D6"   "bin.EJ.DISPARITY.proximity.npdes.svi6"
# [243,] "B_PWDIS_B2"   "bin.EJ.BURDEN.proximity.npdes.eo"
# [244,] "B_PWDIS_B6"   "bin.EJ.BURDEN.proximity.npdes.svi6"
# [245,] "B_PWDIS_P2"   "bin.EJ.PCT.proximity.npdes.eo"
# [246,] "B_PWDIS_P6"   "bin.EJ.PCT.proximity.npdes.svi6"
# [247,] "B_PNPL_D2"    "bin.EJ.DISPARITY.proximity.npl.eo"
# [248,] "B_PNPL_D6"    "bin.EJ.DISPARITY.proximity.npl.svi6"
# [249,] "B_PNPL_B2"    "bin.EJ.BURDEN.proximity.npl.eo"
# [250,] "B_PNPL_B6"    "bin.EJ.BURDEN.proximity.npl.svi6"
# [251,] "B_PNPL_P2"    "bin.EJ.PCT.proximity.npl.eo"
# [252,] "B_PNPL_P6"    "bin.EJ.PCT.proximity.npl.svi6"
# [253,] "B_PRMP_D2"    "bin.EJ.DISPARITY.proximity.rmp.eo"
# [254,] "B_PRMP_D6"    "bin.EJ.DISPARITY.proximity.rmp.svi6"
# [255,] "B_PRMP_B2"    "bin.EJ.BURDEN.proximity.rmp.eo"
# [256,] "B_PRMP_B6"    "bin.EJ.BURDEN.proximity.rmp.svi6"
# [257,] "B_PRMP_P2"    "bin.EJ.PCT.proximity.rmp.eo"
# [258,] "B_PRMP_P6"    "bin.EJ.PCT.proximity.rmp.svi6"
# [259,] "B_PTSDF_D2"   "bin.EJ.DISPARITY.proximity.tsdf.eo"
# [260,] "B_PTSDF_D6"   "bin.EJ.DISPARITY.proximity.tsdf.svi6"
# [261,] "B_PTSDF_B2"   "bin.EJ.BURDEN.proximity.tsdf.eo"
# [262,] "B_PTSDF_B6"   "bin.EJ.BURDEN.proximity.tsdf.svi6"
# [263,] "B_PTSDF_P2"   "bin.EJ.PCT.proximity.tsdf.eo"
# [264,] "B_PTSDF_P6"   "bin.EJ.PCT.proximity.tsdf.svi6"
# [265,] "B_OZONE_D2"   "bin.EJ.DISPARITY.o3.eo"
# [266,] "B_OZONE_D6"   "bin.EJ.DISPARITY.o3.svi6"
# [267,] "B_OZONE_B2"   "bin.EJ.BURDEN.o3.eo"
# [268,] "B_OZONE_B6"   "bin.EJ.BURDEN.o3.svi6"
# [269,] "B_OZONE_P2"   "bin.EJ.PCT.o3.eo"
# [270,] "B_OZONE_P6"   "bin.EJ.PCT.o3.svi6"
# [271,] "B_PM25_D2"    "bin.EJ.DISPARITY.pm.eo"
# [272,] "B_PM25_D6"    "bin.EJ.DISPARITY.pm.svi6"
# [273,] "B_PM25_B2"    "bin.EJ.BURDEN.pm.eo"
# [274,] "B_PM25_B6"    "bin.EJ.BURDEN.pm.svi6"
# [275,] "B_PM25_P2"    "bin.EJ.PCT.pm.eo"
# [276,] "B_PM25_P6"    "bin.EJ.PCT.pm.svi6"
# [277,] "T_MINORPCT"   "pctile.text.pctmin"
# [278,] "T_LWINCPCT"   "pctile.text.pctlowinc"
# [279,] "T_LESHSPCT"   "pctile.text.pctlths"
# [280,] "T_LNGISPCT"   "pctile.text.pctlingiso"
# [281,] "T_UNDR5PCT"   "pctile.text.pctunder5"
# [282,] "T_OVR64PCT"   "pctile.text.pctover64"
# [283,] "T_VULEOPCT"   "pctile.text.VSI.eo"
# [284,] "T_VSVI6PCT"   "pctile.text.VSI.svi6"
# [285,] "T_LDPNT"      "pctile.text.pctpre1960"
# [286,] "T_LDPNT_D2"   "pctile.text.EJ.DISPARITY.pctpre1960.eo"
# [287,] "T_LDPNT_D6"   "pctile.text.EJ.DISPARITY.pctpre1960.svi6"
# [288,] "T_LDPNT_B2"   "pctile.text.EJ.BURDEN.pctpre1960.eo"
# [289,] "T_LDPNT_B6"   "pctile.text.EJ.BURDEN.pctpre1960.svi6"
# [290,] "T_LDPNT_P2"   "pctile.text.EJ.PCT.pctpre1960.eo"
# [291,] "T_LDPNT_P6"   "pctile.text.EJ.PCT.pctpre1960.svi6"
# [292,] "T_DSLPM"      "pctile.text.dpm"
# [293,] "T_DSLPM_D2"   "pctile.text.EJ.DISPARITY.dpm.eo"
# [294,] "T_DSLPM_D6"   "pctile.text.EJ.DISPARITY.dpm.svi6"
# [295,] "T_DSLPM_B2"   "pctile.text.EJ.BURDEN.dpm.eo"
# [296,] "T_DSLPM_B6"   "pctile.text.EJ.BURDEN.dpm.svi6"
# [297,] "T_DSLPM_P2"   "pctile.text.EJ.PCT.dpm.eo"
# [298,] "T_DSLPM_P6"   "pctile.text.EJ.PCT.dpm.svi6"
# [299,] "T_CANCR"      "pctile.text.cancer"
# [300,] "T_CANCR_D2"   "pctile.text.EJ.DISPARITY.cancer.eo"
# [301,] "T_CANCR_D6"   "pctile.text.EJ.DISPARITY.cancer.svi6"
# [302,] "T_CANCR_B2"   "pctile.text.EJ.BURDEN.cancer.eo"
# [303,] "T_CANCR_B6"   "pctile.text.EJ.BURDEN.cancer.svi6"
# [304,] "T_CANCR_P2"   "pctile.text.EJ.PCT.cancer.eo"
# [305,] "T_CANCR_P6"   "pctile.text.EJ.PCT.cancer.svi6"
# [306,] "T_RESP"       "pctile.text.resp"
# [307,] "T_RESP_D2"    "pctile.text.EJ.DISPARITY.resp.eo"
# [308,] "T_RESP_D6"    "pctile.text.EJ.DISPARITY.resp.svi6"
# [309,] "T_RESP_B2"    "pctile.text.EJ.BURDEN.resp.eo"
# [310,] "T_RESP_B6"    "pctile.text.EJ.BURDEN.resp.svi6"
# [311,] "T_RESP_P2"    "pctile.text.EJ.PCT.resp.eo"
# [312,] "T_RESP_P6"    "pctile.text.EJ.PCT.resp.svi6"
# [313,] "T_PTRAF"      "pctile.text.traffic.score"
# [314,] "T_PTRAF_D2"   "pctile.text.EJ.DISPARITY.traffic.score.eo"
# [315,] "T_PTRAF_D6"   "pctile.text.EJ.DISPARITY.traffic.score.svi6"
# [316,] "T_PTRAF_B2"   "pctile.text.EJ.BURDEN.traffic.score.eo"
# [317,] "T_PTRAF_B6"   "pctile.text.EJ.BURDEN.traffic.score.svi6"
# [318,] "T_PTRAF_P2"   "pctile.text.EJ.PCT.traffic.score.eo"
# [319,] "T_PTRAF_P6"   "pctile.text.EJ.PCT.traffic.score.svi6"
# [320,] "T_PWDIS"      "pctile.text.proximity.npdes"
# [321,] "T_PWDIS_D2"   "pctile.text.EJ.DISPARITY.proximity.npdes.eo"
# [322,] "T_PWDIS_D6"   "pctile.text.EJ.DISPARITY.proximity.npdes.svi6"
# [323,] "T_PWDIS_B2"   "pctile.text.EJ.BURDEN.proximity.npdes.eo"
# [324,] "T_PWDIS_B6"   "pctile.text.EJ.BURDEN.proximity.npdes.svi6"
# [325,] "T_PWDIS_P2"   "pctile.text.EJ.PCT.proximity.npdes.eo"
# [326,] "T_PWDIS_P6"   "pctile.text.EJ.PCT.proximity.npdes.svi6"
# [327,] "T_PNPL"       "pctile.text.proximity.npl"
# [328,] "T_PNPL_D2"    "pctile.text.EJ.DISPARITY.proximity.npl.eo"
# [329,] "T_PNPL_D6"    "pctile.text.EJ.DISPARITY.proximity.npl.svi6"
# [330,] "T_PNPL_B2"    "pctile.text.EJ.BURDEN.proximity.npl.eo"
# [331,] "T_PNPL_B6"    "pctile.text.EJ.BURDEN.proximity.npl.svi6"
# [332,] "T_PNPL_P2"    "pctile.text.EJ.PCT.proximity.npl.eo"
# [333,] "T_PNPL_P6"    "pctile.text.EJ.PCT.proximity.npl.svi6"
# [334,] "T_PRMP"       "pctile.text.proximity.rmp"
# [335,] "T_PRMP_D2"    "pctile.text.EJ.DISPARITY.proximity.rmp.eo"
# [336,] "T_PRMP_D6"    "pctile.text.EJ.DISPARITY.proximity.rmp.svi6"
# [337,] "T_PRMP_B2"    "pctile.text.EJ.BURDEN.proximity.rmp.eo"
# [338,] "T_PRMP_B6"    "pctile.text.EJ.BURDEN.proximity.rmp.svi6"
# [339,] "T_PRMP_P2"    "pctile.text.EJ.PCT.proximity.rmp.eo"
# [340,] "T_PRMP_P6"    "pctile.text.EJ.PCT.proximity.rmp.svi6"
# [341,] "T_PTSDF"      "pctile.text.proximity.tsdf"
# [342,] "T_PTSDF_D2"   "pctile.text.EJ.DISPARITY.proximity.tsdf.eo"
# [343,] "T_PTSDF_D6"   "pctile.text.EJ.DISPARITY.proximity.tsdf.svi6"
# [344,] "T_PTSDF_B2"   "pctile.text.EJ.BURDEN.proximity.tsdf.eo"
# [345,] "T_PTSDF_B6"   "pctile.text.EJ.BURDEN.proximity.tsdf.svi6"
# [346,] "T_PTSDF_P2"   "pctile.text.EJ.PCT.proximity.tsdf.eo"
# [347,] "T_PTSDF_P6"   "pctile.text.EJ.PCT.proximity.tsdf.svi6"
# [348,] "T_OZONE"      "pctile.text.o3"
# [349,] "T_OZONE_D2"   "pctile.text.EJ.DISPARITY.o3.eo"
# [350,] "T_OZONE_D6"   "pctile.text.EJ.DISPARITY.o3.svi6"
# [351,] "T_OZONE_B2"   "pctile.text.EJ.BURDEN.o3.eo"
# [352,] "T_OZONE_B6"   "pctile.text.EJ.BURDEN.o3.svi6"
# [353,] "T_OZONE_P2"   "pctile.text.EJ.PCT.o3.eo"
# [354,] "T_OZONE_P6"   "pctile.text.EJ.PCT.o3.svi6"
# [355,] "T_PM25"       "pctile.text.pm"
# [356,] "T_PM25_D2"    "pctile.text.EJ.DISPARITY.pm.eo"
# [357,] "T_PM25_D6"    "pctile.text.EJ.DISPARITY.pm.svi6"
# [358,] "T_PM25_B2"    "pctile.text.EJ.BURDEN.pm.eo"
# [359,] "T_PM25_B6"    "pctile.text.EJ.BURDEN.pm.svi6"
# [360,] "T_PM25_P2"    "pctile.text.EJ.PCT.pm.eo"
# [361,] "T_PM25_P6"    "pctile.text.EJ.PCT.pm.svi6"
# [362,] "AREALAND"     "arealand"
# [363,] "AREAWATER"    "areawater"
# [364,] "NPL_CNT"      "count.NPL"
# [365,] "TSDF_CNT"     "count.TSDF"
# [366,] "Shape_Length" "Shape_Length"
# [367,] "Shape_Area"   "area"


