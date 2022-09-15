#' helper function in updating the package metadata
#'
#' @param package e.g. 'ejscreen'
#' @param which a vector (not list) of strings, the attributes
#'
#' @export
#'
rdattr <- function(package='EJAM', which=c('census_version', 'acs_version', 'acs_releasedate', 'ejscreen_version', 'ejscreen_releasedate', 'ejscreen_pkg_data', 'year', 'ACS', 'released')) {
  # census_version = 2020,
  # acs_version = '2016-2020',
  # acs_releasedate = '3/17/2022',
  # ejscreen_version = '2.1',
  # ejscreen_releasedate = 'October 2022',
  # ejscreen_pkg_data = 'bg22'

  # The 2017-2021 American Community Survey 5-year estimates are scheduled to be released on Thursday, December 8, 2022.

  get1attribute <- function(x, which) try(attr(get(x), which = which))
  # utility to check if year attribute is set on each data file
  if (!isNamespaceLoaded(package)) {stop('package not loaded')}
  rdafiles <- data(package=package)
  rdafiles <- rdafiles$results[,'Item']
  rdafiles <- gsub(' .*' ,'', rdafiles)
  if (length(which) == 1) {
    results <- cbind(sapply(rdafiles, FUN = get1attribute, which))
    colnames(results) <- which
  } else {
    results <- list()
    for (i in 1:length(which)) {
      results[[i]] <- cbind(sapply(rdafiles, FUN = get1attribute, which[i]))
    }
    results <- do.call(cbind, results)
    colnames(results) <- which
  }
 return(results)
}

# rdattr()
# library(ejscreen)
# rdattr(which=c('year', 'ACS'), package = 'ejscreen')
# rdattr(which=c('year', 'ACS', 'released', 'ejscreen_version'), package = 'ejscreen')
