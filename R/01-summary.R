#' Summary for a sim_setup
#' 
#' Reports a summary of the simulation setup.
#' 
#' @param object a \code{sim_setup}.
#' @param ... nothing to pass to here.
#' 
#' @export
#' @method summary sim_setup
#' 
#' @examples
#' summary(sim_base_lm())
summary.sim_setup <- function(object, ...) {
  componentList <- S3Part(object, strictS3=TRUE)
  cat("General Information about", object@simName, "simulation set-up:\n")
  #cat("# of runs:", object@R, "\n")
  cat("# of sim_gen:", elementsEqualTo(componentList, 1), "\n")
  cat("# of sim_gen_cont:", elementsEqualTo(componentList, 2), "\n")
  cat("# of sim_resp:", elementsEqualTo(componentList, 3), "\n")
  cat("# of sim_comp_pop:", 
      elementsEqualTo(componentList, 4), "\n")
  cat("# of sim_sample:",
      elementsEqualTo(componentList, 5), "\n")
  cat("# of sim_comp_sample:", 
      elementsEqualTo(componentList, 6), "\n")
  cat("# of sim_agg:",
      elementsEqualTo(componentList, 7), "\n")
  cat("# of sim_comp_agg:", 
      elementsEqualTo(componentList, 8), "\n")
  
  cat("\nApproximating the expected duration:\n")
  cat("A single run takes ... ")
  tmp <- system.time(dat <- as.data.frame(object))
  cat(tmp["elapsed"], "seconds.", 100, "*", tmp["elapsed"], "=", 
      100 * tmp["elapsed"], "seconds.\n")
  
  cat("\nStructure of the data:\n")
  print(str(dat))
  invisible(NULL)
}

elementsEqualTo <- function(simFunList, number) {
  sapply(simFunList, function(obj) obj@order == number) %>% sum
}