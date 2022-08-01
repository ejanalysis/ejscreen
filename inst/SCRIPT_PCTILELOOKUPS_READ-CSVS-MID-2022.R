



lookupUSA2021 <- as.data.frame(readr::read_csv('~/../Documents/R/mypackages/ejscreen/inst/USA_2021_LOOKUP.csv'))
save(lookupUSA2021, file = '~/../Documents/R/mypackages/ejscreen/data/lookupUSA2021.rdata')

lookupUSA2021 <- as.data.frame(readr::read_csv('~/../Documents/R/mypackages/ejscreen/inst/States_2021_LOOKUP.csv'))
save(lookupUSA2021, file = '~/../Documents/R/mypackages/ejscreen/data/lookupStates2021.rdata')




lookupUSA2022 <- as.data.frame(readr::read_csv('~/../Documents/R/mypackages/ejscreen/inst/USA_2022_LOOKUP.csv'))
save(lookupUSA2022, file = '~/../Documents/R/mypackages/ejscreen/data/lookupUSA2022.rdata')

lookupUSA2022 <- as.data.frame(readr::read_csv('~/../Documents/R/mypackages/ejscreen/inst/States_2022_LOOKUP.csv'))
save(lookupUSA2022, file = '~/../Documents/R/mypackages/ejscreen/data/lookupStates2022.rdata')
