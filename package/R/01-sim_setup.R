#' Construct a simulation set-up
#' 
#' @description This function is used to construct a new simulation set-up. There are several ways to work with it. Please see the examples and documentation.
#' 
#' @param base a object constructed by the \code{sim_base_*} family
#' @param ... arguments passed to methods
#' 
#' @return An objects of class \code{sim_setup}. Should be used in conjunction with methods for this class.
#' 
#' @export
#' @rdname sim_setup
setGeneric("sim_setup", function(base, ...) standardGeneric("sim_setup"))

#' @param R the number of desired repetitions in the simulation
#' @param simName the name of the simulation. It is simply added as character to the data
#' @rdname sim_setup
setMethod("sim_setup", c(base = "sim_base"),
          function(base, ..., R = 500, simName = "test") {
            
            dots <- list(...)
            if (length(dots) == 0) {
              return(new("sim_setup", base = base, R = R, 
                         simName = simName, list()))
            } else {
              # Taking care of the smstp-family:
              if (class(dots[[1]]) == "list") dots <- dots[[1]]
              
              smstp_objects <- dots
              smstp_objects[is.sim_id_virtual(dots)] <- 
                lapply(dots[is.sim_id_virtual(dots)], function(x) {
                  x@nDomains <- base$nDomains
                  x@nUnits <- base$nUnits
                  x
                })
              
              # Putting everything in a list:
              return(new("sim_setup", base = base, R = R, 
                         simName = simName, smstp_objects))
            }
            
          })

#' @rdname sim_setup
setMethod("sim_setup", c(base = "sim_setup"),
          function(base, ...) {
            smstp_objects <- c(list(...), S3Part(base, strictS3=TRUE))
            new("sim_setup", base = base@base, 
                R = base@R, simName = base@simName, smstp_objects)
          })