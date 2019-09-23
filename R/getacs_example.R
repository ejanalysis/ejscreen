
if (1 == 0) {

  # see also NOTES-on-reading-EJSCREEN-2019-from-gdb-...

  # notes on creating ACS2017 dataset that has fuller demog and county info


  # also see data(bg17, package = 'ejscreen') # but that has fewer demog fields (lacks pctpoor, pcthisp, etc.??)
# But EJSCREEN dataset from FTP site DOES have pctpoor, pcthisp, etc.
  # What ACS has that is not in FTP site is demographic subgroups like nhwa


  # script to download and clean up and calc ACS Demog fields used in EJSCREEN

  # 2017 version shown here but 2018 also done in 2019.

  require(ejscreen)
  require(ACSdownload)
  require(analyze.stuff)
  require(ejanalysis)

  if (os('win')) {
    # setwd('~/../Desktop/EJ 2018 all work/GRANTS 2019 WORK')
    setwd('~/../Desktop/EJ 2018 all work/GRANTS 2019 WORK/EPA acsoutput 2013-2017 EJSCREEN tables all fields plus calc')
  }

  acs2017 <- ejscreen.acsget(end.year = '2017',
                             tables = c('B01001', 'B03002', 'B15002', 'C17002', 'B25034'), #B16002 language spoken - was in 2015 file not subsequent ones
                             base.path = '~/Downloads',
                             vars = 'all',
                             write.files = TRUE, save.files = TRUE,
                             new.geo = FALSE)
  save(acs2017, file = '~/Downloads/acsoutput/acs2017.rdata')

  # # headers and info are useful but have raw acs names not nice new names
  headers <- acs2017$headers
  head(acs2017$headers)
  write.csv(headers, file = 'headers ACS 2013-2017 EJ tables more fields.csv')
  head(acs2017$info)

  tracts <- acs2017$tracts
  tracts <- ejscreen.acs.rename(tracts)
  tracts <- ejscreen.acs.calc(tracts, keep.old = 'all', keep.new = 'all')
  save(tracts, file = '~/Downloads/acsoutput/tracts.rdata')

  bgacs2017 <- acs2017$bg
  bgacs2017 <- ejscreen.acs.rename(bgacs2017)
  bgacs2017 <- ejscreen.acs.calc(bgacs2017, keep.old = 'all', keep.new = 'all')
  #save(bgacs2017, file = '~/Downloads/acsoutput/bgacs2017.rdata')

  bg <- bgacs2017
  rm(bgacs2017) # nicer name

  bg <- ejscreen::addFIPScomponents(bg)
  bg <- analyze.stuff::put.first(bg, 'countyname')
  bg <- analyze.stuff::put.first(bg, 'FIPS')

  save(bg, 'bg ACS 2013-2017 EJ tables more fields plus calculated renamed.rdata')
  write.csv(bg, file = 'bg ACS 2013-2017 EJ tables more fields plus calculated renamed.csv')

  tracts <- ejscreen::addFIPScomponents(tracts)
  tracts <- analyze.stuff::put.first(tracts, 'countyname')
  tracts <- analyze.stuff::put.first(tracts, 'FIPS')

  save(tracts, 'tracts ACS 2013-2017 EJ tables more fields plus calculated renamed.rdata')
  write.csv(tracts, file = 'tracts ACS 2013-2017 EJ tables more fields plus calculated renamed.csv')


  names(bg)
  names(bg)[!grepl('00', names(bg))]
  head(bg[ , 1:12])

  hist(tracts$pct1pov, 100)

}
