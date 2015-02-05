#' Start simulation
#' 
#' This function will start the simulation. Use the printing method as long as you are testing the scenario.
#' 
#' @param x a \code{sim_setup}
#' @param ... If \code{parallel = TRUE} arguments passed to mclapply, see details.
#' @param parallel if \code{FALSE} \code{lapply} is used; if \code{TRUE} a 'plug-and-play' version of mclapply is used; see details.
#' @param path optional path in which the simulation results can be saved.
#' @param R number of repetitions.
#' 
#' @details The backend for parallel computation is very experimental. You can find the code and documentation on www.github.com/wahani/parallelTools. In Windows parallelization is build around \code{\link[parallel]{clusterApply}}. If you are not using Windows the function \code{\link[parallel]{mclapply}} is used. See the parameters of \code{mclapply} how to control the parallelization. Parallizing trivial tasks in Windows will result in wasted time. Also working with large data.frames will be inefficient in Windows.

#' Use the \code{path} to store the simulation results to a directory. This may be a good idea for long running simulations and for those using large \code{data.frame}s. Use \code{\link{sim_read_data}}, to read load them again.
#'  
#' @return The return value is always a list. The elements are the resulting \code{data.frame}s of each simulation run.
#' 
#' @rdname sim
#' @export
#' @examples
#' setup <- sim_base_lm()
#' resultList <- sim(setup, R = 1)
sim <- function(x, ...) UseMethod("sim")

#' @rdname sim
#' @export
sim.sim_setup <- function(x, ..., R = 1, parallel = FALSE, path = NULL) {
  iterateOver <- as.list(1:R)
  iterateFun <- if(parallel) {
    setPTOption(packageToLoad = "saeSim")
    mclapply
  } else lapply
  iterateOver %>% iterateFun(function(i, object, path) {
    df <- sim_run_once(object)
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

sim_run_once <- function(x) {
  
  out <- x@base
  
  for (fun in x)
    out <- fun(out)
  
  out
}