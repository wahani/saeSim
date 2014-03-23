#' Calculater Function
#' 
#' These functions are used to add new variables to the data.
#' 
#' @param varName a chracter giving the name of the variable in the data, on which a function is applied. If named, the name will be used for the new variable. If not, the varName and funNames will be used
#' @param funNames character vector of function names (searched for with \code{\link{match.fun}}) to be applied on \code{varName}
#' @param exclude charcter vector of variable names in the data used to exclude observations from the calculation or \code{NULL}. The variables must be \code{logical}, \code{TRUE}s will be excluded.
#' 
#' @details
#' This function is supposed to be used with \code{\link{sim_calc}}
#' 
#' @seealso \code{\link{sim_calc}}
#' @export
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
