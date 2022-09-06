# creating bg22plus from bg22 and bgDemographicSubgroups2016to2020

# merge EJScreen dataset with Demographic subgroups from ACS

library(ejanalysis)
library(ejscreen)

cbind(sapply(bg22, function(x) sum(is.na(x)))) 

#  ejscreen.download() relied on 
#  ejanalysis::addFIPScomponents() to get those, which used 
#  data(lookup.states, package='proxistat') and  ejanalysis::get.county.info
# and those rely on  proxistat::countiesall   

bg22plus <- merge(ejscreen::bg22, ejscreen::bg22DemographicSubgroups2016to2020, all.x = TRUE, by = 'FIPS', suffixes = c('','.duplicatecolumn'))

bg22plus <- bg22plus[ , !grepl('\\.duplicatecolumn', names(bg22plus))]
# # dropped duplicated columns,  pop, mins, pctmin
# intersect(names(bg22), names(bg22DemographicSubgroups2016to2020))
# # [1] "FIPS"   "pop"    "mins"   "pctmin"


#
# PUERTO RICO
# 
# Note that only Puerto Rico (FIPS starting with 72) is missing from this ACS subgroups dataset.
# while bg22 has PR, so when merged, the PR rows would be NA for pcthisp, etc.
dim(ejscreen::bg22)  # [1] 242,335    157
dim(bg22)            # [1] 242,335    157
dim(bg22DemographicSubgroups2016to2020) # [1] 239,780     21
dim(bg22plus)        # [1] 242,335    174
#
setdiff(substr(bg22$FIPS, 1,2), substr(bg22DemographicSubgroups2016to2020$FIPS,1,2))
# [1]    72
addmargins(table(substr(bg22$FIPS,1,2) != '72'))
#    FALSE   TRUE    Sum 
#  2,555 239,780 242,335 
addmargins(table(substr(bg22DemographicSubgroups2016to2020$FIPS,1,2) != '72'))
#      TRUE    Sum
#  239,780 239,780 
#  if you wanted to remove PR, this would do it:
# bg22plus <- bg22plus[bg22plus$ST != 'PR',]

# add bgid to join to blockwts, etc.
bg22plus$bgid <- 1:NROW(bg22plus)

 # set attributes to store metadata on vintage
metadata <- list(
  census_version = 2020,
  acs_version = '2016-2020',
  acs_releasedate = '3/17/2022',
  ejscreen_version = '2.1',
  ejscreen_releasedate = 'September 2022',
  ejscreen_pkg_data = 'bg22'
)
  attributes(bg22plus) <- c(attributes(bg22plus), metadata)

  # SAVE DATASET FOR THE PACKAGE
  usethis::use_data(bg22plus, overwrite = TRUE)

# and confirmed that sort is same bgid, bgfips, as in blockwts$bgid or blockdata::bgid2fips



dput(names(bg22plus))
# c("FIPS", "FIPS.TRACT", "FIPS.COUNTY", "FIPS.ST", "ST", "statename", 
#   "REGION", "OBJECTID", 
#
#      "pop", "povknownratio", "age25up", "hhlds", 
#   "builtunits", "unemployedbase", "mins", 

