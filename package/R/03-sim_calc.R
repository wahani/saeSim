#' Add new variables
#' 
#' These functions can be used for adding new variables to the data.
#' 
#' @param calcFun a function used for calculation, see \code{\link{calc_var}}
#' @param level character given the level on which the variable is to be calculated. One in \code{c("population", "sample")}
#' 
#' @examples
#' sim_base_standard() %+% sim_gen_fe() %+% sim_calc()
sim_calc <- function(calcFun = calc_var(), level = "population") {
  if(!(level %in% c("population", "sample", "result"))) stop("This level is not supported, check spelling.")
  new(paste("smstp_c", level, sep = ""), calcFun = calcFun)
}