# Create or Use percentile lookup tables for EJScreen, for ejscreen pkg and for EJAM, etc.

#'   see also:
#'   lookupUSA and lookupStates based on actual lookup tables from EJScreen
#'   ejscreen.lookuptables  and \cr
#'   ejanalysis::write.wtd.pctiles.by.zone   and  \cr
#'   table.pop.pctile  and  cr
#'   map service with lookup tables  \cr \cr\cr

#  see also:

# ASSIGN PERCENTILE TO EACH BLOCK GROUP VALUE ####
# (for new indicators or just to replicate ejscreen dataset)

# ejanalysis::get.pctile		Determine (Weighted) Percentile
# ejanalysis::assign.pctiles		Assign percentiles to vector of values (weighted, by zone)
# ejanalysis::assign.pctiles.alt2		Assign percentiles to values (alternative formula, and not by zone)

# ejanalysis::make.pctile.cols		Make columns of (weighted) percentiles from columns of values
# ejanalysis::make.pctile.cols.alt2		Alternative way to make columns of (weighted) percentiles from columns of values
# ejanalysis::make.bin.cols		Create a Bin Numbers Column for each Percentiles Column
# ejanalysis::make.bin.pctile.cols		Weighted Percentiles and Bin Numbers for Each Column, by zone, such as percentiles within each State
# ejanalysis::make.bin.pctile.cols.byzone		May be obsolete and not used- Percentile and bin number fields, by zone, such as percentiles within each State


# PRECREATED LOOKUP TABLES AS DATA ####

# EJAM::usastats		  data.table of 100 percentiles and means, in the USA overall, across all locations (e.g., block groups) for a set of indicators such as percent low income
# EJAM::statestats		data.table of 100 percentiles and means, within each state, across all locations (e.g., block groups) for a set of indicators such as percent low income
# EJAM::regionstats		data.table of 100 percentiles and means, within each EPA Region, across all locations (e.g., block groups) for a set of indicators such as percent low income

# ejscreen::lookupUSA		    The nationwide  latest version of the EJSCREEN percentile lookup table.
# ejscreen::lookupStates		The State-level latest version of the EJSCREEN percentile lookup table.
# ejscreen::lookupRegions		deprecated/ was EPA-Region-level but no longer used.


# CREATE LOOKUPS ####
# (for new indicators or just to replicate ejscreen dataset)

# analyze.stuff::pctiles		Show the rounded values at 100 percentiles
# analyze.stuff::pctiles.a.over.b		Show the rounded values at 100 percentiles for a/b (or zero if b=0)
# analyze.stuff::pctiles.exact		Show the not-rounded values at 100 percentiles
# analyze.stuff::wtd.pctiles		Show the rounded values at 100 weighted percentiles
# analyze.stuff::wtd.pctiles.exact		Show the values at 100 weighted percentiles
# analyze.stuff::wtd.pctiles.fast		Show the values at 100 weighted percentiles

# ejanalysis::write.pctiles		Write csv file lookup table - percentiles, mean, standard deviation
# ejanalysis::write.pctiles.by.zone		create lookup table as file of percentiles, mean, sd by state or region
# ejanalysis::write.wtd.pctiles		create lookup table as file of pop-weighted percentiles, mean, std.dev
# ejanalysis::write.wtd.pctiles.by.zone		create lookup table as file of pop-weighted or unwtd percentiles, mean, sd for US or by state or region

# ejscreen::ejscreen.lookuptables		Create EJSCREEN Lookup Tables of Pop. Percentiles by Zone - but see ejscreen::write.wtd.pctiles.by.zone()

# EJAM::lookup_pctile 		  look up in a table to find percentile that a raw score is at within USA, or states 

# USE LOOKUPS ####

# ejanalysis::lookup.pctile		Find approx wtd percentiles in lookup table that is in memory




# OTHER
 # gtExtras::gt_plt_percentile		Create a dot plot for percentiles
# Hmisc::bpplot		Box-percentile plots



# *** ALSO MAYBE JUST USE  lookup tables at:  https://ejscreen.epa.gov/arcgis/rest/services/ejscreen/ejscreen_v2021/MapServer/8


# c(names.d, names.e, names.ej, names.d.subgroups)
# library(ejscreen)
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

bg <- ejscreen::bg21plus  # BUT THIS LACKS PR !

# NOT WORKING YET:
# stop('in progress') #     vars_needing_pctile_in_lookup_table <- vars_needing_pctile_in_lookup_table[1:3]
# slow as written, even just for USA overall:
lookupUSA  <- ejanalysis::write.wtd.pctiles.by.zone(
  mydf = bg[ , vars_needing_pctile_in_lookup_table],
  wts = bg$pop,
  filename =  'lookupUSA_21plusDsub_noPR')

# NOTE COMPARE/ RECONCILE:
# ejscreen::lookupUSA   Rfriendly names
# EJAM::usastats        had been using old gdbnames still

# lookupRegions <- ejanalysis::write.wtd.pctiles.by.zone(
#   mydf = bg[ , vars_needing_pctile_in_lookup_table],
#   wts = bg$pop,
#   zone.vector = bg$REGION,
#   filename =  'lookupRegions')

if (!('ST' %in% names(bg))) {
  message('requires a column called ST to create lookup table of percentiles')
} else {
#   lookupStates <- write.wtd.pctiles.by.zone(
# mydf = bg[bg$ST %in% c('NY','DE') , vars_needing_pctile_in_lookup_table[1:3]],
# wts = bg$pop[bg$ST %in% c('NY','DE')],
# zone.vector = bg$ST[bg$ST %in% c('NY','DE')], filename = 'lookupStatesTEST.csv')

  lookupStates <-  ejanalysis::write.wtd.pctiles.by.zone(
    mydf = bg[ , vars_needing_pctile_in_lookup_table],
    wts = bg$pop,
    zone.vector = bg$ST,
    filename =  'lookupStates')
  # filename =  'lookupStates_plusDsub_noPR') # but now should have PR






  }


# ejscreen::lookupUSA
# one simple way is put the info all in one field called 'year':
attr(lookupUSA, 'year')    <- 'EJScreen 2.0 bg21 ACS2015-2019 no PR'
attr(lookupUSA, 'ACS')    <- 'ACS2015-2019 no PR'
attr(lookupUSA, 'ejscreen_version')    <- 'EJScreen 2.0'
attr(lookupUSA, 'released')    <- '2022'

attr(lookupStates, 'year') <- 'EJScreen 2.0 bg21 ACS2015-2019 no PR'
attr(lookupStates, 'ACS')    <- 'ACS2015-2019 no PR'
attr(lookupStates, 'ejscreen_version')    <- 'EJScreen 2.0'
attr(lookupStates, 'released')    <- '2022'

usethis::use_data(lookupUSA)
usethis::use_data(lookupStates)
