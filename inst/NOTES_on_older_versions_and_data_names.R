# notes on data() variables defined for EJSCREEN,
# with those names in rdata files in the inst subfolder of the package
#
# This shows the variable like names.e and in parens which .rdata file contains it
# and the variable like names.e in turn is a vector of character elements
# like pm, cancer, etc. (an exception is that Elist is a list not a vector)

#   right now in names.evars file

# Elist                       (names.evars)
# names.e        regex  isolating those is something like  [^y]names\.e[^1jv\.]  but that includes 1 character before and after names.e such as names.e[ or names.e; or names.e} or :names.e or "names.e" etc. etc.
# names.e.bin
# names.e.pctile

#   right now in names.d  file

#

#   right now in names.ejvars file

# names.ej                    (names.ejvars)
# names.ej.bin
# names.ej.burden.eo
# names.ej.burden.eo.bin
# names.ej.burden.eo.pctile
# names.ej.pct.eo
# names.ej.pct.eo.bin
# names.ej.pct.eo.pctile
# names.ej.pct.eo
# names.ej.pct.eo.bin
# names.ej.pct.eo.pctile
# names.ej.pct.eo
# names.ej.pct.eo.bin
# names.ej.pct.eo.pctile

# other related stuff -  ejscreen::nicenames() which relies on  ejscreenformulas data
# and   ejscreen::names.e.nice, names.d.nice,

