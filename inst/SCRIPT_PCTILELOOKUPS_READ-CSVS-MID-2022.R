# script to read lookup tables from csv, add metadata, save as datasets in R package

# function to read percentile lookup tables, ####
#  and process and maybe save the percentile lookup tables
read_to_save_as_data <- function(myname, mydir=getwd(), justread=TRUE, rename=FALSE, mynewname=NULL, attributelist_to_add) {
  x <- as.data.frame(readr::read_csv(paste0(file.path(mydir, 'inst', myname), '.csv')))
  if (!is.null(mynewname)) {myname <- mynewname}
  if (rename) {
    names(x) <- change.fieldnames.ejscreen.csv(names(x))
    cat('rename columns \n')
  }
  attributes(x) <- c(attributes(x), attributelist_to_add)
  # BUT THAT APPENDS EVEN IF WANT TO REPLACE WITH UPDATED INFO
  if (!justread) {
    assign(myname, x)  # lookupUSA <- x
    save(list = myname, file = paste0(file.path(mydir, 'data', myname), '.rda'))
    # usethis::use_data(dynGet(myname)) # this does not work, actually, since get or dynGet dont work for this
  } else {
    cat('\n If you have read it as such, you can enter this: \n\n usethis::use_data(', myname, ')\n')
    invisible(x)
  }
}

# specify folder ####
if (analyze.stuff::os() != 'win') {
  mydir <- '~/Documents/R PACKAGES/ejscreen'
} else {
  mydir <- '~/../Documents/R/mypackages/ejscreen'
}

stop('here')


######################## #
# add metadata to pctile lookups ####
# LOOKUP TABLES OF PERCENTILES

# "2022 version" (EJScreen version 2.1, bg22, ACS2020, after 7/2022)
# metadata <- list(
#   census_version = 2020,
#   acs_version = '2016-2020',
#   acs_releasedate = '3/17/2022',
#   ejscreen_version = '2.1',
#   ejscreen_releasedate = 'October 2022',
#   ejscreen_pkg_data = 'bg22'
# )
# for (i in seq_along(metadata)) {attr(x, which = names(metadata)[i]) <- metadata[i]}
USA_2022_LOOKUP <- NULL; States_2022_LOOKUP <- NULL
USA_2022_LOOKUP <-    read_to_save_as_data(   'USA_2022_LOOKUP', mydir=mydir, rename = FALSE, attributelist_to_add = metadata)
States_2022_LOOKUP <- read_to_save_as_data('States_2022_LOOKUP', mydir=mydir, rename = FALSE, attributelist_to_add = metadata)
# save these with original column names as used on FTP site and in GDB
usethis::use_data(   USA_2022_LOOKUP, overwrite = TRUE)
usethis::use_data(States_2022_LOOKUP, overwrite = TRUE)

# now save versions with friendly names (but note file name might be confusing if two version kept with just renamed columns)
lookupUSA <- USA_2022_LOOKUP
lookupStates <- States_2022_LOOKUP
names(lookupStates) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupStates))
names(lookupUSA) <- ejscreen::change.fieldnames.ejscreen.csv(names(lookupUSA))
usethis::use_data(   lookupUSA, overwrite = TRUE)
usethis::use_data(lookupStates, overwrite = TRUE)

# delete older versions

file.remove(file.path(mydir, 'data', 'lookupUSA2022.rdata'))
file.remove(file.path(mydir, 'data', 'lookupStates2022.rdata'))

file.remove(file.path(mydir, 'data', 'lookupUSA2021.rdata'))
file.remove(file.path(mydir, 'data', 'lookupStates2021.rdata'))

file.remove(file.path(mydir, 'data', 'lookupUSA20.rdata'))
file.remove(file.path(mydir, 'data', 'lookupStates20.rdata'))
file.remove(file.path(mydir, 'data', 'lookupRegions20.rdata'))

# optional:

# "2021 version" (EJScreen version 2.0, bg21, ACS2019, through 6/2022)
metadata <- list(releasedate = 'early 2022', ejscreen_version = '2.0', ACS_version = '2015-2019')
USA_2021_LOOKUP =    read_to_save_as_data(   'USA_2021_LOOKUP', mydir=mydir, rename = FALSE, attributelist_to_add = metadata)
States_2021_LOOKUP = read_to_save_as_data('States_2021_LOOKUP', mydir=mydir, rename = FALSE, attributelist_to_add = metadata)
usethis::use_data(   USA_2021_LOOKUP, overwrite = TRUE)
usethis::use_data(States_2021_LOOKUP, overwrite = TRUE)

# the name had been this:
# lookupStates2021

# older notes:
# lookupUSA2022 <- as.data.frame(readr::read_csv(paste0(mydir, 'ejscreen/inst/USA_2022_LOOKUP.csv')))
# # save(lookupUSA2022, file = paste0(mydir, 'ejscreen/data/lookupUSA2022.rdata'))
# # or
# usethis::use_data(lookupUSA2022)
#
# lookupStates2022 <- as.data.frame(readr::read_csv(paste0(mydir, 'ejscreen/inst/States_2022_LOOKUP.csv')))
# save(lookupStates2022, file = paste0(mydir, 'ejscreen/data/lookupStates2022.rdata'))
# # or
# usethis::use_data(lookupStates2022)

