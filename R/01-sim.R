#' Start simulation
#' 
#' This function can be applied to a \code{sim_setup} object or \code{sim_base}. It will start the simulation. Use the printing method as long as you are testing the scenario.
#' 
#' @param x a \code{sim_setup} or \code{data.frame}
#' @param ... simulation components; any composition of \code{\link{sim_gen}}, \code{\link{sim_calc}}, \code{\link{sim_sample}}, \code{\link{sim_agg}}. If \code{parallel = TRUE} arguments passed to mclapply, see details
#' @param parallel if \code{FALSE} \code{lapply} is used; if \code{TRUE} a 'plug-and-play' version of mclapply is used; see details.
#' @param path optional path in which the simulation results can be saved. This may be a good idea for long running simulations and for those using large data.frames as return value.
#' @inheritParams sim_setup
#' 
#' @details The backend for parallel computation is very experimental. You can find the code and documentation on www.github.com/wahani/parallelTools. In Windows parallelization is build around \code{\link[parallel]{clusterApply}}. If you are not using Windows the function \code{\link[parallel]{mclapply}} is used. See the parameters of \code{mclapply} how to control the parallelization. Parallizing trivial tasks in Windows will result in wasted time. Also working with large data.frames will be inefficient in Windows.
#' 
#' @return If \code{x} is a \code{sim_base} object constructed for example with \code{\link{sim_base}} the return value is a the result of one simulation run and of class \code{data.frame}. If \code{x} has class \code{sim_setup} the return value is always a list. The elements are the resulting \code{data.frame}s of each simulation run.
#' 
#' @rdname sim
#' @export
#' @examples
#' setup <- sim_lm()
#' resultList <- sim(setup, R = 1)
#' 
#' # Will return a data frame
#' dat <- sim(sim_base() %>% sim_gen_fe() %>% sim_gen_e())
sim <- function(x, ...) UseMethod("sim")

#' @rdname sim
#' @export
sim.data.frame <- function(x, ...) {
  
  # Preparing:
  setup <- sim_setup(x, ...)
  
  # Generating pop
  out <- setup@base
  
  for (fun in setup)
    out <- fun(out)
    
  # Return:
  out
}

#' @rdname sim
#' @export
sim.sim_setup <- function(x, ..., R = 1, parallel = FALSE, path = NULL) {
  iterateOver <- as.list(1:R)
  iterateFun <- if(parallel) {
    setPTOption(packageToLoad = "saeSim")
    mclapply
  } else lapply
  iterateOver %>% iterateFun(function(i, object, path) {
    df <- as.data.frame(object)
    df$idR <- i
    df$simName <- object@simName
    # Save results to disk
    if(!is.null(path)) {
      write.csv(df, file = paste(path, object@simName, i, ".csv", sep = ""),
                row.names = FALSE)
      df <- NULL
    }
    df
  }, object = x, path = path, ...)
}
