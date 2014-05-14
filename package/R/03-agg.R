#' Aggregate function
#' 
#' This is one implementation for aggregating data in a simulation set-up. It is designed to be used as argument to \code{\link{sim_agg}}. See the examples there.
#' 
#' @param splitVars variable names as character to split the data
#' 
#' @details This function follows the split-apply-combine idiom. I.e. each data set is split by the defined variables. Then the variables within each subset are aggregated (reduced to one row). Logical variables are reduced by \code{\link{any}}; for characters and factors the most frequent value is taken; and for numerics the mean (removing NAs).
#' 
#' @seealso \code{\link{sim_agg}}
#' @export
agg_standard <- function(splitVars = "idD") {
  function(dat) {
    # Delete vars:
    dat <- dat[!(names(dat) %in% c("idU"))]
    # split:
    datList <- split(dat, as.list(dat[splitVars]))
    # apply:
    datList <- lapply(datList, 
           function(df) {
             dfOut <- df[1,]
             # logicals
             dfOut[sapply(df, is.logical)] <- lapply(df[sapply(df, is.logical)], any)
             # character
             dfOut[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], 
                                                       function(char) names(sort(table(char), decreasing=TRUE)[1]))
             # factors
             dfOut[sapply(df, is.factor)] <- lapply(df[sapply(df, is.factor)], 
                                                    function(fac) factor(names(sort(table(fac), decreasing=TRUE)[1])))
             # numeric
             dfOut[sapply(df, is.numeric)] <- lapply(df[sapply(df, is.numeric)], mean, na.rm = TRUE)
             
             dfOut
           })
    # combine:
    rbind_all(datList)
  }
} 