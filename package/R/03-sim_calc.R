#' Add new variables
#' 
#' These functions can be used for adding new variables to the data.
#' 
#' @param calcFun a function used for calculation, see \code{\link{calc_var}}
#' @param level character given the level on which the variable is to be calculated. One in \code{c("population", "sample")}
#' 
#' @export
#' @rdname sim_calc
#' @examples
#' sim_base_standard() %+% sim_gen_fe() %+% sim_calc()
sim_calc <- function(calcFun = calc_var(), level = "population") {
  if(!(level %in% c("population", "sample", "result"))) 
    stop("This level is not supported, check spelling.")
  new(paste("sim_c", level, sep = ""), fun = calcFun)
}

#' @export
#' @rdname sim_calc
sim_n <- function() {
  sim_calc(calc_var(c(n = "y"), funNames="length"), level="sample")
}

#' @export
#' @rdname sim_calc
sim_N <- function() {
  sim_calc(calc_var(c(N = "y"), funNames="length"), level="population")
}

#' @export
#' @rdname sim_calc
sim_popMean <- function(exclude = NULL) {
  sim_calc(calc_var(c(popMean = "y"), "mean", exclude), level="population")
}

#' @export
#' @rdname sim_calc
sim_popVar <- function(exclude = "idC") {
  sim_calc(calc_var(c(popVar = "y"), "var", exclude), level="population")
}
