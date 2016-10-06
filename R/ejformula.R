#' @title See formula(s) used for EJSCREEN variable(s)
#'
#' @description Just a convenient way to look at the formula(s) used to create one or more variables in EJSCREEN.
#' @param fieldname Optional, character vector specifying variable(s) in \code{ejscreenformulas$Rfieldname}, default is all \code{ejscreenformulas$Rfieldname} that are not NA values.
#' @param decreasing Optional, passed to \code{\link{sort}} except default is not sorted (just the order that exists in \code{\link{ejscreenformulas}})
#' @param recursive Optional, default is FALSE. If TRUE, returns also returns formula(s) for variable(s) found on right hand side of formula(s), i.e. those used to create specified variable(s)
#' @param dropNA Be careful: Optional, default is TRUE. If TRUE, returns only formulas that are not NA values. If FALSE, and decreasing is not specified (sorting drops NA values here), returns vector the same length as \code{fieldname} (unless \code{recursive = TRUE})
#' @return Character vector of the formula(s) used to calculate the specified variable, in \code{ejscreenformulas}
#' @examples 
#'   ejformula('VSI.eo')
#'   ejformula(c('pctmin', 'pctlowinc'))
#'   ejformula('VSI.eo', recursive = T)
#'   ejformula()
#' @seealso \code{\link{ejscreenformulas}}
#' @export
ejformula <- function(fieldname = 'all', decreasing = NA, dropNA = TRUE, recursive = FALSE) {
  data(ejscreenformulas)
  if (fieldname[1] == 'all') {fieldname <- ejscreenformulas$Rfieldname}
  
  # # for each element in vector of fieldnames, return it or its formula:
  # x <- fieldname # if recursively used, they may not be unique
  # for (i in 1:length(x)) {
  #   if (x[i] %in% ejscreenformulas$Rfieldname) {
  #     thisformula <- ejscreenformulas$formula[match(x[i], ejscreenformulas$Rfieldname) ] 
  #     if (!is.na(thisformula)) {x[i] <- thisformula}
  #   }
  # }
  # this returns just the formulas for just the ones that are listed (e.g., not pm since no formula for it)
  x <- ejscreenformulas$formula[match(fieldname, ejscreenformulas$Rfieldname) ]
  # if x is just a variable like pm, x will be empty
  
  if (dropNA) {x <- x[!is.na(x)]}
  
  if (recursive) {
    
    if (all(is.na(x)) | length(x) == 0) {return()}
    getRHS <- function(myform) {
      # find vector of valid Rfieldnames that are within the RHS of the formula
      # use grep?
      # find fieldnames that actually do have a formula? or all of them...
      # rnames.f <- ejscreenformulas$Rfieldname[!is.na(ejscreenformulas$formula)]
      rnames <- ejscreenformulas$Rfieldname
      RHS <- trimws(gsub('^.*<-', '', myform)) 
      RHS <- all.names(parse(text = RHS)) # result is a vector of variables and operators
      vars <- RHS[RHS %in% rnames]
      return(vars)
    }
    RHS <- unique(getRHS(x))
    
    vector.of.formulas <- ejformula(RHS, decreasing = decreasing, dropNA = dropNA, recursive = recursive)
    vector.of.formulas <- unique(vector.of.formulas)
    vector.of.formulas <- vector.of.formulas[sapply(vector.of.formulas, length) > 0]
    x <- c(x, vector.of.formulas)
  }
  
  if (dropNA) {x <- x[!is.na(x)]}
  x <- unique(x)
  
  if (is.na(decreasing)) {
    return(x)
  } else {
    return(sort(x, decreasing = decreasing))
  }
}
