#' @title Helper for ejscreen.rollup.all, to save files of results
#'
#' @description Just saves csv and/or RData file(s)
#'
#' @param myrollup Required, data.frame results from ejscreen.rollup.all (just one scale at a time though)
#' @param myfolder optional folder path for saving files, default = getwd()
#' @param filenamebase optional character element, default = 'EJSCREEN', used to construct filenames to save files if relevant.
#' @param scalename optional character term used to create filenames, default = c('tracts')
#' @param filename.R optional filename, default has the word EJSCREEN and scalename .RData
#' @param filename.csv optional filename, default has the word EJSCREEN and scalename .csv
#' @param save.R optional logical, default = FALSE, whether to save files as .RData
#' @param save.csv optional logical, default = FALSE, whether to save files as .csv
#' @return Returns a 2 element vector with full paths of saved R and csv files (or NA instead of a path, if one of those is not saved)
#' @seealso \code{\link{ejscreen.rollup.all}}
#' @export
ejscreen.rollup.save <-
  function(myrollup,
           myfolder = getwd(),
           filenamebase = 'EJSCREEN',
           scalename = c('tracts'),
           filename.R,
           filename.csv,
           save.R = TRUE,
           save.csv = TRUE) {
    # helper function used by ejscreen.rollup.all
    # Saves just for one scale - loop outside this for all
    if (!save.csv &
        !save.R) {
      warning('Why would you want to call ejscreen.rollup.save but not actually save any file?')
    }
    
    # construct filenames if missing & needed
    if (save.csv & missing(filename.csv)) {
      filename.csv <-
        file.path(myfolder, paste(filenamebase, scalename, 'data.csv'))
    }
    if (save.R & missing(filename.R)) {
      filename.R <-
        file.path(myfolder, paste(filenamebase, scalename, 'data.RData'))
    }
    
    # write to files
    # no longer loops inside this function - instead a loop in ejscreen.rollup.all calls this once per scale
    #  for (i in 1:length(fipsnames)) {
    
    # Save results
    if (save.R) {
      filename <- filename.R
      cat('Saving ', filename, '\n')
      save(myrollup, file = file.path(myfolder, filename))
    }
    if (save.csv) {
      filename2 <- filename.csv
      cat('Saving ', filename2, '\n')
      write.csv(myrollup, row.names = FALSE, file = filename2)
    }
    #  } # no longer need loop
    output <- c(ifelse(save.R, file.path(myfolder, filename), NA),
                ifelse(save.csv, file.path(myfolder, filename2), NA))
    return(output)
  }
