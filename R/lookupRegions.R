#' @name lookupRegions
#' @docType data
#' @title EPA-Region-level EJScreen percentile lookup tables
#' @description
#'  \preformatted{
#'
#'  WARNING: **** As of 2022-07, EJScreen did not include these lookup tables
#'   for download as csv files on FTP site.
#'
#'  The nationwide most recent version of the EJSCREEN percentile lookup table.
#'   Lookup table with one column per indicator; rows 0-100 show percentiles,
#'   and last two rows show mean and standard deviation.
#'
#'   Note the 2021 version of EJSCREEN (to be released late 2021 ??)
#'     actually uses ACS2019, which is from 2015-2019 (released late 2020).
#'   Note the 2020 version of EJSCREEN (confusingly released mid 2021)
#'     actually uses ACS2018, which is from 2014-2018 (released late 2019).
#'   Note the 2019 version of EJSCREEN (released late 2019)
#'     actually uses ACS2017, which is from 2013-2017 (released late 2018).
#'   Note the 2018 version of EJSCREEN (released late 2018)
#'     actually uses ACS2016, which is from 2012-2016 (released late 2017).
#'
#'   This is from the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package.
#'   It can be used with for example
#'   ejanalysis::lookup.pctile(13, varname.in.lookup.table = 'pm', 
#'   lookup = lookupUSA)
#'   It shows what the cutpoints are for each variable at percentiles 
#'   0,1,2 through 99, 100.
#'   For example, if the traffic.score is 1000 in a given location,
#'   you can look where that falls in the percentiles and see that 81% of 
#'   the US population had lower scores:
#'   ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score', 
#'    lookup = lookupUSA)
#'  }
#'
#' @examples ejanalysis::lookup.pctile(1000, 
#' varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA)
#'     ejanalysis::lookup.pctile(c(1000, 3000), 
#'     varname.in.lookup.table = 'traffic.score',
#'       lookup = lookupStates, zone = 'NY')
#'       # Those traffic scores are at the 62d and 83d percentiles 
#'       within NY State (83 percent
#'       # of the NY State population had a traffic score lower than 3000).
#'    \dontrun{
#'
#'     bg <- bg20[ sample(1:NROW(bg20), 100), ]
#'
#'     state.pctile.pm <- ejanalysis::lookup.pctile(myvector = bg$pm, 
#'     varname.in.lookup.table = 'pm',
#'        lookup = lookupStates, zone = bg$ST)
#'     plot(state.pctile.pm, bg$pctile.pm, pch = '.')
#'     text(state.pctile.pm, bg$pctile.pm, 
#'     labels = paste(bg$ST, round(bg$pm,1)), cex = 0.8)
#'     abline(0,1)
#'     lookupStates[lookupStates$PCTILE == 'mean', c('REGION', 'pm')]
#'     lookupUSA[lookupUSA$PCTILE == 'mean', c('REGION', 'pm')]
#'   }
#' @seealso lookupUSA lookupRegions lookupStates ejanalysis::lookup.pctile()
#' @details
#'   See lookupUSA for details.
#'
#' @concept datasets
NULL
