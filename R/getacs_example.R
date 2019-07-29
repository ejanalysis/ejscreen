
if (1 == 0) {

#

  # script to download and clean up and calc ACS Demog fields used in EJSCREEN

  acs2017 <- ejscreen.acsget(end.year = '2017',
                               tables = c('B01001', 'B03002', 'B15002', 'C17002', 'B25034'), #B16002 language spoken - was in 2015 file not subsequent ones
                               base.path = '~/Downloads',
                               vars = 'all',
                               write.files = TRUE, save.files = TRUE,
                               new.geo = FALSE)
  save(acs2017, file = '~/Downloads/acsoutput/acs2017.rdata')
  bgacs2017 <- acs2017$bg
  bgacs2017 <- ejscreen.acs.rename(bgacs2017)
  bgacs2017 <- ejscreen.acs.calc(bgacs2017, keep.old = 'all', keep.new = 'all')

  save(bgacs2017, file = '~/Downloads/acsoutput/bgacs2017.rdata')

}
