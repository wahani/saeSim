#' Generation component
#' 
#' One of the components which can be added to a \code{sim_setup}.

#' @inheritParams sim_agg
#' @param generator generator function used to generate random numbers.
#' 
#' @details  
#' Potentially you can define a \code{generator} yourself. Take care that it has one argument, named \code{dat}, and returns a \code{data.frame}.
#' @export
#' @rdname sim_gen
#' @seealso \code{\link{gen_norm}}, \code{\link{gen_v_norm}}, \code{\link{gen_v_sar}}, \code{\link{sim_agg}}, , \code{\link{sim_comp_pop}}, \code{\link{sim_sample}}, \code{\link{sim_gen_x}}, \code{\link{sim_gen_e}}, \code{\link{sim_gen_v}}, \code{\link{sim_gen_vc}}, \code{\link{sim_gen_ec}}
#' @examples
#' # Data setup for a mixed model
#' sim_base() %>% sim_gen_x() %>% sim_gen_v() %>% sim_gen_e()
#' # Adding contamination in the model error
#' sim_base() %>% sim_gen_x() %>% sim_gen_v() %>% sim_gen_e() %>% sim_gen_ec()
#' 
#' # Simple user defined generator:
#' gen_myVar <- function(dat) {
#'   dat["myVar"] <- rnorm(nrow(dat))
#'   dat
#' }
#' 
#' sim_base() %>% sim_gen_x() %>% sim_gen(gen_myVar)
sim_gen <- function(simSetup, generator) {
  sim_setup(simSetup, new("sim_fun", order = 1, generator))
}
