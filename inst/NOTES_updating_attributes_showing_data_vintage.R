# setting attributes on datasets that make clear their vintage


##################################################################
# ejscreen package

# EJAM::metadata_check(packages = 'ejscreen')
#
#                             census_version acs_version acs_releasedate ACS         ejscreen_version ejscreen_releasedate ejscreen_pkg_data year released
# Dlist                                 NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# Elist                                 NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# MeansByGroup_and_Ratios               2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "September 2022"     "bg22"            NULL NULL
# States_2022_LOOKUP                    NULL           NULL        NULL            "2016-2020" "2.1"            NULL                 NULL              NULL "late 2022"
# USA_2021_LOOKUP                       NULL           NULL        NULL            "2015-2019" "2.0"            NULL                 NULL              NULL "early 2022"
# USA_2022_LOOKUP                       NULL           NULL        NULL            "2016-2020" "2.1"            NULL                 NULL              NULL "late 2022"
# acs_B03002_2016_2020_bg_tract         2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "September 2022"     "bg22"            NULL NULL
# bg22                                  2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "September 2022"     "bg22"            NULL NULL
# bg22DemographicSubgroups2016to2020    2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "September 2022"     "bg22"            NULL NULL
# ejscreenformulas                      2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "October 2022"       "bg22"            NULL NULL
# ejscreenformulasnoej                  2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "October 2022"       "bg22"            NULL NULL
# esigfigs                              NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# lookupStates                          NULL           NULL        NULL            "2016-2020" "2.1"            NULL                 NULL              NULL "late 2022"
# lookupUSA                             NULL           NULL        NULL            "2016-2020" "2.1"            NULL                 NULL              NULL "late 2022"
# names.d                               NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# ETC
# ETC


# usastats    <- ejscreen::add_metadata(usastats)
# regionstats <- ejscreen::add_metadata(regionstats)
# statestats  <- ejscreen::add_metadata(statestats)
# # while in working directory of source package:
# usethis::use_data(usastats, overwrite = T)


##################################################################
# EJAM and related packages
# 'EJAMfrsdata',
# EJAM::metadata_check(packages = c('EJAM', 'EJAMejscreendata',  'EJAMblockdata'))
#
# $EJAM
#               census_version acs_version acs_releasedate ACS         ejscreen_version ejscreen_releasedate ejscreen_pkg_data year released
# NAICS                   NULL           NULL        NULL            NULL        NULL             NULL                 NULL              2017 NULL
# bgpts                   NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# blockgroupstats         2020           "2016-2020" "3/17/2022"     NULL        "2.1"            "September 2022"     "bg22"            NULL NULL
# names_all               NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_d                 NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_d_count           NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_d_pctile          NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_d_state_pctile    NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_d_subgroups       NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_d_subgroups_count NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_e                 NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_e_pctile          NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_e_state_pctile    NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_ej                NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_ej_pctile         NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_ej_state_pctile   NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# names_other             NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# testpoints_1000      NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# testpoints_100         NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# regionstats             NULL           NULL        NULL            "2015-2019" "2.0"            NULL                 NULL              NULL 2022
# sites2blocks_example    NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# stateinfo               NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# stateregions            NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# statesshp               NULL           NULL        NULL            NULL        NULL             NULL                 NULL              NULL NULL
# statestats              NULL           NULL        NULL            "2016-2020" "2.1"            NULL                 NULL              NULL "late 2022"
# usastats                NULL           NULL        NULL            "2016-2020" "2.1"            NULL                 NULL              NULL "late 2022"
#
# $EJAMejscreendata
#                            census_version acs_version acs_releasedate ACS  ejscreen_version ejscreen_releasedate ejscreen_pkg_data year released
# EJSCREEN_Full_with_AS_CNMI_GU_VI     2020           "2016-2020" "3/17/2022"     NULL "2.1"            "October 2022"       "bg22"            NULL NULL
# EJSCREEN_StatePct_with_AS_CNMI_GU_VI 2020           "2016-2020" "3/17/2022"     NULL "2.1"            "October 2022"       "bg22"            NULL NULL
# States_2022                          2020           "2016-2020" "3/17/2022"     NULL "2.1"            "October 2022"       "bg22"            NULL NULL
# USA_2022                             2020           "2016-2020" "3/17/2022"     NULL "2.1"            "October 2022"       "bg22"            NULL NULL
#
# $EJAMfrsdata - these were moved to EJAM pkg though
#        census_version acs_version acs_releasedate ACS  ejscreen_version ejscreen_releasedate ejscreen_pkg_data year released
# frs              NULL           NULL        NULL            NULL NULL             NULL                 NULL              NULL "2022-10-11"
# frs_by_naics     NULL           NULL        NULL            NULL NULL             NULL                 NULL              NULL "2022-10-11"
# frs_by_programid NULL           NULL        NULL            NULL NULL             NULL                 NULL              NULL "2022-10-11"
#
# $EJAMblockdata
#     census_version acs_version acs_releasedate ACS  ejscreen_version ejscreen_releasedate ejscreen_pkg_data year released
# bgid2fips     2020           "2016-2020" NULL            NULL "2.1"            "September 2022"     NULL              NULL NULL
# blockid2fips  2020           "2016-2020" NULL            NULL "2.1"            "September 2022"     NULL              NULL NULL
# blockpoints   2020           "2016-2020" NULL            NULL "2.1"            "September 2022"     NULL              NULL NULL
# blockquadtree 2020           "2016-2020" NULL            NULL "2.1"            "September 2022"     NULL              NULL NULL
# blockwts      2020           "2016-2020" NULL            NULL "2.1"            "September 2022"     NULL              NULL NULL
# lookup_states NULL           NULL        NULL            NULL NULL             NULL                 NULL              NULL NULL
# quaddata      2020           "2016-2020" NULL            NULL "2.1"            "September 2022"     NULL              NULL NULL



# USA_2022 <- EJAM::metadata_add(EJAMejscreendata::USA_2022)
# USA_2022 <- EJAM::metadata_add(EJAMejscreendata::States_2022)
# # while in working directory of source package:
# usethis::use_data(USA_2022, overwrite = T)
# usethis::use_data(States_2022, overwrite = T)


# note: The 2017-2021 American Community Survey 5-year estimates are scheduled to be released on Thursday, December 8, 2022.




