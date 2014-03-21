calc_var <- function(varName = c(y = "y"), funNames = c("mean", "var"), exclude = NULL) {
  function(dat) {
    # split
    dataList <- split(dat, dat$idD)
    # apply
    dataList <- lapply(dataList, 
                       function(df) {
                         for (fname in funNames) {
                           fun <- match.fun(fname)
                           nn <- if(is.null(names(varName))) paste(varName, fname, sep = "") else if(length(funNames) == 1) names(varName) else paste(names(varName), fname, sep = "")
                           df[nn] <- 
                             fun(df[if(is.null(exclude)) TRUE else !Reduce("|", df[exclude]), varName])  
                         }
                         df
                       })
    # combine
    rbind_all(dataList)
  }
}
