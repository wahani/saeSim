#' Show for \code{sim_setup}
#' 
#' This is the documentation for the show methods in the package \code{saeSim}. In case you don't know, \code{show } is for S4-classes like \code{print} for S3. If you don't know what that means, don't bother, there is no reason to call \code{show} directly, however there is the need to document it.
#' 
#' @inheritParams methods::show
#' @export
setMethod("show", "sim_setup",
          function(object) {
            dat <- sim(object@base, S3Part(object, TRUE))
            print(head(dat))
            invisible(dat)
          })
