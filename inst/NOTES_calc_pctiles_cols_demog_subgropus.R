# maybe add demog subgp pctiles cols to blockgroupstats or bg or bg22plus, 
# for demographic subgroups or user-specified indicators

# noting that version 2.1 EJScreen uses blockgroup not population percentiles now, 
# and resolves ties by reporting the lower edge of range - 
# but may be implementing that via the floor() function? will clarify details of their algo/script

bg <- bg22plus 

# test / check
  x <- 100 * make.pctile.cols(bg[ , names.e])
all.equal(x, bg[,names.e.pctile])




us.pctile.d.subgoups     <- 100 * floor(make.pctile.cols(bg[ , names.d.subgroups], weights = 1))
state.pctile.d.subgroups <- floor(100 * make.pctile.cols(bg[ , names.d.subgroups], weights = 1, zone = bg$ST))

# add_metadata() or metadata_add()
# usethis::use_data( )
