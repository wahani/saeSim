#' Calculation component
#' 
#' One of the components which can be added to a simulation set-up. These functions can be used for adding new variables to the data. \code{sim_calc} is the generic interface to add a calculation component. Everything else are preconfigured components.
#' 
#' @param calcFun a function used for calculation.
#' @param level character giving the level on which the variable is to be calculated. One in \code{c("population", "sample", "agg")}.
#' @inheritParams calc_var
#' 
#' @details Potentially you can define a \code{calcFun} yourself. Take care that it only has one argument, named \code{dat}, and returns the aggregated data as \code{data.frame}.
#' 
#' \code{sim_n} and \code{sim_N} will add the sample and population size in each domain respectively. \code{sim_popMean} and \code{sim_popVar} the population mean and variance of the variable \code{y}.
#' 
#' @seealso \code{\link{calc_var}}, \code{\link{sim_gen}}, \code{\link{sim_agg}}, \code{\link{sim_sample}}
#' @export
#' @rdname sim_calc
#' @examples
#' # Standard behavior
#' sim_base() %>% sim_gen_fe() %>% sim_calc()
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
#' sim_base() %>% sim_gen_fe() %>% sim_gen_e() %>% sim_calc(calc_lm)
sim_calc <- function(simSetup, calcFun = calc_var(), level = "population") {
  if(!(level %in% c("population", "sample", "agg"))) 
    stop("This level is not supported, check spelling.")
  sim_setup(simSetup, new(paste("sim_c", level, sep = ""), fun = calcFun))
}

#' @export
#' @rdname sim_calc
sim_n <- function(simSetup) {
  sim_calc(simSetup, calc_var("y", funList=list(length), newName="n"), level="sample")
}

#' @export
#' @rdname sim_calc
sim_N <- function(simSetup) {
  sim_calc(simSetup, calc_var("y", funList=list(length), newName="N"), level="population")
}

#' @export
#' @rdname sim_calc
sim_popMean <- function(simSetup, exclude = NULL) {
  sim_calc(simSetup, calc_var("y", funList=list(mean), exclude, newName="popMean"), level="population")
}

#' @export
#' @rdname sim_calc
sim_popVar <- function(simSetup, exclude = NULL) {
  sim_calc(simSetup, calc_var("y", funList=list(var), exclude, newName = "popVar"), level="population")
}
