# finish cleaning up and including in package the lookup tables

# need to document these
# ejscreen::USA_2022_LOOKUP, ejscreen::States_2022_LOOKUP
# same essentially:
# EJAM::usastats, EJAM::statestats

library(ejscreen)
bg <- ejscreen::bg22 #plus # or other

# use preferred variable names as colnames
names(   USA_2022_LOOKUP) <- change.fieldnames.ejscreen.csv(names(ejscreen::USA_2022_LOOKUP))
names(States_2022_LOOKUP) <- change.fieldnames.ejscreen.csv(names(ejscreen::States_2022_LOOKUP))
# str(USA_2022_LOOKUP)

# make lookup tables for demographic subgroups or user-specified indicators
lookupUSA_extra    <- write.wtd.pctiles.by.zone(mydf = bg[ , names.d.subgroups], wts = NULL, filename = 'lookupUSA_extra.csv')
lookupStates_extra <- write.wtd.pctiles.by.zone(mydf = bg[ , names.d.subgroups], wts = NULL, zone.vector = bg$ST, filename = 'lookupStates_extra.csv')
## maybe add those to one of the lookup tables already being used
# USA_2022_LOOKUP  <- cbind(USA_2022_LOOKUP, lookupUSA_extra)
# usastats         <- cbind(usastats,        lookupUSA_extra)
##  and same for States
# States_2022_LOOKUP <- cbind(States_2022_LOOKUP, lookupStates_extra)
# statestats         <- cbind(statestats,         lookupStates_extra)

# TO FIX/ CREATE METADATA
attr(USA_2022_LOOKUP, "releasedate")      <- NULL # Remove metadata to be replaced with better version
attr(USA_2022_LOOKUP, 'ejscreen_version') <- NULL
attr(USA_2022_LOOKUP, 'ACS_version')      <- NULL
attr(States_2022_LOOKUP, "releasedate")      <- NULL # Remove metadata to be replaced with better version
attr(States_2022_LOOKUP, 'ejscreen_version') <- NULL
attr(States_2022_LOOKUP, 'ACS_version')      <- NULL
  USA_2022_LOOKUP    <- ejscreen::add_metadata(USA_2022_LOOKUP)
  States_2022_LOOKUP <- ejscreen::add_metadata(States_2022_LOOKUP)
  #  or/and
  # usastats <- EJAM::metadata_add(usastats)

# To use in this package
usethis::use_data(   USA_2022_LOOKUP, overwrite = TRUE)
usethis::use_data(States_2022_LOOKUP, overwrite = TRUE)

