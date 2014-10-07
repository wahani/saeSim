#' Preconfigured computation components
#' 
#' \code{sim_comp_n} and \code{sim_comp_N} will add the sample and population size in each domain respectively. \code{sim_comp_popMean} and \code{sim_comp_popVar} the population mean and variance of the variable \code{y}. The data is expected to have a variable \code{idD} identifying domains.
#' 
#' @inheritParams sim_agg
#' 
#' @export
#' @rdname sim_comp_preconf
sim_comp_n <- function(simSetup) {
  sim_comp_sample(simSetup, comp_var(n = nrow(dat)), by = "idD")
}

#' @export
#' @rdname sim_comp_preconf
sim_comp_N <- function(simSetup) {
  sim_comp_pop(simSetup, comp_var(N = nrow(dat)), by = "idD")
}

#' @export
#' @rdname sim_comp_preconf
sim_comp_popMean <- function(simSetup) {
  sim_comp_pop(simSetup, comp_var(popMean = mean(y)), by = "idD")
}

#' @export
#' @rdname sim_comp_preconf
sim_comp_popVar <- function(simSetup) {
  sim_comp_pop(simSetup, comp_var(popVar = var(y)), by = "idD")
}
