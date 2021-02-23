#' @title Create EJSCREEN Lookup Tables of Pop. Percentiles by Zone - WORK IN PROGRESS
#'
#' @description
#'   *** Work in progress as of 2019.
#'   *** The Hmisc package provides the function called Hmisc::wtd.quantile(),
#'   but could recode to use analyze.stuff::wtd.pctiles ?
#'
#'   Start with raw environmental, demographic, and EJ indicator data, and write as csv files to disk a series of
#'   lookup tables that show population percentiles and mean values for each indicator.
#' @details Percentiles are calculated as exact values and then rounded down to the nearest 0-100 percentile.
#'   This calculates percentiles among only the non-NA values. In other words,
#'   people in places with missing data are excluded from the calculation. This means the
#'   percentile is the percent of people with valid data (i.e., not NA) who have a tied or lower value.
#' @param x Data.frame of indicators, one row per block group, one column per indicator.
#' @param weights Weights for percentiles -- Default is population count to provide population percentiles.
#' @param folder Default is \code{getwd()} - specifies where to save the csv files.
#' @param zonecols Optional. Must set to NULL if no zones wanted, because default is \code{c('ST', 'REGION')},
#'   names of cols in x that contain zone codes, such as State names or Region numbers,
#'   used to create a lookup table file for each of the zonecols, with separate percentiles calculated within each zone.
#' @param missingcode Leave this unspecified if missing values are set to NA in the input data.
#'   Default is -9999999 (but if already NA then do not specify anything for this). The number or value in the input data that designates a missing value.
#' @param cols Optional vector of colnames of x that need percentile lookup tables, or \code{all} which means all numeric fields in x.
#'   Default is a standard set of EJSCREEN fieldnames defined within this function (see source code).
#' @return Overall lookup table(s) as data.frame (but not zonal ones). Creates lookup tables saved as csv files to specified folder.
#'   One table for overall percentiles, and one for each of the zonecols (unless that is set to NULL).
#' @examples
#'  \dontrun{
#'  # Try with a sample envt data set:
#'  set.seed(99)
#'  envirodata <- data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12),
#'    pm = runif(1000,5,20), o3 = runif(1000,3,50),
#'    air=rlnorm(1000), water=rlnorm(1000)*5, stringsAsFactors=FALSE)
#'  demogdata <- data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12),
#'    pop = rlnorm(1000, meanlog = log(1000), sdlog = 1), stringsAsFactors=FALSE)
#'  x <- ejscreen.lookuptables(envirodata, weights=demogdata$pop, cols='all', zonecols=NULL)
#'  x
#'  }
#' @export
ejscreen.lookuptables <-
  function(x,
           weights = x$pop,
           cols,
           zonecols = c('ST', 'REGION'),
           folder = getwd(),
           missingcode = NA) {

    ############################### #
    #	NOTE THESE OLDER FUNCTIONS were WRITTEN ASSUMING THE DATA IS IN A DATAFRAME CALLED places <- x
    # BUT not a problem because within this overall function that data.frame is available.
    ############################### #
        # This was previously done by CalculateLookupTables-2014-05.R and replicated by code in 'How to run EJSCREEN R scripts 2014-05.R'
    ############################### #
    # With example for overall function providing a sample dataset, below
    # can be used for testing parts of this, but require places in environment (memory):
    #  cbind(table.pop.pctile(envirodata$pm, demogdata$pop))
    #    fname <- "TESTING results table of WTD pctiles for EJ vars.csv"
    #    write.wtd.pctiles(column.names = c("pm", "o3"), wts = demogdata$pop, filename = fname)

    places <- x
    rm(x)

    # Which cols need pctiles? ------------------------------------------------

    if (missing(cols)) {
      cols <- c(
        "MINORPCT",
        "LOWINCPCT",
        "LESSHSPCT",
        "LINGISOPCT",
        "UNDER5PCT",
        "OVER64PCT",
        "PRE1960PCT",
        "VULEOPCT",
        "VULSVI6PCT",
        "DSLPM",
        "CANCER",
        "RESP",
        "NEURO",
        "PTRAF",
        "PWDIS",
        "PNPL",
        "PRMP",
        "PTSDF",
        "OZONE",
        "PM25",
        "D_LDPNT_2",
        "LDPNT_D6",
        "LDPNT_B2",
        "LDPNT_B6",
        "LDPNT_P2",
        "LDPNT_P6",
        "D_DSLPM_2",
        "DSLPM_D6",
        "DSLPM_B2",
        "DSLPM_B6",
        "DSLPM_P2",
        "DSLPM_P6",
        "D_CANCR_2",
        "CANCR_D6",
        "CANCR_B2",
        "CANCR_B6",
        "CANCR_P2",
        "CANCR_P6",
        "D_RESP_2",
        "RESP_D6",
        "RESP_B2",
        "RESP_B6",
        "RESP_P2",
        "RESP_P6",
        "D_NEURO_2",
        "NEURO_D6",
        "NEURO_B2",
        "NEURO_B6",
        "NEURO_P2",
        "NEURO_P6",
        "D_PTRAF_2",
        "PTRAF_D6",
        "PTRAF_B2",
        "PTRAF_B6",
        "PTRAF_P2",
        "PTRAF_P6",
        "D_PWDIS_2",
        "PWDIS_D6",
        "PWDIS_B2",
        "PWDIS_B6",
        "PWDIS_P2",
        "PWDIS_P6",
        "D_PNPL_2",
        "PNPL_D6",
        "PNPL_B2",
        "PNPL_B6",
        "PNPL_P2",
        "PNPL_P6",
        "D_PRMP_2",
        "PRMP_D6",
        "PRMP_B2",
        "PRMP_B6",
        "PRMP_P2",
        "PRMP_P6",
        "D_PTSDF_2",
        "PTSDF_D6",
        "PTSDF_B2",
        "PTSDF_B6",
        "PTSDF_P2",
        "PTSDF_P6",
        "D_OZONE_2",
        "OZONE_D6",
        "OZONE_B2",
        "OZONE_B6",
        "OZONE_P2",
        "OZONE_P6",
        "D_PM25_2",
        "PM25_D6",
        "PM25_B2",
        "PM25_B6",
        "PM25_P2",
        "PM25_P6"
      )
      # update to use new Rfieldnames:
      cols <-
        analyze.stuff::change.fieldnames(cols,
                                         oldnames = ejscreenformulas$gdbfieldname,
                                         newnames = ejscreenformulas$Rfieldname)
    }
    if (cols[1] == 'all') {
      cols <- names(places)[sapply(places, is.numeric)]
    }

    # *** Written assuming places data.frame is in memory in current environment,
    # not passed to functions here
    if (any(!(cols %in% names(places)))) {
      stop('Not all cols are found among colnames of x')
    }


    # Handle NA missing values ------------------------------------------------

    # As of 5/8/2014, -9999999  was the missing value indicator EPA was using but this code assumes NA.
    if (!is.na(missingcode)) {
      cat('Started creating NA values for missing data... ')
      print(Sys.time())
      places[places == missingcode] <- NA
      cat('Finished creating NA values for missing data... ')
      print(Sys.time())
    }


    ########################## #
    # *** HOW NA / MISSING VALUES ARE HANDLED IN THE DATA.FRAME AND THE CSV FILES AND ARCGIS ***
    # NOTE: There should be no NA values in the output tables, because they are excluded so even the minimum value or the 1th percentile is not NA --
    # None of the places represented by percentiles have NA values.
    # *** That means they are not precisely percentiles of the entire US population. ***
    # *** They are technically percentiles of the population where we have valid data for that indicator. ***
    #
    # na.rm=TRUE was put in in as of 5/14/2014 below as a new way to handle NA values (once they are NA instead of -9999999)
    #  to ensure that NA values are left out of the calculation of weighted percentiles, mean, sd; for US and each zone.
    # Old way was to use x[!is.na(x)] everywhere that x is used, and wts[!is.na(x)] whenever wts is used.
    #
    # *** In testing there seemed to be problems where wtd.mean would be NA even if na.rm=TRUE,  ****
    # That was due to integer overflow, where integer raw field * integer weights ACSTOTPOP could create problem and NA would be returned.
    # *** So as of 5/16/2014, now functions do as.numeric()  for raw data columns and weights.


    # Functions defined - How to Calculate Percentiles ------------------------


    #################################### #
    #	FIRST, DEFINE THE BASIC FUNCTIONS
    #	THAT FIND 100 PERCENTILE VALUES, MEAN, AND MAYBE EVEN STANDARD DEVIATION,
    #	FOR DISTRIBUTION OF BLOCK GROUPS, AND THEN FOR DISTRIBUTION OF PEOPLE (POPULATION-WEIGHTED STATS ACROSS BLOCK GROUPS)

    ################################################################################################ #
    # BASIC FUNCTION TO CALCULATE A LOOKUP TABLE OF 100 POPULATION PERCENTILES FOR THOSE PLACES WITH VALID DATA

    # *** THIS SHOULD BE REPLACED (e.g., used AROUND lines 170 and 213) WITH
    #  analyze.stuff::wtd.pctiles(x, wts = NULL, na.rm = TRUE, type = "i/n",
    #   probs = (1:100)/100, digits = 3)
    # which is essentially this:
    #  cbind(round(Hmisc::wtd.quantile(x, wts, type=type, probs=probs, na.rm=na.rm), digits))

    table.pop.pctile	<- function(x, wt) {
      Hmisc::wtd.quantile(
        x,
        weights = wt,
        probs = seq(0, 1, by = 0.01),
        type = 'i/n',
        na.rm = TRUE
      )
    }

    ################################################################################################ #
    #  TO WRITE (POPULATION-)WEIGHTED CSV FILE WITH ***wtd*** PERCENTILES AND wtd MEAN, AND wtd STD DEVIATION

    # NOTE na.rm=TRUE is done in table.pop.pctile, so needn't do that below as well.

    write.wtd.pctiles <-
      function(column.names,
               wts,
               folder = getwd(),
               filename,
               missingcode = NA) {
        # Written assuming places data.frame is in memory in current environment,
        # not passed to functions here

        # as.numeric() is to avoid integer overflow if integer and wts huge
        rawcols <-
          as.data.frame(lapply(places[, column.names], as.numeric)) # to be more generic, column.names would be cols, replacing places[,column.names]
        wts <- as.numeric(wts)

        # if special missing value symbol used, convert to NA for the calculations
        if (!is.na(missingcode)) {
          rawcols[rawcols == missingcode] <- NA
          wts[wts == missingcode] <- NA
        }

        # If every element of a column is NA, these all fail: wtd.mean, wtd.var, table.pop.pctile that uses wtd.quantile
        # Use a simple way to allow wtd functions below to still work -- resulting pctiles and mean will all be zero.
        rawcol.is.all.na <- sapply(rawcols, function(x)
          all(is.na(x)))
        rawcols[, rawcol.is.all.na] <- 0

        r = data.frame(sapply(rawcols, function(x)
          table.pop.pctile(x, wts)))
        r = rbind(r, t(data.frame(mean = sapply(rawcols, function(x)
          Hmisc::wtd.mean(x, wts, na.rm = TRUE)))))
        r = rbind(r, t(data.frame(std.dev = sapply(rawcols, function(x)
          sqrt(wtd.var(x, wts, na.rm = TRUE))))))

        # fix columns where all were NA values so don't say zero
        r[, rawcol.is.all.na] <- NA

        # replace NA in tables with missing value symbol if necessary
        if (!is.na(missingcode)) {
          r[is.na(r)] <- missingcode
        }

        write.csv(r, file = file.path(folder, paste(filename, ".csv", sep =
                                                      "")))
        return(r)
      }

    #################################### #
    #	DEFINE FUNCTION TO SHOW THOSE STATS STRATIFIED BY REGION (OR STATE),
    #	SAVING A FILE OF STATS FOR EACH REGION OR STATE

    write.wtd.pctiles.by.zone <-
      function(column.names,
               wts,
               folder = getwd(),
               filename,
               zone.vector,
               missingcode = NA) {
        # ***** Written assuming places data.frame is in memory in current environment,
        # not passed to this function, BUT places IN AVAILABLE WITHIN THE CALLING ENVIRONMENT
        # SINCE ejscreen.lookuptables() gets passed the df and it is renamed places

        # as.numeric() is to avoid integer overflow if integer and wts huge
        rawcols <-
          as.data.frame(lapply(places[, column.names], as.numeric)) # to be more generic, column.names would be cols, replacing places[,column.names]
        wts <- as.numeric(wts)

        # if special missing value symbol used, convert to NA for the calculations
        if (!is.na(missingcode)) {
          rawcols[rawcols == missingcode] <- NA
          wts[wts == missingcode] <- NA
        }

        # r <- list(1:length(unique(zone.vector))) # if we wanted to save all the tables, one per zone, in a list, could say r[[z]] <- .... below

        for (z in unique(zone.vector)) {
          # WITHIN A GIVEN ZONE ***
          # If every element of a column is NA, these all fail: wtd.mean, wtd.var, table.pop.pctile that uses wtd.quantile
          # Use a simple way to allow wtd functions below to still work -- resulting pctiles and mean will all be zero.
          rawcol.is.all.na <-
            sapply(rawcols[zone.vector == z,], function(x)
              all(is.na(x)))
          rawcols[zone.vector == z, rawcol.is.all.na] <- 0

          r = data.frame(sapply(rawcols[zone.vector == z,], function(x)
            table.pop.pctile(x, wts[zone.vector == z])))
          r = rbind(r, t(data.frame(
            mean = sapply(rawcols[zone.vector == z,], function(x)
              Hmisc::wtd.mean(x, wts[zone.vector == z], na.rm = TRUE))
          )))
          r = rbind(r, t(data.frame(
            std.dev = sapply(rawcols[zone.vector == z,], function(x)
              sqrt(wtd.var(
                x, wts[zone.vector == z], na.rm = TRUE
              )))
          )))

          # fix columns where all were NA values so don't say zero
          r[, rawcol.is.all.na] <- NA

          # replace NA in tables with missing value symbol if necessary
          if (!is.na(missingcode)) {
            r[is.na(r)] <- missingcode
          }

          write.csv(r, file = file.path(
            folder,
            paste(filename, "-popwtd-for zone ", z, ".csv", sep = "")
          ))
        }
        return(unique(zone.vector))
        # return(r[z])  #  if we wanted to compile & then return all the tables, one per zone, in a list
      }

    # zone.vector should be a vector that is the data in the column to use for grouping, e.g. zone.vector <- places$REGION


    # Notes on pctiles --------------------------------------------------------


    #   ################################################################################################ #
    #   #  TO CREATE BASIC LIST OF PERCENTILES (not used in EJSCREEN, BUT write.pctiles below would use it.)
    #
    #
    #   pctiles.unrounded = function(x) { cbind(quantile(x, probs=(1:100)/100, na.rm=TRUE)) }
    #
    #   ################################################################################################ #
    #   #	TO WRITE (unweighted) CSV FILE WITH PERCENTILES AND MEAN, AND MAYBE STD DEVIATION (not used in EJSCREEN)
    #
    #     # Written assuming places data.frame is in memory in current environment,
    #  # not passed to functions here
    #
    #   write.pctiles = function(column.names, folder=getwd(), filename, missingcode=NA) {
    #
    #     rawcols <- places[, column.names ] # wastes some RAM to make a copy, but easier
    #
    #     # if special missing value symbol used, convert to NA for the calculations
    #     if (!is.na(missingcode)) {
    #       rawcols[rawcols==missingcode] <- NA
    #     }
    #
    #     r = data.frame(sapply(rawcols, function(x) pctiles.unrounded(x) ) )
    #     r = rbind(r, t(data.frame(mean=sapply(rawcols, function(x) mean(x, na.rm=TRUE) ) ) ))
    #     r = rbind(r, t(data.frame(std.dev=sapply(rawcols, function(x) sd(x, na.rm=TRUE) ) ) ))
    #
    #     # replace NA in tables with missing value symbol if necessary
    #     if (!is.na(missingcode)) {
    #       r[is.na(r)] <- missingcode
    #     }
    #
    #     write.csv(r, file=file.path(folder, paste(filename, ".csv", sep="")))
    #     return(r)
    #   }

    #   #################################### #
    #   #  DEFINE FUNCTION TO SHOW THOSE unweighted STATS STRATIFIED BY REGION (OR STATE),  (not used in EJSCREEN)
    #   #	SAVING A FILE OF STATS FOR EACH REGION OR STATE
    #
    #
    #   # Written assuming places data.frame is in memory in current environment,
    #   # not passed to functions here
    #
    #    write.pctiles.by.zone = function(column.names, folder=getwd(), filename, zone.vector, missingcode=NA) {
    #
    #     rawcols <- places[, column.names ] # wastes some RAM to make a copy, but easier
    #
    #     # if special missing value symbol used, convert to NA for the calculations
    #     if (!is.na(missingcode)) {
    #       rawcols[rawcols==missingcode] <- NA
    #     }
    #
    #     for (z in unique(zone.vector)) {
    #       r = data.frame(sapply(rawcols[zone.vector==z, ], function(x) pctiles.unrounded(x) ) )
    #       r = rbind(r, t(data.frame(mean=sapply(rawcols[zone.vector==z,  ], function(x) mean(x, na.rm=TRUE) ) ) ))
    #       r = rbind(r, t(data.frame(std.dev=sapply(rawcols[zone.vector==z, ], function(x) sd(x, na.rm=TRUE) ) ) ))
    #
    #       # replace NA in tables with missing value symbol if necessary
    #       if (!is.na(missingcode)) {
    #         r[is.na(r)] <- missingcode
    #       }
    #
    #       write.csv(r, file=file.path(folder, paste(filename, "-notpopwtd-for zone ", z, ".csv", sep="")))
    #     }
    #     return(unique(zone.vector))
    #   }

    ############################################################################################################ #

    # CALL THE FUNCTIONS to write lookup tables as csv files ----------------

    #  x <- weightedCDF('in_rawData_csv.csv', 'output.csv', 'pop')   # cols is optional

    x <-
      write.wtd.pctiles(
        column.names = cols,
        wts = weights,
        folder = folder,
        filename = 'output',
        missingcode = missingcode
      )

    for (i in 1:length(zonecols)) {
      y <- write.wtd.pctiles.by.zone(
        column.names = cols,
        wts = weights,
        folder = folder,
        filename = paste('out', zonecols[i], sep = '_'),
        zone.vector = places[, zonecols[i]],
        missingcode = missingcode
      )
      # Do not return y (by zone), just x (overall)
    }

    return(x)
  }
