if (1 == 0) {



  where <- rep(TRUE, NROW(bg18))
  # where <- (bg18$REGION == 9) & (bg18$ST != 'HI')
  # where <- bg18$ST == 'TX'
  # where <- bg18$ST == 'CA'
  # where <- bg18$ST == 'NY'
  xli <- NULL; yli <- NULL
  # for whole contig usa:
  # xli <- c(-130, -60); yli <- c(17,50)
  redspot <- analyze.stuff::rowMaxs(bg18[where, ][ , names.ej.pctile]) >= 99 # only 19k/240k block groups have an EJ index at 99th+ %ile



  # PLOT OF USA BLOCK GROUPS HIGHLIGHTING KEY ONES AS RED DOTS, hiding AK/HI
  with(bg18[where, ], plot(lon, lat, pch = '.', col = 'gray',
                           xlim = xli, yli = yli ))
  #redspot <- bg18$flagged
  #redspot <- pmax(bg18[ , names.ej.bin]) == 11
  with(bg18[where, ], points(lon[redspot], lat[redspot],  col = 'red')) # pch = '.',
  title('Block groups with at least 1 of 12 EJ indexes >= 99th%ile')




  }
