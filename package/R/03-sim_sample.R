#' Sampling component
#' 
#' This component can be used to add a sampling mechanism to the simulation set-up. A sample will be drawn after the population is generated (\code{\link{sim_gen}}) and variables on the population are computed (\code{\link{sim_calc}})
#' 
#' @param smplFun function which controls the sampling process. \code{\link{sample_csrs}} is the default
#' 
#' @seealso \code{\link{sample_srs}}, \code{\link{sample_csrs}}, \code{\link{sample_sampleWrapper}}
#' 
#' @export
#' @examples
#' # Simple random sample - 5% sample:
#' sim_lm() %+% sim_sample(sample_srs())
#' 
#' # Simple random sampling proportional to size - 5% in each domain:
#' sim_lm() %+% sim_sample(sample_csrs())
#' 
sim_sample <- function(smplFun = sample_csrs(size=5L)) {
  new("sim_sample", fun = smplFun)
}