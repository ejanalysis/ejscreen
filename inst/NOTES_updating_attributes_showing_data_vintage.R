# setting attributes on datasets that make clear their vintage

# note: The 2017-2021 American Community Survey 5-year estimates are scheduled to be released on Thursday, December 8, 2022.

library(EJAM)
# GO TO THE WORKING DIRECTORY OF THE RIGHT PACKAGE TO DO THESE UPDATES:


head(t(  usastats[usastats$PCTILE == 'mean', ]))
head(t(statestats[usastats$PCTILE == 'mean', ]))
# PUERTO RICO NOT INCLUDED?


# set attributes to store metadata on vintage
metadata <- list(
  census_version = 2020,
  acs_version = '2016-2020',
  acs_releasedate = '3/17/2022',
  ejscreen_version = '2.1',
  ejscreen_releasedate = 'September 2022',
  ejscreen_pkg_data = 'bg22'
)
  attributes(bg22) <- c(attributes(bg22), metadata)







# older set of attributes:

 attr(usastats,    which = 'released') <- 2022
 attr(usastats,    which = 'ejscreen_version') <- '2.0'
 attr(usastats,    which = 'ACS') <- '2015-2019'
 # usethis::use_data(usastats, overwrite = TRUE)
 # √ Saving 'usastats' to 'data/usastats.rda'
 # * Document your data (see 'https://r-pkgs.org/data.html')
 
 attr(regionstats, which = 'released') <- 2022
 attr(regionstats, which = 'ejscreen_version') <- '2.0'
 attr(regionstats, which = 'ACS') <- '2015-2019'
 # usethis::use_data(regionstats, overwrite = TRUE)
 ### √ Saving 'regionstats' to 'data/regionstats.rda'
 ### * Document your data (see 'https://r-pkgs.org/data.html')
 
 attr(statestats,  which = 'released') <- 2022
 attr(statestats,  which = 'ejscreen_version') <- '2.0'
 attr(statestats,  which = 'ACS') <- '2015-2019'
 # usethis::use_data(statestats, overwrite = TRUE)
 ### √ Saving 'statestats' to 'data/statestats.rda'
 ### * Document your data (see 'https://r-pkgs.org/data.html')
 
 
 rdattr()
#                      year ACS         released     ejscreen_version
# blockgroupstats      2021 "2015-2019" "early 2022" "2.0"           
 
# usastats             NULL "2015-2019" 2022         "2.0"     
# regionstats          NULL "2015-2019" 2022         "2.0"           
# statestats           NULL "2015-2019" 2022         "2.0"           
 
# stateinfo            NULL NULL        NULL         NULL            
# stateregions         NULL NULL        NULL         NULL            
# statesshp            NULL NULL        NULL         NULL            
 
# NAICS                2017 NULL        2022         NULL            
 
# points1000example    NULL NULL        NULL         NULL            
# points100example     NULL NULL        NULL         NULL            
# sites2blocks_example NULL NULL        NULL         NULL            



