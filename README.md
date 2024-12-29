# ejscreen package

## Currently Obsolete way to Create an EJSCREEN-style dataset

As of 1/2025, see https://usepa.github.io/EJAM/index.html for related data and tools.

As of 1/2025, content below is obsolete, but it may be updated at some point.


## This [ejscreen package](https://ejanalysis.github.io/ejscreen/) provides tools for R related to environmental justice (EJ) analysis, specifically related to the United States Environmental Protection Agency (EPA) screening and mapping/GIS tool called EJSCREEN.

For details on the EJScreen tool itself, see [the EJScreen website](https://www.epa.gov/ejscreen). This R package -- "ejscreen" -- facilitates development of a dataset in the EJSCREEN format, based on user-provided environmental indicators.

The resulting dataset is a data.frame that contains data on demographics (e.g., percent of residents who are low-income) and user-provided local environmental indicators (e.g., an air quality index), and calculated indicators called EJ Indexes, which combine environmental and demographic indicators. The dataset also provides each key indicator as a national population-percentile that represents what percentage of the US population have equal or lower raw values for the given indicator. The dataset has one row per spatial location (e.g., Census block group).

## Installation

This package is not on CRAN yet, but you can install it from Github (if it has been changed from a private to public repo):

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github('ejanalysis/ejscreen')
```

## Related Packages

This package is one of a series of [R packages related to environmental justice (EJ) analysis](http://ejanalysis.github.io/), as part of [ejanalysis.com](http://www.ejanalysis.com).  

This and related packages, once each is made available as a public repository on GitHub, until available on cran, can be installed using the devtools package: 

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github("ejanalysis/analyze.stuff")  
devtools::install_github("ejanalysis/countyhealthrankings")  
devtools::install_github("ejanalysis/UScensus2010blocks")  
devtools::install_github("ejanalysis/ACSdownload")  
devtools::install_github(c("ejanalysis/proxistat", "ejanalysis/ejanalysis"))
devtools::install_github("ejanalysis/ejscreen")
```
