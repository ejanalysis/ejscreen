% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ustotals.R
\name{ustotals}
\alias{ustotals}
\title{Get US Totals and Percentages Overall for EJSCREEN Fields}
\usage{
ustotals(bg)
}
\arguments{
\item{bg}{Must be a data.frame that has the following colnames:
\itemize{
  \item pop,
  \item lowinc,
  \item mins,
  \item under5,
  \item over64,
  \item lths,
  \item lingiso,
  \item pre1960,
  \item hisp,
  \item nhwa,
  \item nhba,
  \item nhaiana,
  \item nhaa,
  \item nhnhpia,
  \item nhotheralone,
  \item nhmulti,
  \item povknownratio,
  \item age25up,
  \item hhlds,
  \item builtunits
}}
}
\value{
Returns a named list of US totals and percentages (as fractions 0-100) (e.g., POP.US=xxxx, etc.): \cr
  \itemize{
    \item POP.US,
    \item LOWINC.US,
    \item MINS.US,
    \item UNDER5.US,
    \item OVER64.US,
    \item LTHS.US,
    \item LINGISO.US,
    \item POVKNOWNRATIO.US # denominator FOR PCTLOWINC,
    \item BUILTUNITS.US # denominator FOR PCTPRE1960,
    \item HHLDS.US  # denominator FOR LINGISO,
    \item PRE1960.US,
    \item HISP.US,
    \item NHWA.US,
    \item NHBA.US,
    \item NHAIANA.US,
    \item NHAA.US,
    \item NHNHPIA.US,
    \item NHOTHERALONE.US,
    \item NHMULTI.US,
    \item PCTLOWINC.US,
    \item PCTMIN.US,
    \item PCTUNDER5.US,
    \item PCTOVER64.US,
    \item PCTLTHS.US,
    \item PCTLINGISO.US,
    \item PCTPRE1960.US,
    \item PCTHISP.US,
    \item PCTNHWA.US,
    \item PCTNHBA.US,
    \item PCTNHAIANA.US,
    \item PCTNHAA.US,
    \item PCTNHNHPIA.US,
    \item PCTNHOTHERALONE.US,
    \item PCTNHMULTI.US
  }
}
\description{
NOTE: May replace with ustotals2 from batch.summarizer pkg, 
  and or replace to be more generic by using ejscreenformulas style formulas
  rather than formulas and variable names hard coded in this function.

  This function simply takes a data.frame of EJSCREEN demographic data
  and returns the total count or overall US percentage for various fields,
  by using the appropriate denominator (universe) to calculate any given percentage.
  For example, PCTLOWINC.US equals sum(lowinc) / sum(povknownratio), not sum(lowinc) / sum(pop).
  This function is hard-coded to use specified field names referring to EJSCREEN variables.
  This function is not needed to create an EJSCREEN dataset, but is convenient if one wants US summary values.
}
\examples{
\dontrun{
# See EJSCREEN demographic variables plus some race/ethnicity subgroups
c1 = ejscreen::ustotals(ejscreen::bg20DemographicSubgroups2014to2018)
c1 = cbind(c1[c1 != 0 & !is.na(c1)])
c2 = ejscreen::ustotals(ejscreen::bg20[!is.na(ejscreen::bg20$ST),])
### c2 = ejscreen::ustotals(ejscreen::bg20[!is.na(ejscreen::bg20$ST) & ejscreen::bg20$ST != 'PR',])
c2 = cbind(c2[c2 != 0 & !is.na(c2)])
US_2014to2018 = unique(rbind(c1, c2))
colnames(US_2014to2018) = 'total_count_or_fraction'
print(US_2014to2018)


 # Display as a nice table with two columns, rounded numbers, rownames and colnames
 tots <- ustotals(bg20)
 tots <- round(cbind(unlist(tots)), 3)
 totrownames <- rownames(tots)[1:16]
 tots <- cbind(tots[1:16], 100 * c(1, tots[17:31]))
 rownames(tots) <- totrownames
 colnames(tots) <- c('count', 'pct')
 tots
}
}
