# changes made 9/17/2016
if (1 == 0 ) {
  # changes to names.e, etc. for 2016 dataset
  # old 2015 changed so names.e15 etc ends in 15, and saved as ...15.RData files
  # the 2016 saved as ...16.RData files (but then maybe removed from pkg since causes a warning about two data files creating the same variables)
  # the 2017 will be in ...17.RData files etc.  
  # and also saved as ...RData files to be the default now. This should always be the latest current version.
  
  # get and change 2015 files:
  data("names.evars") # when it was 2015 version
  data('names.ejvars') # when it was 2015 version
  # then rename those files names.evars15.RData and names.ejvars15.RData
  names.e15 <- names.e
  names.e.bin15 <- names.e.bin
  names.e.pctile15 <- names.e.pctile
  Elist15 <- Elist
  save(names.e15, names.e.bin15, names.e.pctile15, Elist15, file = '/Users/markcorrales/Documents/R PACKAGES/ejscreen/data/names.evars15.RData')
  
  # same for ej (many names) -- ensure only 2015 version is loaded, no ejscreen pkg in search path
  EJNAMES <- grep('.ej', ls(), value = TRUE)
  EJNAMES15 <- paste(EJNAMES, '15', sep = '')
  for (i in 1:length(EJNAMES15)) {
    assign(EJNAMES15[i], get(EJNAMES[i]) )
  }
  dput(EJNAMES15) 
  save( "names.ej15", "names.ej.bin15", "names.ej.burden.eo15", "names.ej.burden.eo.bin15", 
          "names.ej.burden.eo.pctile15", "names.ej.burden.svi615", "names.ej.burden.svi6.bin15", 
          "names.ej.burden.svi6.pctile15", "names.ej.pct.eo15", "names.ej.pct.eo.bin15", 
          "names.ej.pct.eo.pctile15", "names.ej.pct.svi615", "names.ej.pct.svi6.bin15", 
          "names.ej.pct.svi6.pctile15", "names.ej.pctile15", "names.ej.svi615", 
          "names.ej.svi6.bin15", "names.ej.svi6.pctile15", "namesall.ej15", 
          "namesall.ej.bin15", "namesall.ej.pctile15", 
       file = '/Users/markcorrales/Documents/R PACKAGES/ejscreen/data/names.ejvars15.RData')
  
  
  # And created .R documentation files for names.evars, names.evars15, names.evars16
  
  # create 2016 e name lists
  
  names.e <- names.e[!grepl('neuro', names.e)]
  names.e.bin <- names.e.bin[!grepl('neuro', names.e.bin)]
  names.e.pctile <- names.e.pctile[!grepl('neuro', names.e.pctile)]
  Elist <- Elist[!grepl('neuro', Elist)]
  
#  save(names.e, names.e.bin, names.e.pctile, Elist, file = '/Users/markcorrales/Documents/R PACKAGES/ejscreen/data/names.evars16.RData')
  save(names.e, names.e.bin, names.e.pctile, Elist, file = '/Users/markcorrales/Documents/R PACKAGES/ejscreen/data/names.evars.RData')
  
  
  # create 2016 ej name lists
  
  EJNAMES <- grep('.ej', ls(), value = TRUE)
  for (x in EJNAMES) {
    assign(x, get(x)[!grepl('neuro', get(x))])
  }
  #sapply(EJNAMES,function(x) length(get(x)))
  #dput(EJNAMES)
  
  # save("names.ej", "names.ej.bin", "names.ej.burden.eo", "names.ej.burden.eo.bin", 
  #      "names.ej.burden.eo.pctile", "names.ej.burden.svi6", "names.ej.burden.svi6.bin", 
  #      "names.ej.burden.svi6.pctile", "names.ej.pct.eo", "names.ej.pct.eo.bin", 
  #      "names.ej.pct.eo.pctile", "names.ej.pct.svi6", "names.ej.pct.svi6.bin", 
  #      "names.ej.pct.svi6.pctile", "names.ej.pctile", "names.ej.svi6", 
  #      "names.ej.svi6.bin", "names.ej.svi6.pctile", "namesall.ej", "namesall.ej.bin", 
  #      "namesall.ej.pctile", 
  #      file = '/Users/markcorrales/Documents/R PACKAGES/ejscreen/data/names.ejvars16.RData')
  # 
  save("names.ej", "names.ej.bin", "names.ej.burden.eo", "names.ej.burden.eo.bin", 
       "names.ej.burden.eo.pctile", "names.ej.burden.svi6", "names.ej.burden.svi6.bin", 
       "names.ej.burden.svi6.pctile", "names.ej.pct.eo", "names.ej.pct.eo.bin", 
       "names.ej.pct.eo.pctile", "names.ej.pct.svi6", "names.ej.pct.svi6.bin", 
       "names.ej.pct.svi6.pctile", "names.ej.pctile", "names.ej.svi6", 
       "names.ej.svi6.bin", "names.ej.svi6.pctile", "namesall.ej", "namesall.ej.bin", 
       "namesall.ej.pctile", 
       file = '/Users/markcorrales/Documents/R PACKAGES/ejscreen/data/names.ejvars.RData')
}
