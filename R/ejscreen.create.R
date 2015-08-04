#' @title Create EJSCREEN Dataset from Environmental Indicators
#'
#' @description
#'   Start with raw environmental indicator data, and create full EJSCREEN dataset.
#'   This code also contains an outline of steps involved.
#'
#' @param bg.e Data.frame of raw data for environmental indicators, one row per block group, one column per indicator.
#' @param acsraw Data.frame of raw demographic indicators.
#' @param folder Where to save results. Default is getwd()
#' @return Returns a data.frame with full ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, and text for popups. Output has one row per block group.
#' @examples
#'  \dontrun{
#'  mybg.e=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12), air=rlnorm(1000), water=rlnorm(1000)*5, stringsAsFactors=FALSE)
#'  x=ejscreen.create(envirodata) # downloads ACS demographics and combines with user provided envirodata
#'  # does not work like this since needs more Demog vars:
#'  # myacsraw=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12), pop=rnorm(n=1000, mean=1400, sd=200), mins=runif(1000, 0, 800), lowinc=runif(1000, 0,500), stringsAsFactors=FALSE)
#'  # y=ejscreen.create(bg.e=mybg.e, acsraw=myacsraw)
#'  }
#' @export
ejscreen.create <- function(bg.e, acsraw, folder=getwd()) {

  ######################################################################################
  # Create EJSCREEN dataset in R (given Demographic and Environmental Indicators):
  ######################################################################################

  ###########################################
  # OUTLINE OF STEPS:
  ###########################################
  #
  # ENVIRONMENT
  # SEPARATE CODE: # - Obtain Environmental Indicators (E): get raw data and process it, or get scores directly:
  # * proxistat() based on downloaded points and traffic?,
  # * ACSdownload etc. for pre1960,
  # * NATA website, and
  # * OAR website/services?
  # - drop extra fields unless doing replication work, so just importing 12 raw E for this purpose
  # - Rename fields using change.fieldnames()  or  escores <- data.frame(); names(escores) <- names.e; etc.
  #
  # DEMOGRAPHICS
  # SEPARATE CODE: # - Obtain ACS demographics from Census FTP site,
  # Create derived demographic fields (D)
  # - including creating calculated and other fields etc. using
  # change.fieldnames(),
  # get.fips.tract() get.epa.region() get.fips.county() get.fip.st(),
  # calc.fields(), etc.
  #
  # EJ INDEXES
  # - Calculate EJ indexes given D and E using ej.indexes()
  #
  # PERCENTILES AND BINS
  #  make.bin.pctile.cols already creates them all:
  #   - Assigns exact US percentiles using make.pctile.cols() (2 independent algorithms compared, verified same results). Regional/State percentiles not stored in gdb, just lookup tables.
  #   - Assigns bins (map color bin number) using make.bin.cols()
  #  This originally was done by Calculate_BG_BinsPercentiles-2014-05.R
  #
  # POPUP TEXT ****
  # - Create text popup versions of all raw scores and percentiles for display:
  #     -limited significant digits for environmental indicators
  #     -floored percentiles as integer 0-100
  #     -rounded demographic percentages as integer 0-100
  #  This was also done in python using code such as in "EJCalc_TextFields_vz VB FIX NOT FLOOR.py"
  #
  # LOOKUP TABLES
  # - Create lookup tables of 100 population weighted percentiles and mean, for US and each EPA Region and each State; for each raw score.
  # - Possibly create lookup tables (means, 100 percentiles) by county, or just county means.
  #  This was originally done using "CalculateLookupTables-2014-05.R"
  # SEPARATE CODE: NOW SEE ejscreen.lookuptables()
  #
  # ROLLUPS
  # SEPARATE CODE: # - Create rollup files/layers, such as tract, county, state, Region rollups of raw/percentile/bin & text versions.
  # using rollup()
  #
  # Put into SHAPEFILE FORMAT? Maybe using sp pkg?
  #
  ############################################################################################

  #   require(ACSdownload)
  #   require(analyze.stuff)
  #   require(proxistat)
  #   require(UScensus2010blocks)
  #   require(countyhealthrankings)

  require(ejanalysis)
  data(names.evars); data(names.dvars); data(names.ejvars)

  ##########################################################################################################
  #  GET DEMOGRAPHICS
  ##########################################################################################################

  # Create and save in folder a file called "variables needed.csv" specific to EJSCREEN

  if (missing(acsraw)) {
    acsraw <- ACSdownload::get.acs(tables = 'ejscreen', end.year = '2013', askneeded = TRUE)
    acsraw  <- acsraw$bg
    # NOTE THIS DOES NOT PRESERVE tracts data downloaded
  }

  if (1==0) {
    # older examples:
    # load(file.path(mypath, 'ACS - download and parse/ACS DOWNLOADED/FTP raw 20135 ACS', 'ACS 2009-2013 EJSCREEN BG w calc vars via FTP.RData'))
    # load(file='8D-2014-06.RData')
    #		 load(file.path(mypath, 'ACS - download and parse/ACS DATA/FTP as source/20125 ACS', 'ACS 2008-2012 EJSCREEN BG w calc vars via FTP.RData'))
    #    load(file.path(mypath, 'bg EJSCREEN plus race eth subgrps ACS0812.RData'))
    # bg.d <- read.csv(file='8D-2014-06.csv', as.is=TRUE)
  }

  bg.d <- ejscreen.acs.rename(acsraw) # use default folder and filename

  ##########################################################################################################
  #  PUT E AND D IN SAME DATA.FRAME
  #  & get names of those fields
  ##########################################################################################################

  bg.d <- bg.d[order(bg.d$FIPS), ]
  bg.e <- bg.e[order(bg.e$FIPS), ]
  if (any(bg.e$FIPS!=bg.d$FIPS)) {stop('Environment and Demographic datasets must match FIPS in 100% of cases')}

  # **** SHOULD CHANGE THIS TO HANDLE CASE WHERE ENVT DATA IS MISSING IN SOME LOCATIONS, TREATED AS NA. *********************
  # WOULD NEED TO USE merge() below instead of data.frame()

  mynames.d <- names(bg.d)[names(bg.d)!='FIPS']
  mynames.e <- names(bg.e)[names(bg.e)!='FIPS']
  if (any(mynames.d %in% mynames.e) | any(mynames.e %in% mynames.d) ) {stop('fieldnames in environmental and demographic data must not overlap except for FIPS field')}
  # this was already available as names.d or names.e for EJSCREEN2014, but this is now more generic

  bg <- data.frame(bg.d, bg.e[ , mynames.e], stringsAsFactors=TRUE)
  # rm(bg.d, bg.e); gc() # need bg.e later
  ##########################################################################################################

  # Create derived demographic fields (D) (but not EJ fields since formulas not there)
  bg <- ejscreen.acs.calc(bg)

  ##########################################################################################################
  # BINS AND PERCENTILES:
  #  add US percentile and map color bin cols
  ##########################################################################################################

  #	DEMOG
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , mynames.d], bg$pop), stringsAsFactors=FALSE)
  #	ENVT
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , mynames.e], bg$pop), stringsAsFactors=FALSE)

  ##########################################################################################################
  # EJ INDEXES:
  #  CALCULATE and name the EJ INDEXES & add those cols to bg
  # and the bin and percentile cols
  ##########################################################################################################

  EJ.basic.eo   <- data.frame(ejanalysis::ej.indexes(bg[ , mynames.e], bg$VSI.eo),   stringsAsFactors=FALSE) # note this calculates overall VSI.eo.US   on the fly
  # basic.eo already has names created by ej.indexes() function.
  EJ.basic.svi6 <- data.frame(ejanalysis::ej.indexes(bg[ , mynames.e], bg$VSI.svi6), stringsAsFactors=FALSE) # note this calculates overall VSI.svi6.US on the fly
  names(EJ.basic.svi6) <- paste('EJ.DISPARITY', mynames.e, 'svi6', sep='.')
  # add raw EJ cols to bg
  bg <- data.frame(bg, EJ.basic.eo, EJ.basic.svi6, stringsAsFactors = FALSE )
  # add EJ bin/percentile cols to bg
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , c(names(EJ.basic.eo), names(EJ.basic.svi6) ) ], bg$pop), stringsAsFactors=FALSE)
  rm(EJ.basic.eo, EJ.basic.svi6)

  # if supplementary/ alt ej indexes are desired:

  #EJ.alt1.eo   <- sapply(bg[ , mynames.e], function(x) {x * bg$pop * bg$VSI.eo  })
  EJ.alt1.eo   <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.eo, weights=bg$pop, type=5)
  names(EJ.alt1.eo) <- paste('EJ.BURDEN', mynames.e, 'eo', sep='.')
  #EJ.alt1.svi6 <- sapply(bg[ , mynames.e], function(x) {x * bg$pop * bg$VSI.svi6})
  EJ.alt1.svi6 <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.svi6, weights=bg$pop, type=5)
  names(EJ.alt1.svi6) <- paste('EJ.BURDEN', mynames.e, 'svi6', sep='.')

  #EJ.alt2.eo   <- sapply(bg[ , mynames.e], function(x) {x * bg$VSI.eo  })
  EJ.alt2.eo   <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.eo, type=6)
  names(EJ.alt2.eo) <- paste('EJ.PCT', mynames.e, 'eo', sep='.')
  #EJ.alt2.svi6 <- sapply(bg[ , mynames.e], function(x) {x * bg$VSI.svi6})
  EJ.alt2.svi6 <-  ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.svi6, type=6)
  names(EJ.alt2.svi6) <- paste('EJ.PCT', mynames.e, 'svi6', sep='.')

  # add raw EJ cols to bg
  bg <- data.frame(bg, EJ.alt1.eo, EJ.alt1.svi6, EJ.alt2.eo, EJ.alt2.svi6, stringsAsFactors = FALSE)
  # add EJ bin/percentile cols to bg
  bg <- data.frame(bg, make.bin.pctile.cols(bg[ , c(names(EJ.alt1.eo), names(EJ.alt1.svi6) ) ], bg$pop), stringsAsFactors=FALSE)
  bg <- data.frame(bg, make.bin.pctile.cols(bg[ , c(names(EJ.alt2.eo), names(EJ.alt2.svi6) ) ], bg$pop), stringsAsFactors=FALSE)
  rm(             EJ.alt1.eo, EJ.alt1.svi6, EJ.alt2.eo, EJ.alt2.svi6)

  ##########################################################################################################
  #  add interim threshold flag if needed, and FIPS fields
  ##########################################################################################################

  # assumes valid colnames are all in names.ej.pctile
  bg$flag <- ejanalysis::flagged(bg[ , names.ej.pctile] / 100)

  bg <- data.frame(bg,
                   FIPS.tract=ejanalysis::get.fips.tract(bg$FIPS),
                   FIPS.county=ejanalysis::get.fips.county(bg$FIPS),
                   FIPS.ST=ejanalysis::get.fips.st(bg$FIPS),
                   REGION=ejanalysis::get.epa.region(bg$FIPS),
                   stringsAsFactors=FALSE)

  ##########################################################################################################
  # Still need to do the following here or separately
  ##########################################################################################################

  # POPUP TEXT ****
  # - Create text popup versions of all raw scores and percentiles for display:
  #     -limited significant digits for environmental indicators
  #     -floored percentiles as integer 0-100
  #     -rounded demographic percentages as integer 0-100
  #  This was also done in python using code such as in "EJCalc_TextFields_vz VB FIX NOT FLOOR.py"







  # ejscreen.lookuptables() can be done separately

  # ROLLUPS ***
  # SEPARATE CODE: # - Create rollup files/layers, such as tract, county, state, Region rollups of raw/percentile/bin & text versions.
  # using rollup()

  # Put into SHAPEFILE FORMAT? Maybe using sp pkg?

  return(bg)
}
