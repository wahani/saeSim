#' Summary for a sim_setup
#' 
#' Reports a summary of the simulation setup.
#' 
#' @param object a simulation setup constructed with \code{\link{sim_setup}}.
#' @param ... nothing to pass to here.
#' 
#' @export
#' @method summary sim_setup
#' 
#' @examples
#' summary(sim_lm())
summary.sim_setup <- function(object, ...) {
  componentList <- S3Part(object, strictS3=TRUE)
  cat("General Information about", object@simName, "simulation set-up:\n")
  #cat("# of runs:", object@R, "\n")
  cat("# of sim_gen:", 
      sum(is.sim_gen_virtual(componentList) | is.sim_genData(componentList)),
      "\n")
  cat("# of sim_calc (population):", 
      sum(is.sim_cpopulation(componentList)), "\n")
  cat("# of sim_sample:",
      sum(is.sim_sample(componentList)), "\n")
  cat("# of sim_calc (sample):", 
      sum(is.sim_csample(componentList)), "\n")
  cat("# of sim_agg:",
      sum(is.sim_agg(componentList)), "\n")
  cat("# of sim_calc (aggregate):", 
      sum(is.sim_cagg(componentList)), "\n")
  
  cat("\nApproximating the expected duration:\n")
  cat("A single run takes ... ")
  tmp <- system.time(dat <- as.data.frame(object))
  cat(tmp["elapsed"], "seconds.", 100, "*", tmp["elapsed"], "=", 
      100 * tmp["elapsed"], "seconds.\n")
  
  cat("\nStructure of the data:\n")
  print(str(dat))
  invisible(NULL)
}