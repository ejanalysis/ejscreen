
# THESE ARE JUST SOME ROUGH NOTES


library(ejscreen)

evarcount=11

nsampled = 100000
for (n in 1:evarcount) {
  sampled = sample(1:nrow(bg20),size = nsampled)
  a <- bg20[sampled , names.e.pctile[n]]
  b <- bg21[sampled , names.e.pctile[n]]
  mymain <- names.e.nice[n]
  plot(x=a, y=b, pch='.', main=mymain, xlab='%ile in 2020 version', ylab='%ile in EJScreen 2.0')
  abline(h=80)
  abline(v=80)
  # pause(1)
  
  
  a <- bg20[,names.e.bin[n]]
  b <- bg21[,names.e.bin[n]]
  cat('\n', mymain, ' - map colors (percentile bins) - Fraction of blockgroups (not people)\n')
  
  # mylabs <- c('<80th','80-89th','90-94','95+')
  # mybreaks <- c(0,8,9,10,11)
  
  mylabs <- c('<80th','80th or higher')
  mybreaks <- c(0,8,11)
  
  
  print(
   round(100 * table(
      prior       = cut(a, breaks = mybreaks, labels = mylabs),
      new_dataset = cut(b, breaks = mybreaks, labels = mylabs),
      useNA = 'always') / NROW(a) , 0)
    
    # table(
    #   prior=cut(a, breaks = c(50,80,90,95,100)),
    #   new_dataset=cut(b, breaks = c(50,80,90,95,100)),
    #   useNA = 'always')
    
  )
}



######################################

nstats=3 # how many summary stats
evarcount=11
results <- data.frame(matrix(nrow = evarcount, ncol = nstats+1))
names(results) <- c('indicator', 'diff', 'absdiff', 'ratio')


compared <- function(a,b,dig=2) {
  actualdiff <- a-b
  
  absdiff <- abs(actualdiff)
  
  ratio.ab <- a/b # can be div by 0, inf
  
  # print(mean(actualdiff, na.rm=TRUE))
  # print(mean(absdiff, na.rm=TRUE))
  # print(mean(ratio.ab, na.rm=TRUE))
  round(c(diff=mean(actualdiff, na.rm=TRUE), absdiff=mean(absdiff, na.rm=TRUE), ratio=mean(ratio.ab, na.rm=TRUE)),digits = dig)
}



for (n in 1:evarcount) {
  a <- bg20[,names.e[n]]
  b <- bg21[,names.e[n]]
  
  results[n,] <- c(names.e[n], compared(a,b))
}
print(results)





n=1


a <- bg20[,names.e[n]]
b <- bg21[,names.e[n]]
mymain <- names.e.nice[n]
mymin <- min(range(a, na.rm = TRUE)[1], range(b, na.rm = TRUE)[1], na.rm = TRUE)
mymax <- max(range(a, na.rm = TRUE)[2], range(b, na.rm = TRUE)[2], na.rm = TRUE)
myxlim <- myylim <- c(mymin, mymax)

nn <- 100000
some <- sample(seq_along(a), nn)
plot(a[some], b[some], pch='.', 
     xlab="EJSCREEN version 2020 released in 2021", 
     ylab='EJScreen 2.0 released Feb 2022', 
     main=mymain, 
     xlim= myxlim,
     ylim=myylim)
