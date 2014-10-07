#' Calculation component
#' 
#' One of the components which can be added to a simulation set-up. These functions can be used for adding new variables to the data. \code{sim_calc} is the generic interface to add a calculation component. Everything else are preconfigured components.
#' 
#' @param fun a function, see details.
#' 
#' @inheritParams calc_var
#' 
#' @details Potentially you can define a function for computation yourself. Take care that it only has one argument, named \code{dat}, and returns a \code{data.frame}.
#' 
#' \code{sim_comp_n} and \code{sim_comp_N} will add the sample and population size in each domain respectively. \code{sim_comp_popMean} and \code{sim_comp_popVar} the population mean and variance of the variable \code{y}.
#' 
#' @seealso \code{\link{calc_var}}, \code{\link{sim_gen}}, \code{\link{sim_agg}}, \code{\link{sim_sample}}
#' @export
#' @rdname sim_comp
#' @examples
#' # Standard behavior
#' sim_base() %>% sim_gen_fe() %>% sim_comp_N()
#' 
#' # Custom data modifications
#' ## Add predicted values of a linear model
#' library(saeSim)
#'
#' comp_lm <- function(dat) {
#'   dat$linearPredictor <- predict(lm(y ~ x, data = dat))
#'   dat
#' }
#'
#' sim_base() %>% sim_gen_fe() %>% sim_gen_e() %>% sim_resp(resp_eq(y = 100 + x + e)) %>% sim_comp_pop(comp_lm)
sim_comp_pop <- function(simSetup, fun = calc_var(), by = "") {
  fun <- if(by == "") fun else apply_by(by, fun)
  sim_setup(simSetup, new("sim_fun", order = 4, fun))
}

#' @export
#' @rdname sim_comp
sim_comp_sample <- function(simSetup, fun = calc_var(), by = "") {
  fun <- if(by == "") fun else apply_by(by, fun)
  sim_setup(simSetup, new("sim_fun", order = 6, fun))
}

#' @export
#' @rdname sim_comp
sim_comp_agg <- function(simSetup, fun = calc_var(), by = "") {
  fun <- if(by == "") fun else apply_by(by, fun)
  sim_setup(simSetup, new("sim_fun", order = 8, fun))
}

#' @export
#' @rdname sim_comp
sim_comp_n <- function(simSetup) {
  sim_comp_sample(simSetup, calc_var(n = nrow(dat)), by = "idD")
}

#' @export
#' @rdname sim_comp
sim_comp_N <- function(simSetup) {
  sim_comp_pop(simSetup, calc_var(N = nrow(dat)), by = "idD")
}

#' @export
#' @rdname sim_comp
sim_comp_popMean <- function(simSetup) {
  sim_comp_pop(simSetup, calc_var(popMean = mean(y)), by = "idD")
}

#' @export
#' @rdname sim_comp
sim_comp_popVar <- function(simSetup) {
  sim_comp_pop(simSetup, calc_var(popVar = var(y)))
}
