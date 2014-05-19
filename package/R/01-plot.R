#' Plotting methods
#' 
#' Use this function to produce plots for an object of class \code{sim_setup}. At this time they are wrapper functions around \code{\link{smoothScatter}}.
#' 
#' @param x a \code{sim_setup}
#' @param y can be a variable name as character or missing.
#' @param xlab a title for the x axis
#' @param ylab a title for the y axis
#' @param ... Arguments to be passed to \code{\link{smoothScatter}}.
#' 
#' @export
#' @rdname plot
#' @seealso \code{\link[saeSim]{autoplot}}, \code{\link{autoplot}}
#' @importFrom graphics plot
setGeneric("plot")

#' @export
#' @rdname plot
setMethod("plot", c(x = "sim_setup", y = "character"),
          function(x, y, xlab = y, ylab = "y", ...) {
            dat <- sim(x@base, S3Part(x, TRUE))
            smoothScatter(y=dat$y, x = dat[[y]], xlab = xlab, ylab = ylab, ...)
          })

#' @export
#' @rdname plot
setMethod("plot", c(x = "sim_setup", y = "missing"),
          function(x, y, ...) {
            dat <- sim(x@base, S3Part(x, TRUE))
            y <- names(dat)[!grepl("id|y", names(dat))][1]
            smoothScatter(y=dat$y, x = dat[[y]], xlab = y, ylab = "y", ...)
          })