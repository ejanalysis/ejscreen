rdattr <- function(package='EJAM', which=c('year', 'ACS', 'released', 'ejscreen_version')) {
  
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
