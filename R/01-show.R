#' Show for \code{sim_setup}
#' 
#' This is the documentation for the show methods in the package \code{saeSim}. In case you don't know, \code{show } is for S4-classes like \code{print} for S3. If you don't know what that means, don't bother, there is no reason to call \code{show} directly, however there is the need to document it.
#' 
#' @inheritParams methods::show
#' 
#' @details Will print the head of a \code{sim_setup} to the console, after converting it to a \code{data.frame}.
#' @export
setMethod("show", "sim_setup",
          function(object) {
            dat <- as.data.frame(object)
            print(head(dat))
            invisible(dat)
          })
