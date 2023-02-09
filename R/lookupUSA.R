#' @name lookupUSA
#' @docType data
#' @title The nationwide most recent version of the EJSCREEN percentile lookup table.
#' @description
#'
#'  For vintage, see attributes(lookupUSA)
#'
#'  \preformatted{
#'
#'  As of 2022-07, EJScreen did not include these lookup tables for download as csv files on FTP site.
#'
#'  The nationwide most recent version of the EJSCREEN percentile lookup table.
#'   Lookup table with one column per indicator and rows 0-100 show percentiles,
#'   and last two rows show mean and standard deviation.
#'
#'   The lookup table is for the US including PR.
#'   and bg22 has PR, so the lookup table means should match means calculated from bg22.
#'      round(unlist(cbind(ustotals(bg22[bg22$ST != 'PR',]))['PCTMIN.US',]),5)
#'
#'      round(lookupUSA[lookupUSA$PCTILE == 'mean','pctmin'],5)
#'
#'  EJScreen 2.1 was released circa August 2022.
#'    EJScreen 2.1 uses ACS2020, which is from 2016-2020 (released March 17 2022, delayed from Dec 2021).
#'    It was to be called the 2022 version of EJScreen, and
#'    here is called bg22.
#'
#'  EJScreen 2.0 was released by EPA 2022-02-18 (delayed from mid/late 2021).
#'    EJScreen 2.0 used ACS2019, which is from 2015-2019 (released Dec 2020).
#'    It was to be called the 2021 version, and here is called bg21 as it was to be a late 2021 version.
#'
#'   This is from the EJSCREEN dataset from the ftp site but with
#'   fields renamed for easier use in the ejscreen package.
#'   Versions without renamed columns were USA_2022_LOOKUP and States_2022_LOOKUP.
#'
#'   It can be used with for example ejanalysis::lookup.pctile(13, varname.in.lookup.table = 'pm', lookup = lookupUSA)
#'   It shows what the cutpoints are for each variable at percentiles 0,1,2 through 99, 100.
#'   For example, if the traffic.score is 1000 in a given location,
#'   you can look where that falls in the percentiles and see that 81% of the US population had lower scores:
#'   ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA)
#'  }
#' @examples ejanalysis::lookup.pctile(1000, varname.in.lookup.table = 'traffic.score',  lookup = lookupUSA)
#'     ejanalysis::lookup.pctile(c(1000, 3000), varname.in.lookup.table = 'traffic.score',
#'       lookup = lookupStates, zone = 'NY')
#'    \dontrun{
#'     bg <- bg22[sample(1:NROW(bg22), 100), ]
#'     state.pctile.pm <- ejanalysis::lookup.pctile(myvector = bg$pm, varname.in.lookup.table = 'pm',
#'        lookup = lookupStates, zone = bg$ST)
#'     plot(state.pctile.pm, bg$pctile.pm, pch = '.')
#'     text(state.pctile.pm, bg$pctile.pm, labels = paste(bg$ST, round(bg$pm,1)), cex = 0.8)
#'     abline(0,1)
#'     lookupStates[lookupStates$PCTILE == 'mean', c('REGION', 'pm')]
#'     lookupUSA[lookupUSA$PCTILE == 'mean', c('REGION', 'pm')]
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
#' @seealso   lookupUSA lookupRegions lookupStates ejscreen.lookuptables ejanalysis::lookup.pctile()
#' @details
#'   The EJScreen 2.1 version
#'   could be replicated for this package via \code{x <- ejscreen::ejscreen.lookuptables(bg22)}
#'   \cr
#'   The earlier versions were created for this package from the EJSCREEN geodatabase
#'   \cr downloaded from the EJSCREEN public FTP site as .gdb format (zipped).
#'   \cr A script can be used to import and clean it up from that point:
#'   \cr see SCRIPT_read-downloaded-pctile-lookups.R in the inst folder of this pkg
#'   \cr
#'
#' @concept datasets
NULL
