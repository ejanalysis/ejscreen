#     ######################################################################################
#     # SUMMARY STATS ON DISPARITY BY GROUP BY ENVT ISSUE
#     #  See help for RR.table() in ejanalysis package
#     # (This is very slow right now)

# set attributes to store metadata on vintage
metadata <- list(
  census_version = 2020,
  acs_version = '2016-2020',
  acs_releasedate = '3/17/2022',
  ejscreen_version = '2.1',
  ejscreen_releasedate = 'September 2022',
  ejscreen_pkg_data = 'bg22'
)

bg <- ejscreen::bg22plus  # bg=bg22plus


names.dplus <- c(ejscreen::names.d, ejscreen::names.d.subgroups.pct)

###############################################
# NOT FIXED YET:
#
# Ratios <- ejanalysis::RR.table(
#   bg, 
#   Enames = ejscreen::names.e, 
#   Dnames = names.dplus, 
#   popcolname = 'pop', 
#   digits = 2
# )
# RRS.US  <- Ratios
# RRS.US
# attributes(RRS.US) <- c(attributes(RRS.US), metadata)
# usethis::use_data(RRS.US)
###############################################

MeansByGroup_and_Ratios <- ejanalysis::RR.means(
  e = subset(bg, select=names.e), 
  d = subset(bg, select = names.dplus), 
  pop = bg$pop
)
MeansByGroup_and_Ratios 
attributes(MeansByGroup_and_Ratios) <- c(attributes(MeansByGroup_and_Ratios), metadata)
usethis::use_data(MeansByGroup_and_Ratios)

rm(bg)
