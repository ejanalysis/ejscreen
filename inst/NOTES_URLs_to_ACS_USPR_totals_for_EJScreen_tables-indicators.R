
################################ #
# detailed ACS tables, at national level, via url
#
# Detailed Tables contain the most detailed cross-tabulations, many of which are published down to block groups. The data are population counts. There are over 20,000 variables in this dataset.
#
# URL links to see US /PR totals for EJScreen variables (count and MOE but not percent):
myurls <-
c(
'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.B01001',
'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.B03002',
'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.B15002',

# C16002 replaced B16004 that was older ACS source for what had been called linguistic isolation, now called limited English speaking households.
# 'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.B16004',
'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.C16002',


'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.C17002',
'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.B23025',
'https://data.census.gov/cedsci/table?g=0100000US_0400000US72&y=2020&moe=false&tid=ACSDT5Y2020.B25034'
)
for (url in myurls) browseURL(url)


################################ #
# data profiles
#
# URL links to see US /PR totals ***and percents*** for ***most but not all*** EJScreen variables:
#
# Data Profiles contain broad social, economic, housing, and demographic information. The data are presented as population counts and percentages. There are over 1,000 variables in this dataset.
# *** Not in those data profiles: lowincome in only in detailed tables (data profile just has % poor), linguistic isolation (just has language spoken at home).
# in the data profiles: easy to get via weblink without needing API key:
#
# US and PR, acs 5yr data profile:  AGE, AND RACE-ETHNICITY POP COUNTS AND PERCENTS in dp05
browseURL('https://data.census.gov/cedsci/table?g=0100000US_0400000US72&d=ACS%205-Year%20Estimates%20Data%20Profiles&tid=ACSDP5Y2020.DP05')
# US and PR, acs 5yr data profile:  LESS THAN HIGH SCHOOL EDUCATION in dp02
browseURL('https://data.census.gov/cedsci/table?t=Educational%20Attainment&g=0100000US_0400000US72&d=ACS%205-Year%20Estimates%20Data%20Profiles&tid=ACSDP5Y2020.DP02&moe=false')
# US and PR, acs 5yr data profile:  poverty and unemployment in dp03
browseURL('https://data.census.gov/cedsci/table?g=0100000US_0400000US72&d=ACS%205-Year%20Estimates%20Data%20Profiles&tid=ACSDP5Y2020.DP03')
# US and PR, acs 5yr data profile:  PRE 1960 HOUSING COUNTS AND PERCENTS in dp04
browseURL('https://data.census.gov/cedsci/table?g=0100000US_0400000US72&d=ACS%205-Year%20Estimates%20Data%20Profiles&tid=ACSDP5Y2020.DP04&moe=false')


################################ #
# subject tables
#
# Subject Tables provide an overview of the estimates available in a particular topic.  T
# he data are presented as population counts and percentages.  There are over 18,000 variables in this dataset.


