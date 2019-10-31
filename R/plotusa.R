if (1 == 0) {

  # ALSO SEE PACKAGE  library(tmap)

  ######################### #
  # PLOT SIMPLE MAP OF US OR STATE FOR ONE CATEGORICAL VARIABLE

  mystate <- 'MD'

  where <- bg18$ST == mystate
  md <- bg18[where, ]
  traffic95 <- md$pctile.traffic.score >= 95
  traffic90 <- md$pctile.traffic.score >= 90
  par(cex = 1)
  plot(md$lon, md$lat, col = 'gray', cex = 1,
       main = paste('Traffic Proximity in', mystate, '(Red=worst 5% in USA)'), xlab = '', ylab = '')
  par(cex = 0.4)
  with(md[traffic90, ], points(lon, lat, col = 'orange'))
  with(md[traffic95, ], points(lon, lat, col = 'red'))
  par(cex = 1)
  # with(md[traffic95, ], points(lon, lat, col = 'red'))


  ######################### #
  #  USA overall
  ######################### #
  # PLOT OF USA BLOCK GROUPS HIGHLIGHTING KEY ONES AS RED DOTS, hiding AK/HI


  where <- rep(TRUE, NROW(bg18)) # bg18 is via lazy loading or data(bg18)
  # where <- (bg18$REGION == 9) & (bg18$ST != 'HI')
  # where <- bg18$ST == 'TX'
  # where <- bg18$ST == 'CA'
  # where <- bg18$ST == 'NY'

  # for a state
  xli <- NULL; yli <- NULL

  # for whole contig usa:
   xli <- c(-130, -60); yli <- c(17,50)

   #######################
   # All the EJ Indexes summarized into one
   # Block groups with at least 1 of 12 EJ indexes >= 99th%ile

   redspot <- analyze.stuff::rowMaxs(bg18[where, ][ , names.ej.pctile]) >= 99 # only 19k/240k block groups have an EJ index at 99th+ %ile


  with(bg18[where, ], plot(lon, lat, pch = '.', col = 'gray',
                           xlim = xli, yli = yli ))
  #redspot <- bg18$flagged
  #redspot <- pmax(bg18[ , names.ej.bin]) == 11
  with(bg18[where, ], points(lon[redspot], lat[redspot],  col = 'red')) # pch = '.',
  title('Block groups with at least 1 of 12 EJ indexes >= 99th%ile')





  }
