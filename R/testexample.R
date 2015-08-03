# test example
if (1==0) {

mybg.e=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12), air=rlnorm(1000), water=rlnorm(1000)*5, stringsAsFactors=FALSE)

myacsraw=data.frame(FIPS=analyze.stuff::lead.zeroes(1:1000, 12), pop=rnorm(n=1000, mean=1400, sd=200), mins=runif(1000, 0, 800), lowinc=runif(1000, 0,500), stringsAsFactors=FALSE)

x=ejscreen.create(bg.e=mybg.e, acsraw=myacsraw)
}
