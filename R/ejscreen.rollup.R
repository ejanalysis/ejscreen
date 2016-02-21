#' @title Summarize EJSCREEN Dataset at Lower Resolution (e.g., Tracts)
#'
#' @description
#'   Start with full EJSCREEN dataset at one resolution (typically block groups), 
#'   and create summary at a higher geographic scale (e.g., tracts or counties)
#' @details **default fieldnames are assumed for now. Uses \code{\link{ejscreen.create}}
#' @param bg Data.frame of raw data for environmental and demographic counts, one row per block group typically, one column per indicator.
#' @param enames Default is \code{\link{names.e}}, the colnames of raw envt indicators in bg
#' @param sumnames Default is a vector of colnames in bg, those which should be rolled up as sums (e.g., sum of all block group population counts in the tract)
#' @param avgnames Default is a vector of colnames in bg, those which should be rolled up as weighted averages (e.g., pop wtd mean of air pollution level)
#' @param wts Default is 'pop', the colname in bg specifying the field to use when calculating the weighted mean of all blockgroups in a tract, for example.
#' @param acsnames Default is a vector of demographic colnames in bg, used in default ejscreen dataset (see code or \code{\link{ejscreenformulas}})
#' @param ... Optional parameters to pass to \code{\link{ejscreen.create}} which uses formulas to create indicators from raw values.
#' @param fipsname Default is 'FIPS.TRACT' - specifies colname of unique ID field FIPS used to group by. Can be FIPS.TRACT, FIPS.COUNTY, FIPS.ST, or REGION in default dataset.
#' @param scalename Not used. Default is 'tracts' - specifies text to use in naming the saved file.
#' @param folder Not used. Optional, default is getwd(). 
#' @return Returns a data.frame with ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, but not text for popups.
#'   Output has one row per tract, county, state, or region, depending on what is specified.
#' @examples
#'  \dontrun{
#'  load("~/Dropbox/EJSCREEN/R analysis/bg 2015-04-22 Rnames plus subgroups.RData")
#'  # Do this for each of several levels of resolution
#'  #
#' fipsnames <- c('FIPS.TRACT', 'FIPS.COUNTY', 'FIPS.ST', 'REGION')
#' scalenames <- c('tracts', 'counties', 'states', 'regions')
#' # or just for tracts, say this:
#' #   fipsnames <- 'FIPS.TRACT'; scalenames <- 'tracts'
#' 
#' for (i in 1:length(fipsnames)) {
#'   
#'   ######################################
#'   # Specify resolution of interest
#'   fipsname <- fipsnames[i] # 'FIPS.TRACT'
#'   scalename <- scalenames[i] # 'tracts'
#'   
#'   ######################################
#'   # Get results, using the function
#'   myrollup <- ejscreen.rollup(bg=bg, fipsname = fipsname, scalename = scalename)
#'   
#'   ######################################
#'   # Save results
#'   save(myrollup, file = paste('EJSCREEN 2015', scalename, 'data.RData') )
#'   write.csv(myrollup, row.names = FALSE, file = paste('EJSCREEN 2015', scalename, 'data.csv'))
#'   
#' }
#' 
#'  }
#'  @seealso \code{\link{ejscreen.create}}
#' @export
ejscreen.rollup <- function(bg, fipsname='FIPS.TRACT', scalename='tracts', enames, folder=getwd(), sumnames, avgnames, wts, ...) {
  
  ######################################
  # Get packages (available via http://www.ejanalysis.com)
  # require(analyze.stuff); require(ejanalysis); require(ejscreen)
  #data(names.dvars)
  
  ######################################
  # Get the wtd.mean for E (and other maybe some other fields?)
  data(names.evars)
  if (missing(enames)) {enames <- names.e}
  if (missing(avgnames)) {avgnames <- enames}
  if (missing(wts)) {wts <- bg$pop}
  tracts.avg   <- rollup(bg[ , avgnames], wts=wts, by = bg[ , fipsname], prefix = '' )
  names(tracts.avg) <- gsub('by', fipsname, names(tracts.avg))
  tracts.avg$sum.no.wts.used <- NULL
  
  ######################################
  # Get the sum for raw count fields and area (assuming here you've already calculated the blockgroup demographics)
  if (missing(sumnames)) {
    sumnames <- c('pop', 'povknownratio', 'age25up', 'hhlds', 'builtunits', 
                  'mins', 'lowinc', 'lths', 'lingiso', 'under5', 'over64', 
                  'VNI.eo', 'VNI.svi6', 'VDI.eo', 'VDI.svi6',
                  'hisp', 'nhaa', 'nhaiana', 'nhba',  'nhmulti', 'nhnhpia', 'nhotheralone', 'nhwa', 'nonmins', 
                  'area', 
                  'pre1960')
  }
  tracts.sum <- rollup(bg[ , sumnames], by=bg[ , fipsname], FUN=sum, prefix = '')
  names(tracts.sum) <- gsub('by', fipsname, names(tracts.sum))
  tracts.sum$sum.no.wts.used <- NULL
  
  ######################################
  # Merge sums and averages
  rm(bg)
  tracts <- merge(tracts.sum, tracts.avg, by=fipsname)
  tracts <- tracts[ order(tracts[ , fipsname]), ]
  rm(tracts.sum, tracts.avg)
  
  ######################################
  # Calculate the calculated fields (like EJ Index, percentiles, bins) from the E means and D counts
  acsfields <- names(tracts)
  acsfields <- acsfields[acsfields!=fipsname]
  acsfields <- acsfields[!(acsfields %in% enames)]
  acsfields <- acsfields[acsfields!='area']
  # the fips field has to be called FIPS to work in ejscreen.create()
  
  tracts <- ejscreen.create(
    e =      data.frame(FIPS=tracts[ , fipsname], tracts[ , names(tracts) %in% enames]), 
    acsraw = data.frame(FIPS=tracts[ , fipsname], tracts[ , acsfields] ),
    ...
  )
  return(tracts)
}