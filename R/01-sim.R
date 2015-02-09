#' Start simulation
#' 
#' This function will start the simulation. Use the printing method as long as you are testing the scenario.
#' 
#' @param x a \code{sim_setup}
#' @param R number of repetitions.
#' @param path optional path in which the simulation results can be saved. They will we coerced to a \code{data.frame} and then saved as 'csv'.
#' @param ... arguments passed to \code{\link{parallelStart}}.
#' @param libs arguments passed to \code{\link{parallelLibrary}}. Will be used in a call to \code{\link{do.call}} after coersion with \code{\link{as.list}}.
#' @param exports arguments passed to \code{\link{parallelExport}}. Will be used in a call to \code{\link{do.call}} after coersion with \code{\link{as.list}}.
#' 
#' @details The package parallelMap is utilized as a back-end for parallel computations.
#' 
#' Use the argument \code{path} to store the simulation results in a directory. This may be a good idea for long running simulations and for those using large \code{data.frame}s. You can use \code{\link{sim_read_data}} to read them in. The return value will change to NULL in each run.
#'  
#' @return The return value is a list. The elements are the results of each simulation run, typically of class \code{data.frame}. In case you specified \code{path}, each element is \code{NULL} and the results are stored to disk. 
#' 
#' @rdname sim
#' @export
#' @examples
#' setup <- sim_base_lm()
#' resultList <- sim(setup, R = 1)
#' 
#' # For parallel computations you may need to export object
#' localFun <- function() cat("Hello World!")
#' comp_fun <- function(dat) {
#'   localFun()
#'   dat
#' }
#' 
#' res <- sim_base_lm() %>% 
#'   sim_comp_pop(comp_fun) %>% 
#'   sim(R = 2, 
#'       mode = "socket", cpus = 2,
#'       exports = "localFun")
#' 
#' str(res)
sim <- function(x, R = 1, path = NULL, ..., libs = NULL, exports = NULL) {
  
  mapFun <- function(i, object, path) {
    df <- sim_run_once(object)
    df$idR <- i
    df$simName <- object@simName
    sim_write_results(df, path, paste0(object@simName, i))
  }
  
  parallelStart(...)
  do.call(parallelLibrary, as.list(libs))
  do.call(parallelExport, as.list(exports))
  res <- parallelLapply(1:R, mapFun, object = x, path = path)
  parallelStop()
  res
  
}

sim_write_results <- function(df, path, filename) {
  if (!is.null(path)) {
    df <- as.data.frame(df)
    write.csv(df, file = paste0(path, "/", filename, ".csv"),
              row.names = FALSE)
    NULL
  } else {
    df
  }
}

sim_run_once <- function(x) {
  Reduce(function(x, f) f(x), x, x@base)
}