% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/names.d.R
\docType{data}
\name{names.d}
\alias{names.d}
\alias{names.d.pctile}
\alias{names.d.bin}
\alias{names.d.subgroups}
\alias{Dlist}
\alias{demographic-variables}
\title{Fieldnames of demographic columns in ejscreen package data}
\format{
A series of variables (each is a character vector of colnames):
\itemize{
 \item "names.d" (VSI.eo, pctmin, pctlowinc, etc.)
 \item "names.d.bin"
 \item "names.d.eo"
 \item "names.d.eo.bin"
 \item "names.d.eo.pctile"
 \item "names.d.pctile"
 \item "names.d.subgroups"
 \item "names.d.subgroups.count"
 \item "names.d.subgroups.pct"
 #'  \item "Dlist" (this one is like names.d, but as a list, not a vector)
}
}
\source{
Names developed for this package. No external data source.
}
\description{
This data set provides variables that hold the colnames
  of demographic fields in data.frames that may be used in the ejscreen package
  to make it easier to refer to them as a vector
  Note that earlier versions of EJSCREEN also included fields related to
  a demographic indicator that used six not two components:
  VSI.svi6, names.d.svi6, names.d.svi6.bin, names.d.svi6.pctile
}
\seealso{
\code{\link{ejscreenformulas}} \code{\link{names.e}} \code{\link{names.d}} \code{\link{names.ej}}
}
\concept{datasets}
