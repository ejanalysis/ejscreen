#' @title Create EJSCREEN Dataset from Environmental Indicators
#'
#' @description
#'   Start with raw environmental indicator data, and create full EJSCREEN dataset.
#'   This code also contains an outline of steps involved.
#' @details **Note that if non-default fieldnames are used in e and/or acsraw, those must be specified in parameters including demogvarname0, demogvarname1, wtsvarname, keep.old (and could be reflected in prefix and suffix params as well).
#' @param e Data.frame of raw data for environmental indicators, one row per block group, one column per indicator.
#' @param acsraw Optional data.frame of raw demographic indicators. Downloaded if not provided as parameter.
#' @param folder Optional, default is getwd(). Passed to \code{\link[ACSdownload]{get.acs}} if demog data must be downloaded.
#'   Passed to but not currently used by ejscreen.acs.rename which uses \code{\link[analyze.stuff]{change.fieldnames}} in \pkg{analyze.stuff} package.
#'   Not currently passed to ejscreen.acs.calc which uses \code{\link[analyze.stuff]{calc.fields}} in \pkg{analyze.stuff} package.
#' @param keep.old optional vector of colnames from e that are to be used/returned. For nondefault colnames, this must be used.
#' @param end.year optional to pass to \code{\link[ACSdownload]{get.acs}} (such as end.year='2013' -- otherwise uses default year used by \code{\link{get.acs}})
#' @param demogvarname0 optional, default is 'VSI.eo' used as demographic indicator for EJ Indexes. Must be a colname in acsraw or created and kept by formulas.
#' @param demogvarname1 optional, default is 'VSI.svi6' used for alternative EJ Indexes. Must be a colname in acsraw or created and kept by formulas.
#' @param wtsvarname optional, default is 'pop' used for weighted percentiles, etc. Must be a colname in acsraw or created and kept by formulas.
#' @param demogvarname0suffix optional, default is 'eo' - specifies suffix for colnames of EJ Indexes based on demogvarname0, with a period separating body of colname from suffix
#' @param demogvarname1suffix optional, default is 'svi6' - specifies suffix for colnames of EJ Indexes based on demogvarname1, with a period separating body of colname from suffix
#' @param EJprefix0 optional, default is 'EJ.DISPARITY' - specifies prefix for colnames of main EJ Indexes, with a period separating prefix from body of colname
#' @param EJprefix1 optional, default is 'EJ.BURDEN' - specifies prefix for colnames of Alternative 1 version of EJ Indexes, with a period separating prefix from body of colname
#' @param EJprefix2 optional, default is 'EJ.PCT' - specifies prefix for colnames of Alternative 2 version of EJ Indexes, with a period separating prefix from body of colname
#' @param formulas optional, see \code{\link{ejscreen.acs.calc}} for details. Defaults are in ejscreenformulas$formula
#' @param threshold optional, default is FALSE. Set to TRUE to add a column (called 'flag') to results that is TRUE when one or more of certain percentiles (US EJ Index) in a block group (row) exceed cutoff.
#' @param cutoff optional, default is 0.80 (80th percentile). If threshold=TRUE, then cutoff defines the threshold against which percentiles are compared.
#' @param thresholdfieldnames optional, default is standard EJSCREEN EJ Indexes built into code. Otherwise, vector of character class fieldnames, specifying which fields to compare to cutoff if threshold=TRUE.
#' @param ejformulasfromcode optional, default is FALSE. If TRUE, use EJ Index formulas built into this function instead of those in ejscreenformulas (or specified by user?). The parameters such as demogvarname0 are only used if ejformulasfromcode=TRUE.
#' @param checkfips optional, default is TRUE. If TRUE, function checks to verify all FIPS codes appear to be valid US FIPS (correct number of characters, adding any leading zero needed, and checking the first five to ensure valid county)
#' @return Returns a data.frame with full ejscreen dataset of environmental and demographics indicators, and EJ Indexes,
#'   as raw values, US percentiles, and text for popups. Output has one row per block group.
#' @examples
#'  \dontrun{
#'  set.seed(99)
#'  envirodata=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12),
#'    air=rlnorm(1000), water=rlnorm(1000)*5, stringsAsFactors=FALSE)
#'  demogdata=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12),
#'    pop=rnorm(n=1000, mean=1400, sd=200), mins=runif(1000, 0, 800),
#'    num2pov=runif(1000, 0,500), stringsAsFactors=FALSE)
#'  demogdata$povknownratio <- demogdata$pop
#'  # downloads ACS demographics and combines with user provided envirodata:
#'  # bg1=ejscreen.create(envirodata, mystates=c('de','dc'))
#'  # currently does not work for nonstandard colnames
#'  #  unless keep.old used as follows (work in progress):
#'  y=ejscreen.create(e=envirodata, acsraw=demogdata,
#'    keep.old = c(names(envirodata), names(demogdata)),
#'    demogvarname0 = 'pctmin', demogvarname1 = 'pctlowinc', wtsvarname = 'pop' )
#'  }
#' @export
ejscreen.create <- function(e, acsraw, folder=getwd(), keep.old, formulas,
                            demogvarname0='VSI.eo', demogvarname1='VSI.svi6', wtsvarname='pop', checkfips=TRUE,
                            EJprefix0='EJ.DISPARITY', EJprefix1='EJ.BURDEN', EJprefix2='EJ.PCT', ejformulasfromcode=FALSE,
                            demogvarname0suffix='eo', demogvarname1suffix='svi6', end.year, threshold=FALSE, cutoff=0.80, thresholdfieldnames) {

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
  # - Calculate EJ indexes given D and E using ej.indexes() OR ejscreenformulas
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

  #require(ejanalysis)
  #data(names.evars); data(names.dvars); data(names.ejvars)

  ##########################################################################################################
  #  GET DEMOGRAPHICS
  ##########################################################################################################

  # Created file called "variables needed.csv" specific to EJSCREEN
  # and now that is in  data(vars.ejscreen.acs) from ejscreen package as default list of acs variables like 'B01001.001'
  if (missing(acsraw)) {
    if (!missing(end.year)) {
      acsraw <- ACSdownload::get.acs(tables = 'ejscreen', vars = vars.ejscreen.acs, base.path=folder, end.year=end.year)
    } else {
      acsraw <- ACSdownload::get.acs(tables = 'ejscreen', vars = vars.ejscreen.acs, base.path=folder)
    }
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

  if (checkfips) {
    # clean up adding leading zero and saving as character in case 11 digit numeric missing leading zero for example
    # but note that will not allow use of simple ordinal numbers in lieu of FIPS, since clean.fips requires fips to be valid state, county, etc., not just any number or string
    e$FIPS <- clean.fips(e$FIPS)
    bg.d$FIPS <- clean.fips(bg.d$FIPS)
  }

  if (any(e$FIPS!=bg.d$FIPS)) {stop('Environment and Demographic datasets must match FIPS in 100% of cases')}

  # **** SHOULD CHANGE THIS TO HANDLE CASE WHERE ENVT DATA IS MISSING IN SOME LOCATIONS, TREATED AS NA. *********************
  # WOULD NEED TO USE merge() below instead of data.frame()

  mynames.d <- names(bg.d)[names(bg.d)!='FIPS']
  mynames.e <- names(e)[names(e)!='FIPS']
  if (any(mynames.d %in% mynames.e) | any(mynames.e %in% mynames.d) ) {stop('fieldnames in environmental and demographic data must not overlap except for FIPS field')}
  # this was already available as names.d or names.e for EJSCREEN2014, but this is now more generic
  # NOTE: pctpre1960 is in environmental dataset but also demographic since obtained from ejscreen.acs.calc below, so it will be duplicated below.

  ##########################################################################################################
  # CALCULATE DEMOGRAPHIC derived fields (D) (but not EJ fields, since formulas not there, at least currently)
  # (Check that keep.old missing will work as intended)
  ##########################################################################################################

  # include environmental dataset along with demographic when sending bg to ejscreen.acs.calc
  bg <- data.frame(bg.d, e[ , mynames.e], stringsAsFactors=FALSE)
  rm(bg.d) # rm(e); gc() # need e later

  # keep.old default is to be missing here, and default in ejscreen.acs.calc should be the hardwired ejscreen-specific fields including FIPS and key raw demographics
  bg <- ejscreen.acs.calc(bg, keep.old = keep.old, formulas=formulas)

  # FOR NOW JUST ADD e AGAIN, SINCE ADDED IN CASE WANTED IN FORMULAS BUT NOT RETAINED BY DEFAULT keep.old
  # can fix that later to optimize this
  bg <- data.frame(bg, e[ , mynames.e], stringsAsFactors = FALSE)

  # now focus on just those colnames that have been retained, not all the raw acs fields, etc.
  mynames.d <- names(bg)[!(names(bg) %in% c('FIPS', mynames.e))] # but that might include some fields we do not want? should have all returned by ejscreen.acs.calc other than FIPS
  #mynames.d <- mynames.d[mynames.d %in% names(bg) ]     # but that leaves out the new d fields

  ##########################################################################################################
  # BINS AND PERCENTILES for DEMOG AND ENVT (and EJ -- if created by formulas not code below):
  #  add US percentile and map color bin cols
  ##########################################################################################################

  # cat('\n')
  # print('mynames.d');print(mynames.d);cat('\n')
  # print('mynames.e');print(mynames.e);cat('\n')
  # print('names(bg)');print(names(bg));cat('\n')

  #	DEMOG
  # (if EJ Index formulas were in ejscreenformulas variable lazy loaded from data, or specified by user formulas,
  # then they will be here as well!)
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , gsub('FIPS','',mynames.d)], bg[ , wtsvarname]), stringsAsFactors=FALSE)

  #	ENVT
  bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , mynames.e], bg[ , wtsvarname]), stringsAsFactors=FALSE)

  if (ejformulasfromcode) {

    ##########################################################################################################
    # CALCULATE EJ INDEXES:
    #  CALCULATE and name the EJ INDEXES & add those cols to bg
    # and the bin and percentile cols
    ##########################################################################################################

    #   Warning - Did not specify us.demog= fraction of US population that is in the given demographic group
    #   Using calculated us.demog= NaN , based on all locations with valid demographics (which may be a bit different than those with valid envt scores)
    # and using bg[ , wtsvarname] (default is pop) as denominator, which is not exactly right for pctlowinc, pctlths, pctlingiso, (&pctpre1960).
    #   (bg$povknownratio)
    #   (bg$age25up)
    #   (bg$hhlds)
    #   (bg$builtunits)

    # EJ Index raw values cols
    EJ.basic.eo   <- data.frame(ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg[ , demogvarname0], weights = bg[ , wtsvarname]),   stringsAsFactors=FALSE) # note this calculates overall VSI.eo.US   on the fly
    # basic.eo already has names created by ej.indexes() function. WOULD USE demogvarname0suffix
    EJ.basic.svi6 <- data.frame(ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg[ , demogvarname1], weights = bg[ , wtsvarname]), stringsAsFactors=FALSE) # note this calculates overall VSI.svi6.US on the fly
    names(EJ.basic.svi6) <- paste(EJprefix0, mynames.e, demogvarname1suffix, sep='.')
    # add to bg
    bg <- data.frame(bg, EJ.basic.eo, EJ.basic.svi6, stringsAsFactors = FALSE )

    # EJ bin/percentile cols
    bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , c(names(EJ.basic.eo), names(EJ.basic.svi6) ) ], weights = bg[ , wtsvarname]), stringsAsFactors=FALSE)
    rm(EJ.basic.eo, EJ.basic.svi6)

    ###

    # Supplementary/ alt1 EJ Indexes raw values cols
    #EJ.alt1.eo   <- sapply(bg[ , mynames.e], function(x) {x * bg[ , wtsvarname] * bg[,demogvarname0]  })
    EJ.alt1.eo   <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg[ , demogvarname0], weights=bg[ , wtsvarname], type=5)
    names(EJ.alt1.eo) <- paste(EJprefix1, mynames.e, demogvarname0suffix, sep='.')
    #EJ.alt1.svi6 <- sapply(bg[ , mynames.e], function(x) {x * bg[ , wtsvarname] * bg[ , demogvarname1]})
    EJ.alt1.svi6 <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg[ , demogvarname1], weights=bg[ , wtsvarname], type=5)
    names(EJ.alt1.svi6) <- paste(EJprefix1, mynames.e, demogvarname1suffix, sep='.')

    # Supplementary/ alt2 EJ Indexes raw values cols
    #EJ.alt2.eo   <- sapply(bg[ , mynames.e], function(x) {x * bg[ , demogvarname0]  })
    EJ.alt2.eo   <- ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg[ , demogvarname0], type=6)
    names(EJ.alt2.eo) <- paste(EJprefix2, mynames.e, demogvarname0suffix, sep='.')
    #EJ.alt2.svi6 <- sapply(bg[ , mynames.e], function(x) {x * bg[ , demogvarname1]})
    EJ.alt2.svi6 <-  ejanalysis::ej.indexes(env.df=bg[ , mynames.e], demog=bg[ , demogvarname1], type=6)
    names(EJ.alt2.svi6) <- paste(EJprefix2, mynames.e, demogvarname1suffix, sep='.')

    # add alt raw EJ cols to bg
    bg <- data.frame(bg, EJ.alt1.eo, EJ.alt1.svi6, EJ.alt2.eo, EJ.alt2.svi6, stringsAsFactors = FALSE)

    # EJ alt bin/percentile cols
    bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , c(names(EJ.alt1.eo), names(EJ.alt1.svi6) ) ], bg[ , wtsvarname]), stringsAsFactors=FALSE)
    bg <- data.frame(bg, ejanalysis::make.bin.pctile.cols(bg[ , c(names(EJ.alt2.eo), names(EJ.alt2.svi6) ) ], bg[ , wtsvarname]), stringsAsFactors=FALSE)

    rm(             EJ.alt1.eo, EJ.alt1.svi6, EJ.alt2.eo, EJ.alt2.svi6)

  }

  if (threshold) {
    #  add threshold flag if requested
    # later could allow user specified fields to be applied to threshold cutoff
    if (missing(thresholdfieldnames)) {
      data(names.ejvars)
      thresholdfieldnames <- names.ej.pctile
    }
    if (all(thresholdfieldnames %in% names(bg))) {
      bg$flag <- ejanalysis::flagged(bg[ , thresholdfieldnames] / 100, cutoff=cutoff)
    } else {
      warning('threshold field requested but thresholdfieldnames are not all found in the dataset')
    }
  }

  ##########################################################################################################
  # Add FIPS fields and ST and REGION
  ##########################################################################################################

  bg <- data.frame(bg,
                   FIPS.tract=ejanalysis::get.fips.tract(bg$FIPS),
                   FIPS.county=ejanalysis::get.fips.county(bg$FIPS),
                   FIPS.ST=ejanalysis::get.fips.st(bg$FIPS),
                   stringsAsFactors=FALSE)
  bg$ST <- ejanalysis::get.state.info(query=bg$FIPS.ST, fields='ST')$ST
  bg$REGION <- ejanalysis::get.epa.region(bg$ST)
  bg <- analyze.stuff::put.first(bg, c('FIPS', 'FIPS.tract', 'FIPS.county', 'FIPS.ST', 'ST', 'REGION'))


  ##########################################################################################################
  # Still need to do the following here or separately
  ##########################################################################################################

  warning('Popup text fields are not implemented yet')
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
