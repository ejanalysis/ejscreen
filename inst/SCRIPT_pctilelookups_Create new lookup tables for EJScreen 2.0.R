# Create new lookup tables for EJScreen 2.0 and then next version, for ejscreen pkg and for EJAM, etc.

#'   see also: \cr\cr
#'   ejscreen.lookuptables  and \cr 
#'   ejanalysis::write.wtd.pctiles.by.zone   and  \cr
#'   table.pop.pctile  and  cr
#'   map service with lookup tables  \cr \cr\cr

# ALSO JUST USE  lookup tables at:  https://ejscreen.epa.gov/arcgis/rest/services/ejscreen/ejscreen_v2021/MapServer/8 


# c(names.d, names.e, names.ej, names.d.subgroups)

vars_needing_pctile_in_lookup_table <- c(
  ejscreen::names.d, 
  ejscreen::names.d.subgroups,
  ejscreen::names.e, 
  ejscreen::names.ej 
)
# "VSI.eo", 
# "pctmin", "pctlowinc", 
# "pctlths", "pctlingiso", "pctunder5", "pctover64",
# "pctunemployed",  
# 
# "pctnhwa", "pcthisp", 
# "pctnhba", "pctnhaa", "pctnhaiana", "pctnhnhpia", "pctnhotheralone", "pctnhmulti",
# 
# "pm", "o3", "cancer", "resp", "dpm", 
# "pctpre1960", 
# "traffic.score", 
# "proximity.npl", "proximity.rmp", "proximity.tsdf", "proximity.npdes", 
# "ust",
# 
# "EJ.DISPARITY.pm.eo", "EJ.DISPARITY.o3.eo", "EJ.DISPARITY.cancer.eo", "EJ.DISPARITY.resp.eo", "EJ.DISPARITY.dpm.eo", 
# "EJ.DISPARITY.pctpre1960.eo", 
# "EJ.DISPARITY.traffic.score.eo", 
# "EJ.DISPARITY.proximity.npl.eo", "EJ.DISPARITY.proximity.rmp.eo", "EJ.DISPARITY.proximity.tsdf.eo", "EJ.DISPARITY.proximity.npdes.eo", 
# "EJ.DISPARITY.ust.eo"

bg <- ejscreen::bg21plus

lookupUSA <- ejanalysis::write.wtd.pctiles.by.zone(
  mydf = bg[ , vars_needing_pctile_in_lookup_table], 
  wts = bg$pop, 
  filename =  'lookupUSA')

# lookupRegions <- ejanalysis::write.wtd.pctiles.by.zone(
#   mydf = bg[ , vars_needing_pctile_in_lookup_table], 
#   wts = bg$pop,
#   zone.vector = bg$REGION, 
#   filename =  'lookupRegions')

lookupStates <- if (!('ST' %in% names(bg))) {
  message('requires a column called ST to create lookup table of percentiles')
} else {
  ejanalysis::write.wtd.pctiles.by.zone(
    mydf = bg[ , vars_needing_pctile_in_lookup_table], 
    wts = bg$pop, 
    zone.vector = bg$ST, 
    filename =  'lookupStates')
}

attr(lookupUSA, 'year')    <- 'EJScreen 2.0 bg21 ACS2015-2019'
attr(lookupStates, 'year') <- 'EJScreen 2.0 bg21 ACS2015-2019'

usethis::use_data(lookupUSA)
usethis::use_data(lookupStates)
