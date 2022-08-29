#' @name lookupUSA
#' @docType data
#' @title The nationwide most recent version of the EJSCREEN percentile lookup table.
#' @description
#'  \preformatted{
#'   Lookup table with one column per indicator and rows 0-100 show percentiles,
#'   and last two rows show mean and standard deviation.
#'
#'   Note the 2020 version of EJSCREEN released late 2020 (actually mid 2021)
#'     actually uses ACS2018, which is from 2014-2018 (released late 2019).
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'   Note the 2018 version of EJSCREEN (released late 2018)
#'     actually uses ACS2016, which is from 2012-2016 (released late 2017).
#'
#'   This is from the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package.
#'   It can be used with for example ejanalysis::lookup.pctile(13, varname.in.lookup.table = 'pm', lookup = lookupUSA)
#'   It shows what the cutpoints are for each variable at percentiles 0,1,2 through 99, 100.
#'   For example, if the traffic.score is 1000 in a given location,
#'   you can look where that falls in the percentiles and see that 81% of the US population had lower scores:
#'   ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA)
#'
#'  IMPORTANT: Consider that it does not include Puerto Rico
#'  EJSCREEN percentiles appear to be calculated for US excluding PR,
#'  but bg22 and other datasets generally include PR block groups.
#'  But bgxxDemographic... might not have PR.
#'  }
#' @examples ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA)
#'     ejanalysis::lookup.pctile(c(1000, 3000), varname.in.lookup.table = 'traffic.score',
#'       lookup = lookupStates, zone = 'NY')
#'       # Those traffic scores are at the 62d and 83d percentiles within NY State (83 percent
#'       # of the NY State population had a traffic score lower than 3000).
#'    \dontrun{
#'     bg <- bg22[sample(1:NROW(bg22), 100), ]
#'     state.pctile.pm <- ejanalysis::lookup.pctile(myvector = bg$pm, varname.in.lookup.table = 'pm',
#'        lookup = lookupStates, zone = bg$ST)
#'     plot(state.pctile.pm, bg$pctile.pm, pch = '.')
#'     text(state.pctile.pm, bg$pctile.pm, labels = paste(bg$ST, round(bg$pm,1)), cex = 0.8)
#'     abline(0,1)
#'     lookupStates[lookupStates$PCTILE == 'mean', c('REGION', 'pm')]
#'     lookupUSA[   lookupUSA$PCTILE    == 'mean', c('REGION', 'pm')]
#'   }
#'  \dontrun{
#'    What is environmental score at given percentile?
#'  ejanalysis::lookup.pctile(40,'cancer',lookupUSA)
#'  # [1] 84
#'  ejanalysis::lookup.pctile(40,'cancer',lookupStates,'WV')
#'  # [1] 93
#'  #    What is percentile of given environmental score?
#'  ejscreen::lookupUSA[lookupUSA$PCTILE=='84' ,'cancer']
#'  # [1] 39.83055
#'  ejscreen::lookupStates[lookupStates$PCTILE=='84' & lookupStates$REGION =='WV','cancer']
#'  # [1] 33.36371
#'  # also see ejanalysis::assign.pctiles
#'  }
#' @seealso  lookupUSA lookupRegions lookupStates ejscreen.lookuptables \code{\link[ejanalysis]{lookup.pctile}}
#' @details
#'   The 2022 version
#'   could be replicated for this package via  \code{x <- ejscreen::ejscreen.lookuptables(bg22)}
#'   \cr
#'   The earlier versions were created for this package from the EJSCREEN geodatabase
#'   \cr downloaded from the EJSCREEN public FTP site as .gdb format (zipped).
#'   \cr A script can be used to import and clean it up from that point:
#'   \cr see SCRIPT_read-downloaded-pctile-lookups.R in the inst folder of this pkg
#'   \cr
#'
#' @concept datasets
NULL
