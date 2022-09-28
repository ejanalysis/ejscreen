#' helper function for package to set attributes of a dataset
#'
#'
#'  This can be used annually to update some datasets in a package.
#'  It just makes it easier to set a few metadata attributes similarly
#'  for a number of data elements, for example,
#'  to add new or update existing attributes.
#' @param x dataset (or any object) whose metadata you want to update or create
#' @param metadata must be a named list, so that the function can do this for each i:
#'   attr(x, which=names(metadata)[i]) <- metadata[[i]]
#'
#' @return returns x but with new or altered attributes
#' @export
#'
#' @examples
#'   x <- data.frame(a=1:10,b=1001:1010)
#'   x <- add_metadata(x, list(year_created=1984, status='draft', owner='orwell'))
#'   attributes(x)
#'   x <- add_metadata(x, list(status='final'))
#'   attr(x,'status')
add_metadata <- function(x, metadata) {

  if (missing(metadata)) {
    metadata <- list(
      census_version = 2020,
      acs_version = '2016-2020',
      acs_releasedate = '3/17/2022',
      ejscreen_version = '2.1',
      ejscreen_releasedate = 'October 2022',
      ejscreen_pkg_data = 'bg22'
    )
  }
  if (!is.list(metadata)) {stop('metadata has to be a named list')}
  for (i in seq_along(metadata)) {
    attr(x, which = names(metadata)[i]) <- metadata[[i]]
  }
  return(x)
}
