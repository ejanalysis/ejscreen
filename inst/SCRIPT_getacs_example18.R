#
# This script is not necessary if you already have the EJSCREEN datasets from the ejscreen R package,
#  (which does provide some extra data beyond what is on the EJSCREEN FTP site.)
#  The extra demographics are now in data(bg21DemographicSubgroups2015to2019)
#
#
# This script obtains all the demographic fields used in EJSCREEN
# not just the demographic subgroups
# plus this script obtains countyname, statename, lat/lon of the blockgroup internal point.
# In other words,
# This script just shows how to replicate the demographic indicators in EJSCREEN
# starting from the ACS data on the Bureau of Census website,
# and how to create a few additional fields that are in the ejscreen package.


# For just EJSCREEN data,
# see data(bg19, package = 'ejscreen') or bg20, bg17, bg18 data also
# and maybe also see NOTES-on-reading-EJSCREEN-2019-from-gdb-...
#
# EJSCREEN dataset from FTP site has just
#  count and pct for lowinc, min, lingiso, povknownratio, builtunits, etc.

# but EJSCREEN on FTP site does NOT have these which ejscreen R pkg does:

#  *** demog subgroups, like percent hispanic, nonhispanic white alone (nhwa), nhba, etc.
#  *** poverty rate (as opposed to just lowincome), as pctpoor or count
#  ACS does have this extra demographic info.

#  * extra FIPS / geo info like statename, countyname, tract fips,
#    and latitude/ longitude of block group internal point,
#    but all those are added to bg17, bg18, bg19 datasets.

#  * flag for 80th percentile nationwide,
#    but that is in bg17,bg18,bg19.

#   VINTAGE:
#
#    Note the 2020 version of EJSCREEN released mid 2020
#     actually uses ACS2018, which is from 2014-2018 (released late 2019).
#   Note the 2019 version of EJSCREEN (released late 2019)
#     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#   Note the 2018 version of EJSCREEN (released late 2018)
#     actually uses ACS2016, which is from 2012-2016 (released late 2017).



if (1 == 0) {
  ####################### #
  require(ejscreen)
  require(ACSdownload)
  require(analyze.stuff)
  require(ejanalysis)

  # Example for 2014-2018 ACS version shown here.
  # ACS 2014-2018 data SHOULD BE FULLY AVAILABLE AND DOCUMENTED FROM CENSUS BY DECEMBER 2019?
  # e.g. as of 9/25/2019, the 5-yr summary file info for 2014-2018 data is not yet here:
  # https://www2.census.gov/programs-surveys/acs/summary_file/2018/documentation/user_tools/

  yr <- '2018'
  if (analyze.stuff::os('win')) {
    setwd('~/../Desktop/EJ 2018 all work/ACS18 data 2014-2018')
  }


  acs <- ejscreen.acsget(end.year = yr,
                             tables = c('B01001', 'B03002', 'B15002', 'C17002', 'B25034', 'B16004'),
                         # in ACS2020 C16002 replaced B16004 that was older ACS source for what had been called linguistic isolation, now called limited English speaking households.
                         base.path = '~/Downloads',
                             vars = 'all',
                             write.files = TRUE, save.files = TRUE,
                             new.geo = FALSE)
  save(acs, file = paste('acs', yr, '.rdata', sep = ''))

  # # headers and info are useful but have raw acs names not nice new names
  headers <- acs$headers
  head(acs$headers)
  write.csv(headers, file = paste('headers ACS ', yr,' EJ tables more fields.csv', sep = ''))
  head(acs$info)

  tracts <- acs$tracts
  tracts <- ejscreen.acs.rename(tracts)
  tracts <- ejscreen.acs.calc(tracts, keep.old = 'all', keep.new = 'all')
  save(tracts, file = '~/Downloads/acsoutput/tracts.rdata')

  bgacs <- acs$bg
  bgacs <- ejscreen.acs.rename(bgacs)
  bgacs <- ejscreen.acs.calc(bgacs, keep.old = 'all', keep.new = 'all')
  #save(bgacs, file = '~/Downloads/acsoutput/bgacs.rdata')

  bg <- bgacs
  rm(bgacs) # nicer name

  bg <- ejanalysis::addFIPScomponents(bg)
  bg <- analyze.stuff::put.first(bg, 'countyname')
  bg <- analyze.stuff::put.first(bg, 'FIPS')

  save(bg, paste('bg ACS ', yr,' EJ tables more fields plus calculated renamed.rdata', sep = ''))
  write.csv(bg, file = paste('bg ACS ', yr, ' EJ tables more fields plus calculated renamed.csv', sep = ''))

  tracts <- ejanalysis::addFIPScomponents(tracts)
  tracts <- analyze.stuff::put.first(tracts, 'countyname')
  tracts <- analyze.stuff::put.first(tracts, 'FIPS')

  save(tracts, paste('tracts ACS ', yr, ' EJ tables more fields plus calculated renamed.rdata', sep = ''))
  write.csv(tracts, file = paste('tracts ACS ', yr, ' EJ tables more fields plus calculated renamed.csv', sep = ''))


  names(bg)
  names(bg)[!grepl('00', names(bg))]
  head(bg[ , 1:12])

  hist(tracts$pct1pov, 100)

}
