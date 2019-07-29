#' Download ACS tables EJSCREEN uses, but with more race ethnicity poverty details
#'
#' @description Helper function used by ejscreen.create, but can be used if one wants to obtain the more detailed relevant ACS data.
#'   The EJSCREEN-related ACS tables have more of the detailed fields than the demographic data on the
#'   EJSCREEN FTP site, because the detailed fields are used to calculate the ones
#'   retained for EJSCREEN, such as percent non-hispanic black alone, percent hispanic,
#'   percent poor (below 1x poverty line) not just percent low income (below 2x poverty line), etc.
#'
#' @param end.year optional character year like 2017 specifying last of 5 years of ACS summary file
#' @param base.path optional, default is working directory; folder in which data.path and output.path subfolders are or will be created
#' @param data.path see \link[ACDdownload]{get.acs}
#' @param output.path  see \link[ACDdownload]{get.acs}
#' @param sumlevel Default here is just bg but see \link[ACDdownload]{get.acs}
#' @param vars Default here is 'all' vars which is more than what \link{ejscreen.create} keeps.
#'   (or can be a vector of things like 'B01001')
#' @param write.files Default here is TRUE but see \link[ACDdownload]{get.acs}
#' @param ...  passed to \link[ACDdownload]{get.acs}
#'
#' @return list of data.frames, default is just block group not tracts, unlike results of \link[ACDdownload]{get.acs}
#' @export
#'
ejscreen.acsget <- function(end.year = '2017',
                            tables = c('B01001', 'B03002', 'B15002', 'C17002', 'B25034'),
                            base.path = getwd(), data.path = file.path(base.path, 'acsdata'), output.path = file.path(base.path, 'acsoutput'),
                            vars = 'all', sumlevel = 'bg', write.files = TRUE, ...) {
require(ACSdownload) # not sure how to avoid this if we want access to lookup.acs2017 and similar data in that pkg
  x <- get.acs(end.year = end.year,
               tables = tables, #B16002 language spoken - was in 2015 file not subsequent ones
               #tables = 'ejscreen', # failed once B16002 not avail and ACSdownload was not updated to leave that table out for later end.year values
                            base.path = base.path,
                            data.path = data.path,
                            output.path = output.path,
                            sumlevel = sumlevel,
                            vars = vars,
                            write.files = write.files, ...)
  return(x)

}