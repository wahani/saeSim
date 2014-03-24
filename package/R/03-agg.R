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
             dfOut[sapply(df, is.numeric)] <- lapply(df[sapply(df, is.numeric)], mean)
             
             dfOut
           })
    # combine:
    rbind_all(datList)
  }
} 