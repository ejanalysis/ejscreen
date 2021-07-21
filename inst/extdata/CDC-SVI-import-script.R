# Importing CDC Social Vulnerability Index (SVI) for use in EJSCREEN, etc.
#
# CDC SVI:
#   https://data.cdc.gov/api/views/4d8n-kk8a/rows.csv?accessType=DOWNLOAD
#   https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html
#   https://www.atsdr.cdc.gov/placeandhealth/svi/documentation/SVI_documentation_2018.html
#   https://ephtracking.cdc.gov/DataExplorer/?query=bd33eb3b-acb1-4491-87e3-ecaa9a35eddb
#   https://ephtracking.cdc.gov:443/apigateway/api/v1/getCoreHolder/604/2/all/all/2018/0/0
# PR: Starting with SVI 2014, we’ve added a stand-alone, state-specific Commonwealth of Puerto Rico database. Puerto Rico is not included in the US-wide ranking.
# Citation for 2018 US version: Centers for Disease Control and Prevention/ Agency for Toxic Substances and Disease Registry/ Geospatial Research, Analysis, and Services Program. CDC Social Vulnerability Index 2018 Database US. https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html. Accessed on 4/18/2021.
# Tracts in the top 10%, i.e., at the 90th percentile of values, are given a value of 1 to indicate high vulnerability. Tracts below the 90th percentile are given a value of 0.
# Variables beginning with “E_” are estimates. Variables beginning with “M_” are margins of error for those estimates. Values of -999 represent “null” or “no data.”
# Tracts with zero estimates for total population (N = 645 for the U.S.) were removed during the ranking process.
#   These tracts were added back to the SVI databases after ranking. The TOTPOP field value is 0, but the percentile ranking fields (RPL_THEME1, RPL_THEME2, RPL_THEME3, RPL_THEME4, and RPL_THEMES) were set to -999.
# For tracts with > 0 TOTPOP, a value of -999 in any field either means the value was unavailable from the original census data or we could not calculate a derived value because of unavailable census data.
#   Any cells with a -999 were not used for further calculations. For example, total flags do not include fields with a -999 value.
# Indicators in the SVI:
#   Socioeconomic Status:  Below Poverty, Unemployed, Income, No High School Diploma
#   Household Composition & Disability:  Aged 65 or Older, Aged 17 or Younger, Civilian with a Disability, Single-Parent Households
#   Minority Status & Language:  Minority, Speaks English “Less than Well”
#   Housing Type & Transportation:  Multi-Unit Structures, Mobile Homes, Crowding, No Vehicle, Group Quarters
#   For SVI 2018, we included two adjunct variables, 1) 2014-2018 ACS estimates for persons without health insurance, and 2) an estimate of daytime population derived from LandScan 2018 estimates. These adjunct variables are excluded from SVI rankings.
# or a detailed description of SVI variable selection rationale and methods, see A Social Vulnerability Index for Disaster Managementpdf icon (https://www.atsdr.cdc.gov/placeandhealth/svi/img/pdf/Flanagan_2011_SVIforDisasterManagement-508.pdf).
#
# The four summary theme ranking variables, detailed in the Data Dictionary below, are:
#
# Socioeconomic – RPL_THEME1
# Household Composition & Disability – RPL_THEME2
# Minority Status & Language – RPL_THEME3
# Housing Type & Transportation – RPL_THEME4
# Overall tract rankings:  We summed the sums for each theme, ordered the tracts, and then calculated overall percentile rankings. Please note; taking the sum of the sums for each theme is the same as summing individual variable rankings.
#  *** The overall tract summary ranking variable is RPL_THEMES
# Flags
# Tracts in the top 10%, i.e., at the 90th percentile of values, are given
#  a value of 1 to indicate high vulnerability.
# Tracts below the 90th percentile are given a value of 0.
# For a theme, the flag value is the number of flags for variables comprising the theme.
# We calculated the overall flag value for each tract as the number of all variable flags.
# For a detailed description of SVI variable selection rationale and methods, see A Social Vulnerability Index for Disaster Managementpdf icon (https://www.atsdr.cdc.gov/placeandhealth/svi/img/pdf/Flanagan_2011_SVIforDisasterManagement-508.pdf).

# getwd()
download.file('https://data.cdc.gov/api/views/4d8n-kk8a/rows.csv?accessType=DOWNLOAD',  destfile = 'svi2018.csv')

browseURL('https://www.atsdr.cdc.gov/placeandhealth/svi/documentation/SVI_documentation_2018.html')
