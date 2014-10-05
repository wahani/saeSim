#' Generation component
#' 
#' One of the components which can be added to a simulation set-up. \code{sim_gen} is the generic interface to add components for data from some generator. Everything else are preconfigured wrapper functions of \code{sim_gen}. 
#' 
#' @param generator generator function used to generate random numbers.
#' @param name variable name used in the resulting \code{data.frame}.
#' 
#' @details \code{fe}: fixed-effect component; \code{e}: model-error; \code{ec}: contaminated model error; \code{re}: random-effect (error constant for each domain); \code{rec} contaminated random-effect. Note that for contamination you are expected to add both, a non-contaminated component and a contaminated component. They are simply added up in the response \code{y}.
#' 
#' Potentially you can define a \code{generator} yourself. Take care that it has three arguments, named \code{nDomains}, \code{nUnits} and \code{name}, and returns a \code{data.frame} with the variables \code{idD}, \code{idU} and one named with \code{name}. Use \code{make_id} to stay in the correct format.
#' @export
#' @rdname sim_gen
#' @seealso \code{\link{gen_norm}}, \code{\link{gen_v_norm}}, \code{\link{gen_v_sar}}, \code{\link{sim_agg}}, \code{\link{sim_calc}}, \code{\link{sim_sample}}
#' @examples
#' # Data setup for a mixed model
#' sim_base() %>% sim_gen_fe() %>% sim_gen_re() %>% sim_gen_e()
#' # Adding contamination in the model error
#' sim_base() %>% sim_gen_fe() %>% sim_gen_re() %>% sim_gen_e() %>% sim_gen_ec()
#' 
#' # Simple user defined generator:
#' gen_myVar <- function(nDomains, nUnits, name) {
#'   dat <- make_id(nDomains, nUnits)
#'   dat[name] <- rnorm(nrow(dat))
#'   dat
#' }
#' 
#' sim_base() %>% sim_gen_fe() %>% sim_gen_e(gen_myVar)
sim_gen <- function(simSetup, generator) {
  sim_setup(simSetup, new("sim_fun", order = 1, generator))
}

#' @rdname sim_gen
#' @export
sim_gen_fe <- function(simSetup, generator = gen_norm(0, 4, name = "x")) {
  sim_gen(simSetup, generator = generator)
}

#' @rdname sim_gen
#' @export
sim_gen_e <- function(simSetup, generator = gen_norm(0, 4, name = "e")) {
  sim_gen(simSetup, generator = generator)
}

#' @rdname sim_gen
#' @export
sim_gen_ec <- function(simSetup,
                       generator = gen_norm(mean=0, sd=150, name = "e"), 
                       nCont = 0.05, level = "unit", fixed = TRUE) {
  sim_gen_cont(simSetup, generator = generator, nCont = nCont, level = level, fixed = fixed)
}

#' @rdname sim_gen
#' @export
# wrapper:
sim_gen_re <- function(simSetup, generator = gen_v_norm(name = "v")) {
  sim_gen_e(simSetup, generator)
}

#' @rdname sim_gen
#' @export
sim_gen_rec <- function(simSetup,
                        generator = gen_v_norm(mean=0, sd=40, name = "v"), 
                        nCont = 0.05, level = "area", fixed = TRUE) {
  sim_gen_ec(simSetup, generator, nCont, level, fixed)
}
