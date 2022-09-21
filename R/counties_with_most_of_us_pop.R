counties_with_most_of_us_pop <- function(bgpop=ejscreen::bg21$pop, bgFIPS.COUNTY=ejscreen::bg21$FIPS.COUNTY, cut1=50, cut2=80) {
  
  z = aggregate(bgpop, by = list(bgFIPS.COUNTY), FUN = function(z) sum(z, na.rm = TRUE))
  z = z[order(z$x, decreasing = TRUE), ]
  z$cumpop = cumsum(z$x)
  z$cumpctpop = cumsum(z$x) / sum(z$x, na.rm = TRUE)
  z$cumpctcounties = (1:NROW(z)) / NROW(z)
 
  pct_of_c1   <- round(max(z$cumpctcounties[z$cumpctpop < cut1/100 + 0.0001 ]) * 100,1)
  count_of_c1 <- round(max(z$cumpctcounties[z$cumpctpop < cut1/100 + 0.0001 ]) * nrow(z),0)
  
  pct_of_c2   <- round(max(z$cumpctcounties[z$cumpctpop < cut2/100 + 0.0001 ]) * 100,1)
  count_of_c2 <- round(max(z$cumpctcounties[z$cumpctpop < cut2/100 + 0.0001 ]) * nrow(z),0)
  
  plot(
    z$cumpctcounties , z$cumpctpop, 
    xlab='cum % of US counties', ylab = 'cum % of US pop',
    main = 'Only a small # of US Counties contain the vast majority of US residents' 
  )
  mtext(paste0(count_of_c1, ' (', pct_of_c1,' % of) counties have ', round(cut1,0), '% of the US pop, and ',
               count_of_c2, ' (', pct_of_c2,' % of) counties have ', round(cut2,0), '% of the US pop'))
  abline(h=cut1/100)
  abline(h=cut2/100)
  
}
