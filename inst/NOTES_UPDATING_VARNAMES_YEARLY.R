# updating variables in ejscreen with names of indicators for EJScreen 2.0

##################################### #
# SPECIFY NEW NAMES INFO #### 
##################################### #

# ENVIRONMENTAL / EJ INDICATORS

new.e      <- 'ust'
new.e.nice <- 'Underground Storage Tanks (UST) Indicator'
new.e.glossaryfieldname = 'Underground Storage Tanks Indicator'
new.e.gdbfieldname = 'UST'
new.e.popunits <- 'UST indicator' # could be, e.g., ppb
new.esigfigs = 2

# DEMOGRAPHIC INDICATORS

new.d.pct   <- 'pctunemployed'
new.d.nice  <- '% Unemployed'

new.d.info <- data.frame(
  gdbfieldname = c(
    "ACSUNEMPBAS", 
    "UNEMPLOYED", 
    "UNEMPPCT", 
    "P_UNEMPPCT", 
    "B_UNEMPPCT", 
    "T_UNEMPPCT"
  ),
  Rfieldname = c(
    "unemployedbase", 
    "unemployed", 
    "pctunemployed", 
    "pctile.pctunemployed", 
    "bin.unemployed", 
    "pctile.text.unemployed"
  ), 
  acsfieldname = rep(NA_character_, 6), 
  type = rep('Demographic Supplementary', 6), 
  glossaryfieldname = c(
    "Count of denominator for percent unemployed", 
    "Count of people unemployed", 
    "Percent Unemployed", 
    "Percentile for % unemployed", 
    "Map color bin for percent unemployed", 
    "Map popup text for percent unemployed"
  ), 
  formula = c(
    NA, 
    NA, 
    "pctunemployed <- ifelse(unemployedbase==0, 0, as.numeric(unemployed) / unemployedbase)",
    NA, 
    NA, 
    NA
  ), 
  acsfieldnamelong = rep(NA_character_, 6), 
  universe = rep(NA_character_, 6)
)
# DEMOG INFO for the ejscreenformulas table:
#     "gdbfieldname"          "Rfieldname" "acsfieldname"      "type"              "glossaryfieldname"       "formula"           "acsfieldnamelong"  "universe"    
#
# 1100  ACSUNEMPBAS         unemployedbase         <NA> Demographic Supplementary Count of denominator for percent unemployed
# 2100   UNEMPLOYED             unemployed         <NA> Demographic Supplementary                  Count of people unemployed
# 3100     UNEMPPCT          pctunemployed         <NA> Demographic Supplementary                          Percent Unemployed
# 610    P_UNEMPPCT   pctile.pctunemployed         <NA> Demographic Supplementary                 Percentile for % unemployed
# 910    B_UNEMPPCT         bin.unemployed         <NA> Demographic Supplementary        Map color bin for percent unemployed
# 1210   T_UNEMPPCT pctile.text.unemployed         <NA> Demographic Supplementary       Map popup text for percent unemployed



###################################################################### #
# Update the lists of names of variables based on the specified new names ####
###################################################################### #

library(ejscreen)
library(usethis)
# usethis::use_data_raw


# ACS VARIABLES:

#??? needed.ejscreen.acs  # NEED TO ADD UNEMPLOYED AND DENOMINATOR FOR THIS - WHICH ACS TABLE IS IT FROM?
# use_data(needed.ejscreen.acs, overwrite=TRUE)
#
# prior to EJScreen 2.0 ACS Summary FIle tables used were 
#   "B01001" "B03002" "B15002" "B16001" "B16002" "B25034" "C17002"
# 
# needed.ejscreen.acs
# seq  table varnum  table.var                                                      varname colnum keep
# 1     2 B01001      1 B01001.001                                             Total population      1    Y
# 2     2 B01001      2 B01001.002                                                        Male:      2    0
# 3     2 B01001      3 B01001.003                                                Under 5 years      3    Y
# 4     2 B01001      4 B01001.004                                                 5 to 9 years      4    Y

#???   vars.ejscreen.acs  # NEED TO ADD UNEMPLOYED AND DENOMINATOR FOR THIS - WHICH ACS TABLE IS IT FROM?
# use_data(vars.ejscreen.acs, overwrite=TRUE)
# 
# needed.ejscreen.acs                                          
# vars.ejscreen.acs 

###################################################################### #
# esigfigs & popupunits - significant digits & units for new ENVT indicator  ####
###################################################################### #

