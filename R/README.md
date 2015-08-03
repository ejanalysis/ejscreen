**ejscreen package**

This [EJSCREEN data/tools package](https://ejanalysis.github.io/ejscreen/) provides tools for R related to environmental justice (EJ) analysis, specifically related to the United States Environmental Protection Agency (EPA) screening and mapping/GIS tool called EJSCREEN. See \url{http://www.epa.gov/ejscreen}. This package facilitates development of the EJSCREEN dataset, based on user-provided environmental indicators. The resulting dataset is a data.frame that contains data on demographics (e.g., percent of residents who are low-income) and user-provided local environmental indicators (e.g., an air quality index), and calculated indicators called EJ Indexes, which combine environmental and demographic indicators. The dataset also provides each key indicator as a national population-percentile that represents what percentage of the US population have equal or lower raw values for the given indicator. The dataset has one row per spatial location (e.g., Census block group).

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
