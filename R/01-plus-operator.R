#' Appand/Combine/Add simulation components to a set-up
#' 
#' Use this binary operator to add new simulation components to an existing set-up. The different methods are used internally and you don't have to care what they'll do, just add things up...
#' 
#' @param e1 object on the left side.
#' @param e2 object on the right side.
#' 
#' @details Adding up two simulation setups is possible. What ever options on the right side are set, they will override anything on the left (\code{R} and \code{simName} for example). Simulation components are just added to the set-up. You can add as much as you want of any component.
#' @export
#' @rdname plus-operator
#' @examples 
#' setup <- sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e() %+% sim_gen_re()
#' setup <- setup %+% sim_gen_rec() %+% sim_gen_ec()
#' anotherSetup <- sim_setup(sim_base_standard(), R = 5)
#' yesAnotherOne <- setup %+% anotherSetup
setGeneric("%+%") #, function(e1, e2) standardGeneric("%+%"))

#' @export
#' @rdname plus-operator
setMethod("%+%", signature(e1 = "sim_setup", e2 = "sim_setup"), 
          function(e1, e2) {
            S3Part(e2) <- c(S3Part(e2, TRUE), S3Part(e1, TRUE))
            e2
          })

#' @export
#' @rdname plus-operator
setMethod("%+%", signature(e1 = "sim_setup", e2 = "sim_virtual"), 
          function(e1, e2) {
            S3Part(e1) <- c(S3Part(e1, TRUE), list(e2))
            e1
          })

#' @export
#' @rdname plus-operator
setMethod("%+%", signature(e1 = "sim_base", e2 = "sim_virtual"), 
          function(e1, e2) {
            sim_setup(e1, e2)
          })