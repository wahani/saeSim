#' sim Functions
#' 
#' @rdname sim
#' @export
setGeneric("sim", function(x, ...) standardGeneric("sim"))

#' @rdname sim
#' @export
setMethod("sim", c(x = "sim_base"),
          function(x, ...) {
            # Preparing:
            setup <- sim_setup(x, ..., R = 1, simName = "")
            
            # Generating pop
            results <- lapply(setup[is.sim_gen_virtual(setup)], sim)
            out <- as.data.frame(Reduce(add, results))
                        
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
            
            # Return:
            out
          })

#' @rdname sim
#' @export
setMethod("sim", c(x = "sim_agg"),
          function(x, dat, ...) {
            x@fun(dat)
          })

#' @rdname sim
#' @export
setMethod("sim", c(x = "sim_calc_virtual"),
          function(x, dat, ...) {
            x@fun(dat)
          })

#' @rdname sim
#' @export
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

#' @rdname sim
#' @export
setMethod("sim", signature=c(x = "sim_gen_virtual"),
          function(x, ...) {
            dat <- x@fun(x@nDomains, x@nUnits, x@name)
            dat$y <- x@const + x@slope * dat[[x@name]]
            new("sim_rs", dat)
          })

#' @rdname sim
#' @export
setMethod("sim", signature=c(x = "sim_genCont_virtual"),
          function(x, ...) {
            out <- x@fun(x@nDomains, x@nUnits, x@name)
            nCont <- if(length(x@nCont) > 1) as.list(as.integer(x@nCont)) else if(x@nCont >= 1) as.integer(x@nCont) else x@nCont 
            out <- select_cont(out, nCont, x@level, x@fixed)
            new("sim_rs_c", out)
          })