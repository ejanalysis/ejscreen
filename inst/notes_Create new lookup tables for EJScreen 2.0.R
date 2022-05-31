# Create new lookup tables for EJScreen 2.0 and then next version, for ejscreen pkg and for EJAM, etc.


# c(names.d, names.e, names.ej, names.d.subgroups)

vars_needing_pctile_in_lookup_table <- c(
  "VSI.eo", 
  "pctmin", "pctlowinc", 
  "pctlths", "pctlingiso", "pctunder5", "pctover64",
  "pctunemployed",  
  
  "pctnhwa", "pcthisp", 
  "pctnhba", "pctnhaa", "pctnhaiana", "pctnhnhpia", "pctnhotheralone", "pctnhmulti",
  
  "pm", "o3", "cancer", "resp", "dpm", 
  "pctpre1960", 
  "traffic.score", 
  "proximity.npl", "proximity.rmp", "proximity.tsdf", "proximity.npdes", 
  "ust",
  
  "EJ.DISPARITY.pm.eo", "EJ.DISPARITY.o3.eo", "EJ.DISPARITY.cancer.eo", "EJ.DISPARITY.resp.eo", "EJ.DISPARITY.dpm.eo", 
  "EJ.DISPARITY.pctpre1960.eo", 
  "EJ.DISPARITY.traffic.score.eo", 
  "EJ.DISPARITY.proximity.npl.eo", "EJ.DISPARITY.proximity.rmp.eo", "EJ.DISPARITY.proximity.tsdf.eo", "EJ.DISPARITY.proximity.npdes.eo", 
  "EJ.DISPARITY.ust.eo"
)


# vars_needing_pctile_in_lookup_table



x <- ejanalysis::write.wtd.pctiles.by.zone(
  mydf = ejscreen::bg21plus[ , vars_needing_pctile_in_lookup_table], 
  wts = bg21plus$pop, 
  filename = 'lookupUSA.bg21plus'
)

