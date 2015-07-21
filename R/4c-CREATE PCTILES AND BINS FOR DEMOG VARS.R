# CREATE PCTILE AND BIN COLS FOR DEMOG VARS

bg <- data.frame(bg, make.bin.pctile.cols( bg[,names.d], weights=bg$pop) , stringsAsFactors=FALSE)

# this does not create pctile or bin for pop field - is that needed?
# same for demog subgroups, in names.d.subgroups.count and names.d.subgroups.pct

filename='ACS 2009-2013 EJSCREEN BG w calc vars and D pctiles via FTP.RData'
save(bg, file=filename)
cat('Done creating demographic percentiles and bins '); print(Sys.time())


# also need this for Envt and EJ index cols at some point

