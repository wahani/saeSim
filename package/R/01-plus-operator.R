#' @importFrom ggplot2 "%+%"
#' @export
setGeneric("%+%") #, function(e1, e2) standardGeneric("%+%"))

#' @export
setMethod("%+%", signature(e1 = "sim_setup", e2 = "sim_setup"), 
          function(e1, e2) {
            S3Part(e2) <- c(S3Part(e2, TRUE), S3Part(e1, TRUE))
            e2
          })

#' @export
setMethod("%+%", signature(e1 = "sim_setup", e2 = "sim_virtual"), 
          function(e1, e2) {
            S3Part(e1) <- c(S3Part(e1, TRUE), list(e2))
            e1
          })

#' @export
setMethod("%+%", signature(e1 = "sim_base", e2 = "sim_virtual"), 
          function(e1, e2) {
            sim_setup(e1, e2)
          })