#   "pctmin", "lowinc", "pctlowinc", 
#   "lths", "pctlths", "lingiso", "pctlingiso", "under5", "pctunder5", 
#   "over64", "pctover64", 
#    "unemployed", "pctunemployed", 
#    "VSI.eo", 
#
#    "pre1960", "pctpre1960", 
#    "dpm", "cancer", "resp", "traffic.score", 
#   "proximity.npdes", "proximity.npl", "proximity.rmp", "proximity.tsdf", 
#   "o3", "pm", "ust", 
#
#   "EJ.DISPARITY.pctpre1960.eo", "EJ.DISPARITY.dpm.eo", 
#   "EJ.DISPARITY.cancer.eo", "EJ.DISPARITY.resp.eo", "EJ.DISPARITY.traffic.score.eo", 
#   "EJ.DISPARITY.proximity.npdes.eo", "EJ.DISPARITY.proximity.npl.eo", 
#   "EJ.DISPARITY.proximity.rmp.eo", "EJ.DISPARITY.proximity.tsdf.eo", 
#   "EJ.DISPARITY.o3.eo", "EJ.DISPARITY.pm.eo", "EJ.DISPARITY.ust.eo", 
#
#   "pctile.pctmin", "pctile.pctlowinc", "pctile.pctlths", "pctile.pctlingiso", 
#   "pctile.pctunder5", "pctile.pctover64", "pctile.pctunemployed", 
#   "pctile.VSI.eo", 
# 
#    "pctile.pctpre1960", "pctile.dpm", "pctile.cancer", 
#   "pctile.resp", "pctile.traffic.score", "pctile.proximity.npdes", 
#   "pctile.proximity.npl", "pctile.proximity.rmp", "pctile.proximity.tsdf", 
#   "pctile.o3", "pctile.pm", "pctile.ust", 
#
#    "pctile.EJ.DISPARITY.pctpre1960.eo", 
#   "pctile.EJ.DISPARITY.dpm.eo", "pctile.EJ.DISPARITY.cancer.eo", 
#   "pctile.EJ.DISPARITY.resp.eo", "pctile.EJ.DISPARITY.traffic.score.eo", 
#   "pctile.EJ.DISPARITY.proximity.npdes.eo", "pctile.EJ.DISPARITY.proximity.npl.eo", 
#   "pctile.EJ.DISPARITY.proximity.rmp.eo", "pctile.EJ.DISPARITY.proximity.tsdf.eo", 
#   "pctile.EJ.DISPARITY.o3.eo", "pctile.EJ.DISPARITY.pm.eo", "pctile.EJ.DISPARITY.ust.eo", 
#
#   "bin.pctmin", "bin.pctlowinc", "bin.pctlths", "bin.pctlingiso", 
#   "bin.pctunder5", "bin.pctover64", "bin.unemployed", "bin.VSI.eo", 
#   "bin.pctpre1960", "bin.dpm", "bin.cancer", "bin.resp", "bin.traffic.score", 
#   "bin.proximity.npdes", "bin.proximity.npl", "bin.proximity.rmp", 
#   "bin.proximity.tsdf", "bin.o3", "bin.pm", "bin.ust", 
# 
#    "bin.EJ.DISPARITY.pctpre1960.eo", 
#   "bin.EJ.DISPARITY.dpm.eo", "bin.EJ.DISPARITY.cancer.eo", "bin.EJ.DISPARITY.resp.eo", 
#   "bin.EJ.DISPARITY.traffic.score.eo", "bin.EJ.DISPARITY.proximity.npdes.eo", 
#   "bin.EJ.DISPARITY.proximity.npl.eo", "bin.EJ.DISPARITY.proximity.rmp.eo", 
#   "bin.EJ.DISPARITY.proximity.tsdf.eo", "bin.EJ.DISPARITY.o3.eo", 
#   "bin.EJ.DISPARITY.pm.eo", "bin.EJ.DISPARITY.ust.eo",
#
#    "pctile.text.pctmin", 
#   "pctile.text.pctlowinc", "pctile.text.pctlths", "pctile.text.pctlingiso", 
#   "pctile.text.pctunder5", "pctile.text.pctover64", "pctile.text.unemployed", 
#   "pctile.text.VSI.eo", "pctile.text.pctpre1960", "pctile.text.EJ.DISPARITY.pctpre1960.eo", 
#   "pctile.text.dpm", 
# 
#    "pctile.text.EJ.DISPARITY.dpm.eo", "pctile.text.cancer", 
#   "pctile.text.EJ.DISPARITY.cancer.eo", "pctile.text.resp", "pctile.text.EJ.DISPARITY.resp.eo", 
#   "pctile.text.traffic.score", "pctile.text.EJ.DISPARITY.traffic.score.eo", 
#   "pctile.text.proximity.npdes", "pctile.text.EJ.DISPARITY.proximity.npdes.eo", 
#   "pctile.text.proximity.npl", "pctile.text.EJ.DISPARITY.proximity.npl.eo", 
#   "pctile.text.proximity.rmp", "pctile.text.EJ.DISPARITY.proximity.rmp.eo", 
#   "pctile.text.proximity.tsdf", "pctile.text.EJ.DISPARITY.proximity.tsdf.eo", 
# 
#   "pctile.text.o3", 
#    "pctile.text.EJ.DISPARITY.o3.eo", "pctile.text.pm", 
#   "pctile.text.EJ.DISPARITY.pm.eo", "pctile.text.ust", "pctile.text.EJ.DISPARITY.ust.eo", 
#   
#   "arealand", "areawater", "count.NPL", "count.TSDF", "Shape_Length", 
#   "area", "countyname", 
# 
#   "hisp",    "nhwa",     "nhba",   "nhaiana", "nhaa",          "nhnhpia",    "nhotheralone",    "nhmulti", 
#   "pctnhwa", "pcthisp", "pctnhba", "pctnhaa", "pctnhaiana", "pctnhnhpia", "pctnhotheralone", "pctnhmulti", 
#   "nonmins")





 

