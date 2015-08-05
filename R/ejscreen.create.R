#' @title Create EJSCREEN Dataset from Environmental Indicators
#'
#' @description
#'   Start with raw environmental indicator data, and create full EJSCREEN dataset.
#'   This code also contains an outline of steps involved.
#' @details **Note that if non-default fieldnames are used in e and/or acsraw, those will cause problems in ejscreen.acs.calc which assumes the standard fields are to be returned! That can be handled using parameter keep.old
#' @param e Data.frame of raw data for environmental indicators, one row per block group, one column per indicator.
#' @param acsraw Optional data.frame of raw demographic indicators. Downloaded if not provided as parameter.
#' @param folder Optional, default is getwd(). Passed to \code{\link[ACSdownload]{get.acs}} if demog data must be downloaded.
#'   Passed to but not currently used by ejscreen.acs.rename which uses \code{\link[analyze.stuff]{change.fieldnames}} in \pkg{analyze.stuff} package.
#'   Not currently passed to ejscreen.acs.calc which uses \code{\link[analyze.stuff]{calc.fields}} in \pkg{analyze.stuff} package.
#' @param keep.old optional vector of colnames from e that are to be used/returned. For nondefault colnames, this must be used.
#' @param ... additional optional parameters to pass to \code{\link[ACSdownload]{get.acs}} (such as end.year='2013' -- otherwise uses default year used by \code{\link{get.acs}})
#' @return Returns a data.frame with full ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, and text for popups. Output has one row per block group.
#' @examples
#'  \dontrun{
#'  set.seed(99)
#'  envirodata=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12), air=rlnorm(1000), water=rlnorm(1000)*5, stringsAsFactors=FALSE)
#'  demogdata=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12), pop=rnorm(n=1000, mean=1400, sd=200), mins=runif(1000, 0, 800), num2pov=runif(1000, 0,500), stringsAsFactors=FALSE)
#'  demogdata$povknownratio <- demogdata$pop
#'  # bg1=ejscreen.create(envirodata, mystates=c('de','dc')) # downloads ACS demographics and combines with user provided envirodata
#'  # currently does not work for nonstandard colnames unless keep.old used as follows:
#'  y=ejscreen.create(e=envirodata, acsraw=demogdata,
#'   keep.old = c(names(envirodata), names(demogdata)))
#'  }
#' @export
ejscreen.create <- function(e, acsraw, folder=getwd(), keep.old, ...) {

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
  # note this gets data(vars.ejscreen.acs) from ejscreen package as default list of acs variables like 'B01001.001'
  if (missing(acsraw)) {
    acsraw <- ACSdownload::get.acs(tables = 'ejscreen', vars = vars.ejscreen.acs, folder=folder, ...)
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

  # could allow user to pass formulafile here but would need to ensure correctly treated as missing if left out
  bg.d <- ejscreen.acs.rename(acsraw, folder=folder) # normally just uses default folder and filename

  ##########################################################################################################
  #  PUT E AND D IN SAME DATA.FRAME
  #  & get names of those fields
  ##########################################################################################################
  if (!('FIPS' %in% names(bg.d)) | !('FIPS' %in% names(e))) {stop('FIPS must be a colname in acsraw and e')}
  bg.d <- bg.d[order(bg.d$FIPS), ]
  e <- e[order(e$FIPS), ]
  if (any(e$FIPS!=bg.d$FIPS)) {stop('Environment and Demographic datasets must match FIPS in 100% of cases')}

  # **** SHOULD CHANGE THIS TO HANDLE CASE WHERE ENVT DATA IS MISSING IN SOME LOCATIONS, TREATED AS NA. *********************
  # WOULD NEED TO USE merge() below instead of data.frame()

  mynames.d <- names(bg.d)[names(bg.d)!='FIPS']
  mynames.e <- names(e)[names(e)!='FIPS']
  if (any(mynames.d %in% mynames.e) | any(mynames.e %in% mynames.d) ) {stop('fieldnames in environmental and demographic data must not overlap except for FIPS field')}
  # this was already available as names.d or names.e for EJSCREEN2014, but this is now more generic


  bg <- data.frame(bg.d, e[ , mynames.e], stringsAsFactors=TRUE)
  rm(bg.d) # rm(e); gc() # need e later
  ##########################################################################################################

  # Create derived demographic fields (D) (but not EJ fields since formulas not there)
  # must check that keep.old missing will work as intended
  bg <- ejscreen.acs.calc(bg, keep.old = keep.old)


  ##########################################################################################################
  # BINS AND PERCENTILES:
  #  add US percentile and map color bin cols
  ##########################################################################################################
# print('mynames.d');print(mynames.d)
# print('mynames.e');print(mynames.e)
# print('names(bg)');print(names(bg))
#	DEMOG
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , mynames.d], bg$pop), stringsAsFactors=FALSE)

  #	ENVT
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , mynames.e], bg$pop), stringsAsFactors=FALSE)
  ##########################################################################################################
  # EJ INDEXES:
  #  CALCULATE and name the EJ INDEXES & add those cols to bg
  # and the bin and percentile cols
  ##########################################################################################################

# fails here currently:
#   Warning - Did not specify us.demog= fraction of US population that is in the given demographic group
#   Using calculated us.demog= NaN , based on all locations with valid demographics (which may be a bit different than those with valid envt scores)

  EJ.basic.eo   <- data.frame(ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.eo),   stringsAsFactors=FALSE) # note this calculates overall VSI.eo.US   on the fly
  # basic.eo already has names created by ej.indexes() function.
  EJ.basic.svi6 <- data.frame(ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.svi6), stringsAsFactors=FALSE) # note this calculates overall VSI.svi6.US on the fly
  names(EJ.basic.svi6) <- paste('EJ.DISPARITY', mynames.e, 'svi6', sep='.')
  # add raw EJ cols to bg
  bg <- data.frame(bg, EJ.basic.eo, EJ.basic.svi6, stringsAsFactors = FALSE )
  # add EJ bin/percentile cols to bg
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , c(names(EJ.basic.eo), names(EJ.basic.svi6) ) ], bg$pop), stringsAsFactors=FALSE)
  rm(EJ.basic.eo, EJ.basic.svi6)

  # if supplementary/ alt1 ej indexes are desired:
  #EJ.alt1.eo   <- sapply(bg[ , mynames.e], function(x) {x * bg$pop * bg$VSI.eo  })
  EJ.alt1.eo   <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.eo, weights=bg$pop, type=5)
  names(EJ.alt1.eo) <- paste('EJ.BURDEN', mynames.e, 'eo', sep='.')
  #EJ.alt1.svi6 <- sapply(bg[ , mynames.e], function(x) {x * bg$pop * bg$VSI.svi6})
  EJ.alt1.svi6 <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg$VSI.svi6, weights=bg$pop, type=5)
  names(EJ.alt1.svi6) <- paste('EJ.BURDEN', mynames.e, 'svi6', sep='.')

  # if supplementary/ alt2 ej indexes are desired:
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
  #  Possibly add interim threshold flag if needed, and FIPS fields
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






  # CREATE LOOKUP TABLES OF PERCENTILES WITHIN EACH ZONE AND US:
  # ejscreen.lookuptables() is done separately


  # ROLLUPS: ***
  # SEPARATE CODE: # - Create rollup files/layers, such as tract, county, state, Region rollups of raw/percentile/bin & text versions.
  # using rollup()

  # Put into SHAPEFILE FORMAT? Maybe using sp pkg?

  return(bg)
}