popupunits <- rbind(popupunits, data.frame(evar = new.e, units = new.e.popunits)); popupunits <- unique(popupunits)
use_data(popupunits, overwrite=TRUE)
esigfigs   <- rbind(esigfigs,   data.frame(evar = new.e, sigfigs = new.esigfigs));    esigfigs <- unique(esigfigs)
use_data(esigfigs, overwrite=TRUE)

###################################################################### #
# names.d.nice - nice name to use on graph labels etc. for new indicator  ####
###################################################################### #

names.d.nice <- union(names.d.nice, new.d.nice)
use_data(names.d.nice, overwrite=TRUE)
# These were similar but not identical:

# > ejscreenformulas$glossaryfieldname[match(names.d, ejscreenformulas$Rfieldname)] 
# [1] "Demographic Index (based on 2 factors, % low-income and % people of color (aka minority)"
# [2] "% people of color (aka minority)"                                                        
# [3] "% low-income (i.e., with income below 2 times poverty level)"                            
# [4] "% less than high school"                                                                 
# [5] "% of households (interpreted as individuals) in linguistic isolation"                    
# [6] "% under age 5"                                                                           
# [7] "% over age 64"                              

# > cbind(names.d.nice)  #  THESE ARE VERY SHORT - USEFUL ON GRAPHICS
# names.d.nice        
# [1,] "Demog.Ind."        
# [2,] "% Low-inc."        
# [3,] "% Minority"        
# [4,] "% <High School"    
# [5,] "% Linguistic Isol."
# [6,] "% < age 5"         
# [7,] "% > age 64"        

###################################################################### #
# several lists of variables related to the new DEMOG indicator  ####
###################################################################### #

# were in names.dvars ####
names.d <- union(names.d, new.d.pct) ######################### #
names.d.bin    <- paste0('bin.',    names.d)
names.d.pctile <- paste0('pctile.', names.d)
Dlist   <- as.list(names.d)  

names.d.eo <- c("pctmin", "pctlowinc")  # ok.  ############## #
names.d.eo.bin     <- paste0('bin.',       names.d.eo)
names.d.eo.pctile  <- paste0('pctile.',    names.d.eo)

names.d.subgroups.count <- c("nhwa", "hisp", "nhba", "nhaa", "nhaiana", "nhnhpia", "nhotheralone", "nhmulti") # done (names.dvars)
names.d.subgroups.pct  <- paste0('pct', names.d.subgroups.count) # done (names.dvars)
names.d.subgroups <- names.d.subgroups.pct  # done (names.dvars) 

# (names.dvars)   : *************************************************************************
usethis::use_data( # done #################################
  names.d , 
  names.d.bin ,                                   
  names.d.pctile    ,
  Dlist,
  names.d.eo   ,                                  
  names.d.eo.bin  ,                               
  names.d.eo.pctile ,                             
  names.d.subgroups.count , 
  names.d.subgroups.pct  ,
  names.d.subgroups 
)


###################################################################### #
# names.e.nice - nice name to use on graph labels etc. for new ENVT indicator  ####
###################################################################### #
# names.e.nice <- c(names.e.nice, 'Underground storage tanks (UST) indicator')
names.e.nice <- union(names.e.nice, new.e.nice)
use_data(names.e.nice, overwrite=TRUE)
# or
# names.e.nice <- ejscreenformulas$glossaryfieldname[match(names.e, ejscreenformulas$Rfieldname)] 

# These were similar but not identical:  - NEITHER IS ALWAYS VERY SHORT

# > names.e.nice
# [1] "PM2.5 level in air"                                           
# [2] "Ozone level in air"                                           
# [3] "Air toxics cancer risk"                                       
# [4] "Air toxics respiratory hazard index"                          
# [5] "Diesel particulate matter level in air"                       
# [6] "% pre-1960 housing (lead paint indicator)"                    
# [7] "Traffic proximity and volume"                                 
# [8] "Proximity to National Priorities List (NPL) sites"            
# [9] "Proximity to Risk Management Plan (RMP) facilities"           
# [10] "Proximity to Treatment Storage and Disposal (TSDF) facilities"
# [11] "Proximity to major direct dischargers to water"
# had not add it yet here

