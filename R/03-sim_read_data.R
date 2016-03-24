#' Read in simulated data
#' 
#' Use this function after saving the results of a simulation in a directory.
#' 
#' @param path path to the files you want to read in.
#' @param ... arguments passed to \code{\link{read.csv}}
#' @param returnList if \code{TRUE} a list containing the data.frames. Very much like the output of sim. If \code{FALSE} a single data.frame is returned, using \code{\link[dplyr]{rbind_all}}
#' 
#' @export
sim_read_data <- function(path, ..., returnList = FALSE) {
  filesToLoad <- dir(path = path, pattern = "*.csv$", full.names = TRUE)
  dataList <- lapply_remove_null(filesToLoad, file_reader, ...)
  if (returnList) dataList else dplyr::bind_rows(dataList)
}

file_reader <- function(file, ...) {
  # Sometimes strange files may be in a folder - for example they are empty
  out <- try({
    read.csv(file = file, ...)
  })
  if (inherits(out, "try-error")) NULL else out
}

lapply_remove_null <- function(l, f, ...) {
  outList <- lapply(l, f, ...)
  outList[sapply(outList, is.null)]
}