#' Sampling component
#' 
#' One of the components which can be added to a simulation set-up. This component can be used to add a sampling mechanism to the simulation set-up. A sample will be drawn after the population is generated (\code{\link{sim_gen}}) and variables on the population are computed (\code{\link{sim_calc}}).
#' 
#' @param smplFun function which controls the sampling process. \code{\link{sample_csrs}} is the default.
#' 
#' @details Potentially you can define a \code{smplFun} yourself. Take care that it has one argument, named \code{dat} being the data as data.frame, and returns the sample as data.frame.
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_csrs}}, \code{\link{sample_sampleWrapper}}
#' 
#' @export
#' @examples
#' # Simple random sample - 5% sample:
#' sim_lm() %>% sim_sample(sample_srs())
#' 
#' # Simple random sampling proportional to size - 5% in each domain:
#' sim_lm() %>% sim_sample(sample_csrs())
#' 
#' # User defined sampling function:
#' sample_mySampleFun <- function(dat) {
#'   dat[sample.int(nrow(dat), 10), ]
#' }
#' 
#' sim_lm() %>% sim_sample(sample_mySampleFun)
sim_sample <- function(simSetup, smplFun = sample_csrs(size=5L)) {
  sim_setup(simSetup, new("sim_sample", fun = smplFun))
}