# > ejscreenformulas$glossaryfieldname[match(names.e, ejscreenformulas$Rfieldname)] 
# [1] "PM2.5 ug/m3 in air"                                           
# [2] "Ozone ppm in air"                                             
# [3] "Air toxics cancer risk per mill."                             
# [4] "Air toxics respiratory hazard index"                          
# [5] "Diesel particulate matter level in air"                       
# [6] "% pre-1960 housing (lead paint indicator)"                    
# [7] "Traffic proximity and volume"                                 
# [8] "Proximity to National Priorities List (NPL) sites"            
# [9] "Proximity to Risk Management Plan (RMP) facilities"           
# [10] "Proximity to Treatment Storage and Disposal (TSDF) facilities"
# [11] "Indicator for major direct dischargers to water"              
# [12] "Underground Storage Tanks Indicator"  ####

###################################################################### #
# several lists of ENVT and EJ variables related to the new ENVT indicator  ####
# had been saved in names.evars.RData and names.ejvars.RData
# now each is in its own .rda file
###################################################################### #

# related to  names.e  ####
names.e        <- union(names.e, new.e) # done #################################
names.e.bin    <- paste0('bin.',    names.e)
names.e.pctile <- paste0('pctile.', names.e)
Elist <- as.list(names.e)
# names.ejvars
usethis::use_data( # done #################################
  names.e ,
  names.e.bin ,
  names.e.pctile,
  Elist
)




###################################################################### #

# were in names.ejvars ####
names.ej <- paste0('EJ.DISPARITY.',   names.e, '.eo')
names.ej.bin     <- paste0('bin.',    names.ej)
names.ej.pctile  <- paste0('pctile.', names.ej)
## obsolete:
names.ej.burden.eo <- gsub('DISPARITY', 'BURDEN', names.ej)    # obsolete (names.ejvars)
names.ej.burden.eo.bin <- paste0('bin.', names.ej.burden.eo)    # obsolete (names.ejvars)
names.ej.burden.eo.pctile    # obsolete (names.ejvars)
names.ej.pct.eo <- gsub('DISPARITY', 'PCT', names.ej)   # obsolete (names.ejvars)
names.ej.pct.eo.bin <- paste0('bin.', names.ej.pct.eo)   # obsolete (names.ejvars)
names.ej.pct.eo.pctile   <- paste0('pctile.', names.ej.pct.eo)  # obsolete (names.ejvars)
namesall.ej <- c(names.ej, names.ej.burden.eo, names.ej.pct.eo)  # obsolete
namesall.ej.bin <- paste0('bin.', namesall.ej)  # obsolete
namesall.ej.pctile <- paste0('pctile.', namesall.ej)  # obsolete

usethis::use_data(  # done #################################
  
  names.ej ,
  names.ej.bin ,   
  names.ej.burden.eo ,
  names.ej.burden.eo.bin ,
  names.ej.burden.eo.pctile ,
  names.ej.pct.eo ,
  names.ej.pct.eo.bin  ,
  names.ej.pct.eo.pctile ,
  names.ej.pctile ,
  namesall.ej  ,
  namesall.ej.bin   ,
  namesall.ej.pctile
)

# use_data()  # cannot put several in one data file

###################################################################### #
# UPDATE ejscreenformulas data file  ####
###################################################################### #

#??? need to add rows for each new variable, in ejscreenformulas (and the noej version of that)
#
# names(ejscreenformulas)
# [1] "gdbfieldname"      "Rfieldname"        "acsfieldname"      "type"              "glossaryfieldname"
# [6] "formula"           "acsfieldnamelong"  "universe"         
# 

##################################### #
# ENVT: Add rows to ejscreenformulas for a new environmental indicator and its EJ index ####
##################################### #

# ENVIRONMENTAL INDICATOR 

# ejscreenformulas[ grepl('ust', ejscreenformulas$Rfieldname), ]
#
#      gdbfieldname                      Rfieldname acsfieldname          type
# 482           UST                             ust         <NA> Environmental
# 710         P_UST                      pctile.ust         <NA> Environmental
# 1010        B_UST                         bin.ust         <NA> Environmental
# 1310        T_UST                 pctile.text.ust         <NA> Environmental
# 510       D_UST_2             EJ.DISPARITY.ust.eo         <NA>            EJ
# 810      P_UST_D2      pctile.EJ.DISPARITY.ust.eo         <NA>            EJ
# 1110     B_UST_D2         bin.EJ.DISPARITY.ust.eo         <NA>            EJ
# 1410     T_UST_D2 pctile.text.EJ.DISPARITY.ust.eo         <NA>            EJ

