
change.fieldnames.ejscreen.r_to_gdb <- function(rnames) { 
  ejscreen::ejscreenformulas$gdbfieldname[match(rnames,  ejscreen::ejscreenformulas$Rfieldname)]
}

