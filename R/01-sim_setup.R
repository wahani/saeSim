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
#' @seealso \code{\link{sim}}, \code{\link{sim_base}}, \code{\link{show}}, \code{\link{plot}}, \code{\link{autoplot}}
#' @export
#' @rdname sim_setup
#' 
#' @examples
#' # Define a set-up
#' setup <- sim_base() %>% sim_gen_fe() %>% sim_gen_e()
#' # Show:
#' setup
#' 
#' \dontrun{
#' # plot:
#' plot(setup)
#' plot(setup %>% sim_gen_ec() %>% sim_agg())
#' # autoplot for the ggplot2 user:
#' autoplot(setup)
#' autoplot(setup %>% sim_gen_ec())
#' 
#' # Start a simulation:
#' resultList <- sim(setup)
#' }
sim_setup <- function(base, ...) UseMethod("sim_setup")

#' @rdname sim_setup
#' @export
sim_setup.data.frame <- function(base, ..., simName = "") {
  
  dots <- list(...)
  if (length(dots) == 0) {
    return(new("sim_setup", base = base, simName = simName, list()))
  } else {
    # Taking care of the smstp-family:
    if (class(dots[[1]]) == "list") dots <- dots[[1]]
    if (length(dots) == 0) return(new("sim_setup", base = base, simName = simName, list()))
    
    smstp_objects <- dots
        
    smstp_objects <- smstp_objects[c(which(is.sim_gen(smstp_objects)),
                                     which(is.sim_genCont(smstp_objects)),
                                     which(is.sim_resp(smstp_objects)),
                                     which(is.sim_cpopulation(smstp_objects)),
                                     which(is.sim_sample(smstp_objects)),
                                     which(is.sim_csample(smstp_objects)),
                                     which(is.sim_agg(smstp_objects)),
                                     which(is.sim_cagg(smstp_objects)))]
    
    return(new("sim_setup", base = base, simName = simName, smstp_objects))
  }
  
}

#' @rdname sim_setup
#' @export
sim_setup.sim_setup <- function(base, ..., simName = base@simName) {
  smstp_objects <- c(list(...), S3Part(base, strictS3=TRUE))
  sim_setup(base = base@base, simName = simName, smstp_objects)
}
