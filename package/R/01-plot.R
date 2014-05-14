#' @importFrom graphics plot
setGeneric("plot")

#' @export
setMethod("plot", c(x = "sim_setup", y = "character"),
          function(x, y, xlab = y, ylab = "y", ...) {
            dat <- sim(x@base, S3Part(x, TRUE))
            smoothScatter(y=dat$y, x = dat[[y]], xlab = xlab, ylab = ylab, ...)
          })

#' @export
setMethod("plot", c(x = "sim_setup", y = "missing"),
          function(x, y, ...) {
            dat <- sim(x@base, S3Part(x, TRUE))
            y <- names(dat)[!grepl("id|y", names(dat))][1]
            smoothScatter(y=dat$y, x = dat[[y]], xlab = y, ylab = "y", ...)
          })