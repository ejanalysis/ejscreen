#   ######################################################################################
#     # HOW TO DOWNLOAD ACS TABLE WITH RACE ETHNICITY BY BLOCK GROUP
#     # AND CREATE PERCENT VARIABLES LIKE PERCENT HISPANIC, ETC.
#
#     # These are created: (count and percent hispanic or latino, nonhispanic white alone i.e. single race,
#   # nonhispanic black or african american alone, Not Hispanic or Latino American Indian and Alaska Native alone,
#   # Not Hispanic or Latino Native Hawaiian and Other Pacific Islander alone,
#   # and nh some other race alone, and nh two or more races)
#   # "hisp"            "nhwa"            "nhba"            "nhaiana"         "nhaa"            "nhnhpia"
#   # "nhotheralone"    "nhmulti"         "nonmins"         "pcthisp"         "pctnhwa"         "pctnhba"
#   # "pctnhaiana"      "pctnhaa"         "pctnhnhpia"      "pctnhotheralone" "pctnhmulti"

base.path <- '~/Downloads/acs1620'
if (!dir.exists(base.path)) dir.create(base.path)
oldpath <- getwd() # '~/Documents/R PACKAGES/ejscreen'
setwd(base.path)

library(ejscreen); library(ejanalysis); library(analyze.stuff); require(ACSdownload)
acsdata <- ejscreen::ejscreen.acsget(tables = 'B03002',
                                     end.year = 2020,
                                     base.path = base.path, sumlevel = 'both' )
## 10 minutes?? slow - downloads each state
bgACS   <- ejscreen.acs.rename(acsdata$bg)
names(bgACS) <- gsub('pop3002', 'pop', names(bgACS))
bgACS   <- ejscreen.acs.calc(bgACS)
rm(acsdata)
# head(bgACS); hist(bgACS$pcthisp,100)  # write.csv(bgACS, file = 'demographics.csv', row.names = FALSE)
# to SEE WHAT THOSE FIELDS ARE DEFINED AS
# subset.data.frame(x = ejscreenformulas, subset = ejscreenformulas$Rfieldname %in% names(bgACS), select = c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula'))
bg22DemographicSubgroups2016to2020 <- bgACS

metadata <- list(releasedate = 'late 2022', ejscreen_version = '2.1', ACS_version = '2016-2020')
attributes(bg22DemographicSubgroups2016to2020) <- c(attributes(bg22DemographicSubgroups2016to2020), metadata)



setwd(oldpath)  # setwd('~/Documents/R PACKAGES/ejscreen')
usethis::use_data(bg22DemographicSubgroups2016to2020)
##save(bg22DemographicSubgroups2016to2020, file = file.path('./data', 'bg22DemographicSubgroups2016to2020.rdata'))

