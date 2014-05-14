#' Add new variables
#' 
#' These functions can be used for adding new variables to the data.
#' 
#' @param calcFun a function used for calculation
#' @param level character given the level on which the variable is to be calculated. One in \code{c("population", "sample", "agg")}
#' 
#' @seealso \code{\link{calc_var}}
#' @export
#' @rdname sim_calc
#' @examples
#' # Standard behavior
#' sim_base_standard() %+% sim_gen_fe() %+% sim_calc()
#' 
#' # Custom data modifications
#' ## Add predicted values of a linear model
#' library(saeSim)
#'
#' calc_lm <- function(dat) {
#'   dat$linearPredictor <- predict(lm(y ~ x, data = dat))
#'   dat
#' }
#'
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e() %+% sim_calc(calc_lm)
sim_calc <- function(calcFun = calc_var(), level = "population") {
  if(!(level %in% c("population", "sample", "agg"))) 
    stop("This level is not supported, check spelling.")
  new(paste("sim_c", level, sep = ""), fun = calcFun)
}

#' @export
#' @rdname sim_calc
sim_n <- function() {
  sim_calc(calc_var("y", funList=list(length), newName="n"), level="sample")
}

#' @export
#' @rdname sim_calc
sim_N <- function() {
  sim_calc(calc_var("y", funList=list(length), newName="N"), level="population")
}

#' @export
#' @rdname sim_calc
sim_popMean <- function(exclude = NULL) {
  sim_calc(calc_var("y", funList=list(mean), exclude, newName="popMean"), level="population")
}

#' @export
#' @rdname sim_calc
sim_popVar <- function(exclude = NULL) {
  sim_calc(calc_var("y", funList=list(var), exclude, newName = "popVar"), level="population")
}