#                                                          glossaryfieldname                                        formula acsfieldnamelong
#   482                                  Underground Storage Tanks Indicator                                           <NA>             <NA>
#   710                   Percentile for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1010               Map color bin for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1310              Map popup text for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   510                     EJ Index for Underground Storage Tanks Indicator EJ.DISPARITY.ust.eo <-            VDI.eo * ust             <NA>
#   810      Percentile for EJ Index for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1110  Map color bin for EJ Index for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   1410 Map popup text for EJ Index for Underground Storage Tanks Indicator                                           <NA>             <NA>
#   universe
# 482      <NA>
#   710      <NA>
#   1010     <NA>
#   1310     <NA>
#   510      <NA>
#   810      <NA>
#   1110     <NA>
#   1410     <NA>
#   

ejscreenformulas.newrows <- data.frame(matrix(NA, nrow = 8, ncol = NCOL(ejscreenformulas)))
names(ejscreenformulas.newrows) <- names(ejscreenformulas)
newg <- new.e.gdbfieldname
ejscreenformulas.newrows$gdbfieldname <- c(newg, paste0("P_",newg), paste0("B_",newg), paste0("T_",newg), paste0("D_",newg,"_2"), paste0("P_",newg,"_D2"), paste0("B_",newg,"_D2"), paste0("T_",newg,"_D2"))
ejscreenformulas.newrows$Rfieldname <- c(new.e, paste0(c('pctile.', 'bin.', 'pctile.text.', 'EJ.DISPARITY.', 'pctile.EJ.DISPARITY.', 'bin.EJ.DISPARITY.', 'pctile.text.EJ.DISPARITY.'), new.e))
ejscreenformulas.newrows$Rfieldname <- gsub('(DISPARITY\\..*)','\\1.eo', ejscreenformulas.newrows$Rfieldname)
ejscreenformulas.newrows$type <- c(rep('Environmental',4), rep('EJ', 4))
ejscreenformulas.newrows$glossaryfieldname <- paste0( 
  c('', "Percentile for ", "Map color bin for ", "Map popup text for ", "EJ Index for ", "Percentile for EJ Index for ",
    "Map color bin for EJ Index for ", "Map popup text for EJ Index for "), new.e.nice)

# edit/fix the new rows to be added to the info table called ejscreenformulas 
ejscreenformulas.newrows <- edit(ejscreenformulas.newrows)
warning('make sure this is right')
# 
ejscreenformulas <- rbind(ejscreenformulas, ejscreenformulas.newrows)
use_data(ejscreenformulas)   # do this manually or carefully ##################### #

##################################### #
# DEMOG: Add rows to ejscreenformulas for a new Demographic indicator ####
##################################### #

# > ejscreenformulas[grep('unemp', ejscreenformulas$Rfieldname), ]

#      gdbfieldname             Rfieldname acsfieldname                      type                           glossaryfieldname

# 1100  ACSUNEMPBAS         unemployedbase         <NA> Demographic Supplementary Count of denominator for percent unemployed
# 2100   UNEMPLOYED             unemployed         <NA> Demographic Supplementary                  Count of people unemployed
# 3100     UNEMPPCT          pctunemployed         <NA> Demographic Supplementary                          Percent Unemployed
# 610    P_UNEMPPCT   pctile.pctunemployed         <NA> Demographic Supplementary                 Percentile for % unemployed
# 910    B_UNEMPPCT         bin.unemployed         <NA> Demographic Supplementary        Map color bin for percent unemployed
# 1210   T_UNEMPPCT pctile.text.unemployed         <NA> Demographic Supplementary       Map popup text for percent unemployed

#                                                                                       formula acsfieldnamelong universe
#   1100                                                                                   <NA>             <NA>     <NA>
#   2100                                                                                   <NA>             <NA>     <NA>
#   3100 pctunemployed <- ifelse(unemployedbase==0, 0, as.numeric(unemployed) / unemployedbase)             <NA>     <NA>
#   610                                                                                    <NA>             <NA>     <NA>
#   910                                                                                    <NA>             <NA>     <NA>
#   1210                                                                                   <NA>             <NA>     <NA>
#   

# ejscreenformulas.newrows <- data.frame(matrix(NA, nrow = 8, ncol = NCOL(ejscreenformulas)))
# names(ejscreenformulas.newrows) <- names(ejscreenformulas)
ejscreenformulas.newrows <- new.d.info 


# edit/fix the new rows to be added to the info table called ejscreenformulas 
ejscreenformulas.newrows <- edit(ejscreenformulas.newrows)
warning('make sure this is right')
# 
ejscreenformulas <- rbind(ejscreenformulas, ejscreenformulas.newrows)
use_data(ejscreenformulas)   # do this manually or carefully ##################### #

###################################################################### #

