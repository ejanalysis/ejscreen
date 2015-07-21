###############################################################
#	R CODE TO ASSIGN FRIENDLY SHORT WORKING NAMES TO VARIABLES
#	AND
# TO CALCULATE THE DERIVED DEMOGRAPHIC FIELDS LIKE PERCENTAGES
###############################################################

ejscreen.acs.rename <- function(acsraw, folder=getwd(), formulafile='EJSCREEN_FIELDNAMES_AND_FORMULAS_20150505.csv') {
  # RENAME FIELDS FROM CENSUS NAMES TO EPA'S EJSCREEN FIELDNAMES
  # get formulafile via data()...?
  names(acsraw) <- analyze.stuff::change.fieldnames(names(acsraw), file=file.path(folder, formulafile))
  # Note old versions:
  # 'MAP OF CENSUS VS EJSCREEN-EPA FIELDNAMES.CSV' was for demographics only, and a different fieldnames map was available for EJ/envt/etc.:
  # names(bg) <- change.fieldnames('saved fieldnames maps Contractor to EPA varnames 2014-05-22.csv')
  return(acsraw)
}

ejscreen.acs.calc <- function(acsraw, folder=getwd(), keep.of.originals, mykeep) {

  # USE FORMULAS FOR CALCULATED VARIABLES
  ################################################################
  # SPECIFY WHICH FIELDS TO KEEP,
  # OF THOSE THAT WERE ALREADY THERE &
  # OF THOSE JUST NOW CALCULATED
  ################################################################

  if (missing(keep.of.originals)) {
    keep.of.originals <- c(
      'FIPS',
      'ST',
      'pop',
      'builtunits',
      'age25up',
      'povknownratio',
      'hhlds',
      'hisp',
      'nhwa',
      'nhba',
      'nhaiana',
      'nhaa',
      'nhnhpia',
      'nhotheralone',
      'nhmulti'
    )
  }

  if (missing(mykeep)) {
    mykeep <- c(
      'pctpre1960',
      'pctlowinc',
      'pctmin',
      'pctlths',
      'pctlingiso',
      'pctunder5',
      'pctover64',
      'pre1960',
      'lowinc',
      'mins',
      'nonmins',
      'lths',
      'lingiso',
      'under5',
      'over64',
      'pcthisp',
      'pctnhwa',
      'pctnhba',
      'pctnhaiana',
      'pctnhaa',
      'pctnhnhpia',
      'pctnhotheralone',
      'pctnhmulti'
    )
  }
  new.fields <- analyze.stuff::calc.fields(bg, formulas=myformulas, keep=mykeep)
  bg <- cbind( bg[ , keep.of.originals], new.fields )
  rm(new.fields)

}

