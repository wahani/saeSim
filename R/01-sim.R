#' Start simulation
#' 
#' This function can be applied to a \code{sim_setup} object or \code{sim_base}. It will start the simulation. Use the printing method as long as you are testing the scenario.
#' 
#' @param x a \code{sim_setup} or \code{sim_base} constructed with \code{sim_setup()} or \code{sim_base_standard()}
#' @param ... simulation components; any composition of \code{\link{sim_gen}}, \code{\link{sim_calc}}, \code{\link{sim_sample}}, \code{\link{sim_agg}}. If \code{parallel = TRUE} arguments passed to mclapply, see details
#' @param parallel if \code{FALSE} \code{lapply} is used; if \code{TRUE} a 'plug-and-play' version of mclapply is used; see details.
#' @param path optional path in which the simulation results can be saved. This may be a good idea for long running simulations and for those using large data.frames as return value.
#' @inheritParams sim_setup
#' 
#' @details The backend for parallel computation is very experimental. You can find the code and documentation on www.github.com/wahani/parallelTools. In Windows parallelization is build around \code{\link[parallel]{clusterApply}}. If you are not using Windows the function \code{\link[parallel]{mclapply}} is used. See the parameters of \code{mclapply} how to control the parallelization. Parallizing trivial tasks in Windows will result in wasted time. Also working with large data.frames will be inefficient in Windows.
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
            x@fun(dat)
          })

#' @rdname sim
#' @export
setMethod("sim", c(x = "sim_setup"),
          function(x, ..., R = NULL, simName = NULL, parallel = FALSE, path = NULL) {
            iterateOver <- as.list(1:if(is.null(R)) x@R else R)
            iterateFun <- if(parallel) {
              setPTOption(packageToLoad = "saeSim")
              mclapply
              } else lapply
            iterateOver %>% iterateFun(function(i, object, path, simName) {
              df <- as.data.frame(object)
              df$idR <- i
              df$simName <- if(is.null(simName)) object@simName else simName
              # Save results to disk
              if(!is.null(path)) {
                write.csv(df, file = paste(path, object@simName, i, ".csv", sep = ""),
                          row.names = FALSE)
                df <- NULL
                gc()
              }
              df
            }, object = x, path = path, simName = simName, ...)
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