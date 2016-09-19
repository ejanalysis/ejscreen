#' @title Aggregate EJSCREEN Dataset at Lower Resolutions (e.g., Tracts and Counties)
#'
#' @description
#'   Does what ejscreen.rollup does, but for more than one resolution - a batch of rollups done at once. 
#'   Start with full EJSCREEN dataset at one resolution (typically block groups), 
#'   and create aggregated data at higher geographic scales (e.g., tracts and counties)
#' @details **default fieldnames are assumed for now. Uses \code{\link{ejscreen.create}}
#' @param bg Required, data.frame of raw data for environmental and demographic counts, one row per block group typically, one column per indicator.
#' @param fipsnames optional character vector of certain colnames in bg, used to select columns from bg to summarize by, default = c('FIPS.TRACT', 'FIPS.COUNTY', 'FIPS.ST', 'REGION'), 
#' @param scalenames optional character vector of terms used to create filenames if saving files, default = c('tracts', 'counties', 'states', 'regions')
#' @param myfolder optional folder path for saving files, default = getwd()
#' @param filenamebase optional character element, default = 'EJSCREEN', used to construct filenames to save files if relevant.
#' @param filenames.R optional vector of filenames, default has the word EJSCREEN and scalename .RData
#' @param filenames.csv optional vector of filenames, default has the word EJSCREEN and scalename .csv
#' @param save.R optional logical, default = FALSE, whether to save files as .RData
#' @param save.csv optional logical, default = FALSE, whether to save files as .csv
#' @param assigning optional logical, default = FALSE, whether to assign results to variable in calling environment, or just return list of data.frames as result.
#' @param ... Optional parameters to pass to \code{\link{ejscreen.create}} which uses formulas to create indicators from raw values.
#' @return Returns a list of data.frames each like output of \code{\link{ejscreen.rollup}}, one per resolution (e.g., one for counties)
#' @examples # (none)
#' @seealso \code{\link{ejscreen.rollup}}
#' @export
ejscreen.rollup.all <- function(bg, scalenames = c('tracts', 'counties', 'states', 'regions'), fipsnames = c('FIPS.TRACT', 'FIPS.COUNTY', 'FIPS.ST', 'REGION'), myfolder = getwd(), filenamebase = 'EJSCREEN', filenames.R, filenames.csv, save.R = FALSE, save.csv = FALSE, assigning = FALSE, ...) {
  
  # requires ejscreen package
  
  if (missing(bg)) {stop('Missing bg, the blockgroup resolution dataset')}
  if (any(!(fipsnames %in% colnames(bg)))) {stop('Some of fipsnames not among colnames of bg')}
  if (length(scalenames) != length(fipsnames)) {stop('Lengths of scalenames and fipnames must be the same')}
  
  # DEFAULTS (or without the 2016)
  #filenames.R <- c('EJSCREEN 2016 tracts data.RData', 'EJSCREEN 2016 counties data.RData', 'EJSCREEN 2016 states data.RData', 'EJSCREEN 2016 regions data.RData')
  #filenames.csv <- c('EJSCREEN 2016 tracts data.RData', 'EJSCREEN 2016 counties data.RData', 'EJSCREEN 2016 states data.RData', 'EJSCREEN 2016 regions data.RData')
  
  ######################################
  # Do rollup for each level of resolution (region, state, county, tract)
  ######################################
  
  # *** creates variables in environment that function was called from! *** 
  out <- list()
  
  for (i in 1:length(fipsnames)) {
    # loop through the scales (e.g., region, then state, then county, then tract)
    
    ######################################
    # Specify resolution of interest
    fipsname <- fipsnames[i] # 'FIPS.TRACT' 
    scalename <- scalenames[i] # 'tracts'
    
    ######################################
    # Get results, using the function ejscreen::ejscreen.rollup
    cat('Calculating rollup for', scalename, '...\n')
    # *** need to fix ejscreen.rollup to use scalename?? Right now it only uses fipsname
    checkfips <- ifelse(fipsname %in% c('REGION'), FALSE, TRUE)
    myrollup <- ejscreen.rollup(bg = bg, fipsname = fipsname, scalename = scalename, checkfips = checkfips, ...)
    
    if (assigning) {
      assign(scalenames[i], myrollup, pos = parent.frame()) # test this creates variables in environment that function was called from! ***
    } else {
      # other option might be to return results as a list of data.frames, one element per scale.
      out[[i]] <- myrollup
    }
    
    # save files if needed
    if (save.R | save.csv) {
      ejscreen.rollup.save(myrollup, myfolder = myfolder, filenamebase = filenamebase, scalename = scalenames[i], filename.R = filenames.R[i], filename.csv = filenames.csv[i], save.R = save.R, save.csv = save.csv)
    }
  }
  
  return(out) # empty list if assigning = TRUE
  cat('Done\n')
}
