#' @export
setMethod("show", "sim_setup",
          function(object) {
            dat <- sim(object@base, S3Part(object, TRUE))
            print(head(dat))
            invisible(dat)
          })
