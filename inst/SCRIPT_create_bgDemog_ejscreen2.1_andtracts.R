
##################################################################### #
# libraries not on CRAN (on github) are needed for this script
#
library(ejscreen); library(ejanalysis); library(analyze.stuff); require(ACSdownload)

##################################################################### #
# specify file directory
#
mydir <- './acstest'
if (!dir.exists(mydir)) dir.create(mydir) # and the ejscreen.acsget will create subfolders by default

##################################################################### #
# set metadata on vintage ####
#
metadata <- list(
  census_version = 2020,
  acs_version = '2016-2020',
  acs_releasedate = '3/17/2022',
  ejscreen_version = '2.1',
  ejscreen_releasedate = 'October 2022',
  ejscreen_pkg_data = 'bg22'
)
addmeta <- function(x, meta) {attributes(x) <- c(attributes(x), meta); return(x)}

##################################################################### #
# DOWNLOAD TABLE(S) ####
#
acsdata_B03002 <- ejscreen::ejscreen.acsget(tables = 'B03002',
                                  end.year = 2020,
                                  base.path = mydir, sumlevel = 'both' )
# 6 minutes (or up to 10 minutes?) slow - downloads each state
names(acsdata_B03002) # "bg"      "tracts"  "headers" "info"
acsdata_B03002 <- addmeta(acsdata_B03002, metadata)

##################################################################### #
# block group dataset ####
#
bgACS   <- ejscreen.acs.rename(acsdata_B03002$bg) # returns it with new column names
names(bgACS) <- gsub('pop3002', 'pop', names(bgACS))
bgACS   <- ejscreen.acs.calc(bgACS)
bgACS <- bgACS[,!grepl('1$',names(bgACS))] # remove duplicate columns
bgACS <- addmeta(bgACS, metadata)
# # LOOK AT/ CHECK THIS DATASET
names(bgACS)
summary(bgACS)
head(bgACS)
hist(bgACS$pcthisp, 100)  # write.csv(bgACS, file = 'demographics.csv', row.names = FALSE)
# to SEE WHAT THOSE FIELDS ARE DEFINED AS
z <- subset.data.frame(x = ejscreenformulas, subset = ejscreenformulas$Rfieldname %in% names(bgACS), select = c('Rfieldname', 'acsfieldname', 'acsfieldnamelong', 'formula'))
z[ , c('acsfieldnamelong', 'acsfieldname' , 'Rfieldname')]
z[ , c('Rfieldname', 'formula')]
# formulas_etc <- z
# acsdata_B03002$formulas_etc <- formulas_etc
#
bg22DemographicSubgroups2016to2020 <- bgACS
rm(bgACS)
usethis::use_data(bg22DemographicSubgroups2016to2020)  # or merge with bg22 and just use bg22plus

##################################################################### #
# save tract dataset ####
#
tractACS  <- ejscreen.acs.rename(acsdata_B03002$tracts)
names(tractACS) <- gsub('pop3002', 'pop', names(tractACS))
tractACS   <- ejscreen.acs.calc(tractACS)
tractACS <- tractACS[,!grepl('1$',names(tractACS))] # remove duplicate columns
tractACS <- addmeta(tractACS, metadata)
tract22DemographicSubgroups2016to2020  <- tractACS
rm(tractACS)
usethis::use_data(tract22DemographicSubgroups2016to2020)

##################################################################### #
# save raw ACS tables as downloaded ####
#
# (no calculated fields like percent low income) with MOE etc.
acs_B03002_2016_2020_bg_tract <- acsdata_B03002
usethis::use_data(acs_B03002_2016_2020_bg_tract)
# save(acs_B03002_2016_2020_bg_tract, file = './inst/acs_B03002_2016_2020_bg_tract.rdata')
# that preserves all the margin of error data columns (as original colnames) and the extra info on each column like long name short name etc
rm(acsdata_B03002)

##################################################################### #
