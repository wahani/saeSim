#' Constructor for sim_setup
#' 
#' @description This function is used to construct a new simulation set-up. There are several ways to work with it. Please see the examples and documentation.
#' 
#' @param base a object constructed by the \code{sim_base_*} family or a \code{sim_setup} object, constructed with \code{\link{sim_setup}}.
#' @param ... simulation components, like \code{\link{sim_gen}}, \code{\link{sim_calc}}, \code{\link{sim_sample}}, \code{\link{sim_agg}}
#' @param R the number of desired repetitions in the simulation.
#' @param simName the name of the simulation. It is simply added as character variable to the data.
#' 
#' @return An objects of class \code{sim_setup}. There is really no need to access an object of class \code{sim_setup}. You can interact with it using the \code{show}, \code{plot}, \code{autoplot} and of course \code{sim} method.
#' 
#' @seealso \code{\link{sim}}, \code{\link{sim_base_standard}}, \code{\link{show}}, \code{\link{plot}}, \code{\link{autoplot}}
#' @export
#' @rdname sim_setup
#' 
#' @examples
#' # Define a set-up
#' setup <- sim_setup(sim_base_standard(), sim_gen_fe(), sim_gen_e())  
#' # Show:
#' setup
#' 
#' \dontrun{
#' # plot:
#' plot(setup)
#' plot(setup %+% sim_gen_ec() %+% sim_agg())
#' # autoplot for the ggplot2 user:
#' autoplot(setup)
#' autoplot(setup %+% sim_gen_ec())
#' 
#' # Start a simulation:
#' resultList <- sim(setup)
#' }
setGeneric("sim_setup", function(base, ...) standardGeneric("sim_setup"))

#' @rdname sim_setup
#' @export
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
#' @export
setMethod("sim_setup", c(base = "sim_setup"),
          function(base, ...) {
            smstp_objects <- c(list(...), S3Part(base, strictS3=TRUE))
            new("sim_setup", base = base@base, 
                R = base@R, simName = base@simName, smstp_objects)
          })

