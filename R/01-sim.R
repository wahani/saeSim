#' Start simulation
#' 
#' This function can be applied to a \code{sim_setup} object or \code{sim_base}. It will start the simulation. Use the printing method as long as you are testing the scenario.
#' 
#' @param x a \code{sim_setup} or \code{sim_base} constructed with \code{sim_setup()} or \code{sim_base_standard()}
#' @param ... simulation components; any composition of \code{\link{sim_gen}}, \code{\link{sim_calc}}, \code{\link{sim_sample}}, \code{\link{sim_agg}}.
#' @inheritParams sim_setup
#' 
#' @return If \code{x} is a \code{sim_base} object constructed for example with \code{\link{sim_base_standard}} the return value is a the result of one simulation run and of class \code{data.frame}. If \code{x} has class \code{sim_setup} the return value is always a list. The elements are the resulting \code{data.frame}s of each simulation run.
#' 
#' @rdname sim
#' @export
#' @examples
#' setup <- sim_lm()
#' resultList <- sim(setup, R = 1)
#' 
#' # Will return a data frame
#' dat <- sim(sim_base_standard(), sim_gen_fe(), sim_gen_e())
setGeneric("sim", function(x, ...) standardGeneric("sim"))

#' @rdname sim
#' @export
setMethod("sim", c(x = "sim_base"),
          function(x, ...) {
            # Preparing:
            setup <- sim_setup(x, ..., R = 1, simName = "")
            
            # Generating pop
            results <- lapply(setup[is.sim_gen_virtual(setup) | is.sim_genData(setup)], sim)
            out <- S3Part(Reduce(add, results), TRUE)
                        
            # Calculating stuff:
            for (smstp_calc in setup[is.sim_cpopulation(setup)])
              out <- sim(smstp_calc, out)
            
            # Drawing sample:
            for (smstp_sample in setup[is.sim_sample(setup)])
              out <- sim(smstp_sample, out)
            
            # Calculating stuff:
            for (smstp_calc in setup[is.sim_csample(setup)])
              out <- sim(smstp_calc, out)
            
            # Aggregating:
            for (smstp_agg in setup[is.sim_agg(setup)])
              out <- sim(smstp_agg, out)
            
            # Calculating stuff:
            for (smstp_calc in setup[is.sim_cagg(setup)])
              out <- sim(smstp_calc, out)
            
            # Return:
            out
          })

#' Sim-methods
#' 
#' These methods are documented because I have to (and of course want to) fulfill the conventions documented in 'Writing R documentation files' in the 'Writing R Extensions' manual. You don't need them, they are only used internally.
#' @param dat data.frame
#' @inheritParams sim
#' @rdname sim-methods
setMethod("sim", c(x = "sim_agg"),
          function(x, dat, ...) {
            x@fun(dat)
          })

#' @rdname sim-methods
setMethod("sim", c(x = "sim_calc_virtual"),
          function(x, dat, ...) {
            x@fun(dat)
          })

#' @rdname sim-methods
setMethod("sim", c(x = "sim_sample"),
          function(x, dat, ...) {
            dat[x@fun(x@nDomains, x@nUnits), ]
          })

#' @rdname sim
#' @export
setMethod("sim", c(x = "sim_setup"),
          function(x, ..., R = NULL) {
            lapply(as.list(1:if(is.null(R)) x@R else R), 
                   function(i) {
                     df <- sim(x@base, S3Part(x, TRUE))
                     df$idR <- i
                     df$simName <- x@simName
                     df
                   })
          })

#' @rdname sim-methods
setMethod("sim", signature=c(x = "sim_gen_virtual"),
          function(x, ...) {
            dat <- x@fun(x@nDomains, x@nUnits, x@name)
            dat$y <- x@const + x@slope * dat[[x@name]]
            new("sim_rs", dat)
          })

#' @rdname sim-methods
setMethod("sim", signature=c(x = "sim_genCont_virtual"),
          function(x, ...) {
            dat <- x@fun(x@nDomains, x@nUnits, x@name)
            nCont <- if(length(x@nCont) > 1) as.list(as.integer(x@nCont)) else 
              if(x@nCont >= 1) as.integer(x@nCont) else x@nCont 
            dat <- select_cont(dat, nCont, x@level, x@fixed)
            dat$y <- x@const + x@slope * dat[[x@name]]
            new("sim_rs_c", dat)
          })

#' @rdname sim-methods
setMethod("sim", signature=c(x = "sim_genData"),
          function(x, ...) {
            dat <- make_id(x@nDomains, x@nUnits)
            new("sim_rs", cbind(dat, x@fun()))
          })