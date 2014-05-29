#' Calculator function
#' 
#' This function is intended to be used with \code{\link{sim_calc}} and not interactively. It can be used to calculate statistics for gouping variables in the data.
#' 
#' @param varName character giving the name of the variable in the data, on which a function is applied. 
#' @param funList list of functions to be applied on \code{varName}. Can be named, see \code{newName}.
#' @param exclude charcter vector of variable names in the data used to exclude observations from the calculation or \code{NULL}. The variables must be \code{logical}, \code{TRUE}s will be excluded.
#' @param by variable names as character to split the data. Computed values will be constant within each group.
#' @param newName name of the new variable(s). If \code{length(funList) > 1} it can be a vector. If equal to \code{varName} the name will be pasted with the function name (if the list is named) or appended by an increasing sequence of integer
#' 
#' @seealso \code{\link{sim_calc}}
#' @export
#' 
#' @examples
#' sim_base_standard() %&% sim_gen_fe() %&% sim_gen_e() %&% sim_calc(calc_var())
calc_var <- function(varName = "y", funList = list("mean" = mean, "var" = var), exclude = NULL, 
                     by = "idD", newName = varName) {
  function(dat) {
    if(is.null(names(funList))) names(funList) <- as.character(seq_along(funList))
    # split
    dataList <- split(dat, as.list(dat[by]))
    # apply
    dataList <- lapply(dataList, 
                       function(df) {
                         for (i in seq_along(funList)) {
                           fun <- funList[[i]]
                           fname <- names(funList)[i]
                           
                           nn <- if(length(funList) == 1) {
                             if(newName[1] %in% names(df)) {
                               paste(newName[1], capwords(fname), sep = "")
                             } else {
                               newName[1]
                             }
                           } else if(length(funList) == length(newName)) {
                             newName[i]
                           } else {
                             paste(newName[1], capwords(fname), sep = "") 
                           } 
                           
                           df[nn] <- 
                             fun(df[if(is.null(exclude)) TRUE else 
                               !Reduce("|", df[exclude]), varName])  
                         }
                         df
                       })
    # combine
    rbind_all(dataList)
  }
}