if (1==0) {
  ###############################################################
  # older code before had 'EJSCREEN_FIELDNAMES_AND_FORMULAS_20150505.csv'
  ###############################################################
  form1 <- c(
    'pre1960 <- with(bg,  builtpre1940 + built1940to1949 + built1950to1959 )',
    'pctpre1960 <- with(bg,  ifelse( builtunits==0,0, pre1960/builtunits) )'
  )

  form2 <- c(
    'nonmins <- nhwa',
    'mins <- pop - nhwa',
    'pctmin <- ifelse(pop==0,0, as.numeric(mins ) / pop)',
    'pcthisp <-  ifelse(pop==0,0, as.numeric(hisp ) / pop)',
    'pctnhwa <-  ifelse(pop==0,0, as.numeric(nhwa ) / pop)',
    'pctnhba <- ifelse(pop==0,0, as.numeric(nhba ) / pop)',
    'pctnhaiana <- ifelse(pop==0,0, as.numeric(nhaiana ) / pop)',
    'pctnhaa <- ifelse(pop==0,0, as.numeric(nhaa ) / pop)',
    'pctnhnhpia <- ifelse(pop==0,0, as.numeric(nhnhpia ) / pop)',
    'pctnhotheralone <- ifelse(pop==0,0, as.numeric(nhotheralone ) / pop)',
    'pctnhmulti <- ifelse(pop==0,0, as.numeric(nhmulti ) / pop)'
  )

  form3 <- c(
    'num1pov <- pov50 + pov99',
    'num15pov <- num1pov + pov124 + pov149',
    'num2pov <- num1pov + pov124 + pov149 + pov184 + pov199',
    'num2pov.alt <- povknownratio - pov2plus',
    'pct1pov <- ifelse( povknownratio==0,0, num1pov/povknownratio)',
    'pct15pov <- ifelse( povknownratio==0,0, num15pov/povknownratio)',
    'pct2pov <- ifelse( povknownratio==0,0, num2pov/povknownratio)',
    'pct2pov.alt <-ifelse( povknownratio==0,0, num2pov.alt/povknownratio)',
    'lowinc <- num2pov',
    'pctlowinc <- pct2pov'
  )

  form4 <- c(
    'lths <- m0 + m4 + m6 + m8 + m9 + m10 + m11 + m12 + f0 + f4 + f6 + f8 + f9 + f10 + f11 + f12',
    'pctlths <- ifelse(age25up==0,0, as.numeric(lths ) / age25up)'
  )

  form5 <- c(
    'lingiso <- lingisospanish + lingisoeuro + lingisoasian + lingisoother',
    'pctlingiso <- ifelse( hhlds==0,0, lingiso / hhlds)'
  )

  form6 <- c(
    'under5 <- ageunder5m + ageunder5f',
    'pctunder5 <- ifelse( pop==0,0, under5/pop)',
    'over64 <- age65to66m + age6769m + age7074m + age7579m + age8084m + age85upm + age65to66f + age6769f + age7074f + age7579f + age8084f + age85upf',
    'pctover64 <- ifelse( pop==0,0, over64/pop)'
  )

  myformulas <- c(form1, form2, form3, form4, form5, form6)

  # A value of zero was used in cases where the denominator was zero, to avoid division by zero.
  # For example, the formula “pctmin <- ifelse(pop==0,0, as.numeric(mins ) / pop)”
  # indicates that percent minority was calculated as the ratio of number of minorities
  # over total population of a block group, but was set to zero if the population was zero.

  # note: COULD INCLUDE TABLE B16001 HERE FOR DETAILS ON LANGUAGES SPOKEN, but it is by tract only



  ###########################################################
  # SAVE THESE INTERMEDIATE RESULTS - IDEALLY SHOULD SPECIFY A DATA DIRECTORY -
  ###########################################################

  save(bg, file='ACS EJSCREEN BG w calc vars via FTP.RData')


  ##########################################################################################


  ###########################################################
  # NOTES:
  ###########################################################

  if (1==0) {
    Fieldnames changes file as of 5/12/2014   (did not verify this works for 2009-2013 ACS fieldnames, but it did appear to work at first glance)
    'MAP OF CENSUS VS EJSCREEN-EPA FIELDNAMES.CSV'
    is the following:

      new,old,comments
    builtunits,B25034.001,"FORAGEOFOCCUPIEDHOUSINGUNITS(CORRELATEDWITHLEADPAINT)"
    built1950to1959,B25034.008
    built1940to1949,B25034.009
    builtpre1940,B25034.010
    pop,B01001.001,AGEGROUPS
    ageunder5m,B01001.003
    age5to9m,B01001.004
    age10to14m,B01001.005
    age15to17m,B01001.006
    age65to66m,B01001.020
    age6769m,B01001.021
    age7074m,B01001.022
    age7579m,B01001.023
    age8084m,B01001.024
    age85upm,B01001.025
    ageunder5f,B01001.027
    age5to9f,B01001.028
    age10to14f,B01001.029
    age15to17f,B01001.030
    age65to66f,B01001.044
    age6769f,B01001.045
    age7074f,B01001.046
    age7579f,B01001.047
    age8084f,B01001.048
    age85upf,B01001.049
    hisp,B03002.012,"RACE/ETHNICITY"
    pop3002,B03002.001
    nonhisp,B03002.002
    nhwa,B03002.003
    nhba,B03002.004
    nhaiana,B03002.005
    nhaa,B03002.006
    nhnhpia,B03002.007
    nhotheralone,B03002.008
    nhmulti,B03002.009
    age25up,B15002.001,"EDUCATIONALATTAINMENTFORTHOSEAGE25+"
    m0,B15002.003,"(malesage25+withzeroeducation)"
    m4,B15002.004,"(malesage25+with>0upto4thgrade)"
    m6,B15002.005
    m8,B15002.006
    m9,B15002.007
    m10,B15002.008
    m11,B15002.009
    m12,B15002.010,"(malesage25+withhighschooldiploma)"
    f0,B15002.020
    f4,B15002.021
    f6,B15002.022
    f8,B15002.023
    f9,B15002.024
    f10,B15002.025
    f11,B15002.026
    f12,B15002.027
    hhlds,B16002.001,"HOUSEHOLDSTHATARELINGUISTICALLYISOLATED"
    lingisospanish,B16002.004
    lingisoeuro,B16002.007
    lingisoasian,B16002.010
    lingisoother,B16002.013
    povknownratio,C17002.001,"INDIVIDUALSBYRATIOOFINCOMETOPOVERTYTHRESHOLD"
    pov50,C17002.002,"(below0.50timespovertythreshold)"
    pov99,C17002.003,"(0.5to0.99timespovertythreshold)"
    pov124,C17002.004
    pov149,C17002.005
    pov184,C17002.006
    pov199,C17002.007
    pov2plus,C17002.008
  }
}
}

