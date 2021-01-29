if (1==0) {
  # SPLITTING EJSCREEN DATASET INTO TWO FILES - BASIC VS EXTRA INFO ADDED BY THIS PACKAGE
  # TO KEEP FILE SIZE UNDER 100MB FOR EACH DATA FILE .rdata

  keptcols <- c("FIPS", "pop", "povknownratio", "age25up", "hhlds", "builtunits",
                "mins", "pctmin", "lowinc", "pctlowinc", "lths", "pctlths", "lingiso", "pctlingiso",
                "under5", "pctunder5", "over64", "pctover64", "pre1960", "pctpre1960",

                "VSI.eo", "VNI.eo", "VDI.eo",

                "dpm", "cancer", "resp", "traffic.score", "proximity.npdes", "proximity.npl",
                "proximity.rmp", "proximity.tsdf", "o3", "pm",

                "EJ.DISPARITY.pctpre1960.eo", "EJ.DISPARITY.dpm.eo", "EJ.DISPARITY.cancer.eo", "EJ.DISPARITY.resp.eo",
                "EJ.DISPARITY.traffic.score.eo", "EJ.DISPARITY.proximity.npdes.eo",
                "EJ.DISPARITY.proximity.npl.eo", "EJ.DISPARITY.proximity.rmp.eo",
                "EJ.DISPARITY.proximity.tsdf.eo", "EJ.DISPARITY.o3.eo", "EJ.DISPARITY.pm.eo",

                "pctile.pctmin", "pctile.pctlowinc", "pctile.pctlths", "pctile.pctlingiso",
                "pctile.pctunder5", "pctile.pctover64", "pctile.pctpre1960",
                "pctile.VSI.eo",
                "pctile.dpm", "pctile.cancer", "pctile.resp",
                "pctile.traffic.score", "pctile.proximity.npdes", "pctile.proximity.npl",
                "pctile.proximity.rmp", "pctile.proximity.tsdf", "pctile.o3", "pctile.pm",
                "pctile.EJ.DISPARITY.pctpre1960.eo", "pctile.EJ.DISPARITY.dpm.eo",
                "pctile.EJ.DISPARITY.cancer.eo", "pctile.EJ.DISPARITY.resp.eo",
                "pctile.EJ.DISPARITY.traffic.score.eo", "pctile.EJ.DISPARITY.proximity.npdes.eo",
                "pctile.EJ.DISPARITY.proximity.npl.eo", "pctile.EJ.DISPARITY.proximity.rmp.eo",
                "pctile.EJ.DISPARITY.proximity.tsdf.eo", "pctile.EJ.DISPARITY.o3.eo", "pctile.EJ.DISPARITY.pm.eo",

                "bin.pctmin", "bin.pctlowinc", "bin.pctlths",
                "bin.pctlingiso", "bin.pctunder5", "bin.pctover64", "bin.pctpre1960",
                "bin.VSI.eo",
                "bin.dpm", "bin.cancer", "bin.resp", "bin.traffic.score",
                "bin.proximity.npdes", "bin.proximity.npl", "bin.proximity.rmp",
                "bin.proximity.tsdf", "bin.o3", "bin.pm",
                "bin.EJ.DISPARITY.pctpre1960.eo",
                "bin.EJ.DISPARITY.dpm.eo", "bin.EJ.DISPARITY.cancer.eo", "bin.EJ.DISPARITY.resp.eo",
                "bin.EJ.DISPARITY.traffic.score.eo", "bin.EJ.DISPARITY.proximity.npdes.eo",
                "bin.EJ.DISPARITY.proximity.npl.eo", "bin.EJ.DISPARITY.proximity.rmp.eo",
                "bin.EJ.DISPARITY.proximity.tsdf.eo", "bin.EJ.DISPARITY.o3.eo", "bin.EJ.DISPARITY.pm.eo",

                "AREALAND", "AREAWATER", # rename?
                "NPL_CNT", "TSDF_CNT")  # rename count.NPL count.TSDF

  extracols <- c("hisp", "nhwa", "nhba", "nhaiana", "nhaa", "nhnhpia", "nhotheralone",
                 "nhmulti", "nonmins", "pcthisp", "pctnhwa", "pctnhba", "pctnhaiana",
                 "pctnhaa", "pctnhnhpia", "pctnhotheralone", "pctnhmulti",

                 "flagged",

                 "FIPS.TRACT", "FIPS.COUNTY", "FIPS.ST", "ST", "statename", "countyname", "REGION",
                 "OBJECTID",
                 "area", "lat", "lon")

  bg19extra <- bg19[ , extracols]
  save(bg19extra, file = 'bg19extra.rdata')

  bg19 <- bg19[,keptcols]
  save(bg19, file = 'bg19.rdata')

}
