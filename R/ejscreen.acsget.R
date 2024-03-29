#' Download ACS tables EJSCREEN uses, but with more race ethnicity poverty details
#'
#' @description
#'   EJScreen 2.0 was latest as of June 2022, released early 2022, and
#'     actually used ACS2019, which is from 2015-2019 (released late 2020).
#'
#' Helper function used by ejscreen.create, but can be used if one wants to 
#'   obtain the more detailed relevant ACS data.
#'   The EJSCREEN-related ACS tables have more of the detailed fields than the 
#'   demographic data on the EJSCREEN FTP site, because the detailed fields are
#'   used to calculate the ones retained for EJSCREEN, such as 
#'   percent non-hispanic black alone, percent hispanic, percent poor 
#'   (<1x poverty line) not just percent low income (<2x poverty line), etc.
#' @details Tables can include the EJScreen 2.1 tables:
#'  mytables <- c(
#'   "B01001","B03002","B15002",'B23025',"B25034","C16002","C17002")
#'  myurl <- paste0('https://data.census.gov/cedsci/table?q=acs%20', 
#'    paste(mytables, collapse= '%20'), '&y=2020')
#'  browseURL(myurl)
#'  # <https://data.census.gov/cedsci/table?q=acs%20B01001%20B03002%20B15002%20B23025%20B25034%20C16002%20C17002&y=2020>
#'  \preformatted{
#'  ACSdownload::get.field.info(mytables, table.info.only = TRUE)[ , 1:2]
#'           ID                                                          title
#'   # 1 B01001                                                       SEX BY AGE
#'   # 2 B03002                                HISPANIC OR LATINO ORIGIN BY RACE
#'   # 3 B15002 SEX BY EDUCATIONAL ATTAINMENT FOR POPULATION 25 YEARS AND OVER
#'   # 4 B23025           EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER
#'   # 5 B25034                                             YEAR STRUCTURE BUILT
#'   # 6 C16002  HOUSEHOLD LANGUAGE BY HOUSEHOLD LIMITED ENGLISH SPEAKING STATUS
#'   # 7 C17002           RATIO OF INCOME TO POVERTY LEVEL IN THE PAST 12 MONTHS
#'
#'  }
#'  # C16002 replaced B16004 that was older ACS source for what had been called 
#'  linguistic isolation, now called limited English speaking households.
#'  
#'   Details on language spoken: 
#'   
#'  [www2.census.gov/topics/language-use/acs/acs_tabulations-language-list.pdf]
#'  
#'    <https://data.census.gov/cedsci/table?q=acs%20c16002&y=2020>
#'
#' @param end.year optional character year like 2020 specifying last of 5 years of ACS summary file
#' @param base.path optional, default is working directory; folder in which data.path and output.path subfolders are or will be created
#' @param data.path see ACSdownload::get.acs()
#' @param output.path  see ACSdownload::get.acs()
#' @param sumlevel Default here is just bg but see ACSdownload::get.acs()
#' @param vars Default here is 'all' vars which is more than what \link{ejscreen.create} keeps.
#'   (or can be a vector of things like 'B01001')
#' @param write.files Default here is TRUE but see ACSdownload::get.acs()
#' @param tables Default is the ones needed for EJSCREEN - character vector list of Census data tables like B01001
#' @param ...  passed to ACSdownload::get.acs()
#'
#' @return list of data.frames, default is just block group not tracts, unlike results of ACSdownload::get.acs()
#' @examples
#'  mytables <- c("B01001", "B03002", "B15002", 'B23025', "B25034", "C16002", "C17002")
#'  myurl <- paste0('https://data.census.gov/cedsci/table?q=acs%20', paste(mytables, collapse= '%20'), '&y=2020')
#'  # browseURL(myurl)
#' @export
#'
ejscreen.acsget <- function(end.year = '2020',
                            tables = c("B01001", "B03002", "B15002", "C16002", "C17002", "B25034", 'B23025'),
                            base.path = getwd(), data.path = file.path(base.path, 'acsdata'), output.path = file.path(base.path, 'acsoutput'),
                            vars = 'all', sumlevel = 'bg', write.files = TRUE, ...) {
# require(ACSdownload) # not sure how to avoid this if we want access to lookup.acs2017 and similar data in that pkg
  x <- ACSdownload::get.acs(end.year = end.year,
               tables = tables, #B16002 language spoken - was in 2015 file but b16004 later
               #tables = 'ejscreen', # failed once B16002 not avail and ACSdownload was not updated to leave that table out for later end.year values
                            base.path = base.path,
                            data.path = data.path,
                            output.path = output.path,
                            sumlevel = sumlevel,
                            vars = vars,
                            write.files = write.files, ...)
  return(x)

}
