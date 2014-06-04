#' Read in simulated data
#' 
#' Use this function after saving the results of a simulation in a path.
#' 
#' @param path path to the files you want to read in.
#' @param ... arguments passed to \code{\link{read.csv}}
#' @param returnList if \code{TRUE} a list containing the data.frames. Very much like the output of sim. If \code{FALSE} a single data.frame is returned.
#' 
#' @export
read_simData <- function (path, ..., returnList = FALSE) {
  filesToLoad <- dir(path = path, full.names = TRUE)
  dataList <- lapply(filesToLoad, read.csv, ...)
  if (returnList) dataList else rbind_all(dataList)
}