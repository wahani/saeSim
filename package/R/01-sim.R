#' @export
setGeneric("sim", function(x, ...) standardGeneric("sim"))

#' @export
setMethod("sim", c(x = "sim_base"),
          function(x, ...) {
            # Preparing:
            setup <- sim_setup(x, ..., R = 1, simName = "")
            results <- lapply(setup[is.sim_gen_virtual(setup)], sim)
            
            # Generating pop
            out <- as.data.frame(Reduce(add, results))
            out$y <- rowSums(out[!grepl("id", names(out), ignore.case=FALSE) | grepl(".B$", names(out), ignore.case=FALSE)])
            out <- out[!grepl(".B$", names(out), ignore.case=FALSE)]
            
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

#' @export
setMethod("sim", c(x = "sim_agg"),
          function(x, dat, ...) {
            x@fun(dat)
          })

#' @export
setMethod("sim", c(x = "sim_calc_virtual"),
          function(x, dat, ...) {
            x@fun(dat)
          })

#' @export
setMethod("sim", c(x = "sim_sample"),
          function(x, dat, ...) {
            dat[x@fun(x@nDomains, x@nUnits), ]
          })

#' @export
setMethod("sim", c(x = "sim_setup"),
          function(x, ...) {
            lapply(as.list(1:x@R), 
                   function(i) {
                     df <- sim(x@base, S3Part(x, TRUE))
                     df$idR <- i
                     df$simName <- x@simName
                     df
                   })
          })

#' @export
setMethod("sim", signature=c(x = "sim_gen_virtual"),
          function(x, ...) {
            dat <- x@fun(x@nDomains, x@nUnits, x@name)
            dat$y <- x@const + x@slope * dat[[x@name]]
            new("sim_rs", dat)
          })

#' @export
setMethod("sim", signature=c(x = "sim_genCont_virtual"),
          function(x, ...) {
            out <- x@fun(x@nDomains, x@nUnits, x@name)
            nCont <- if(length(x@nCont) > 1) as.list(as.integer(x@nCont)) else if(x@nCont >= 1) as.integer(x@nCont) else x@nCont 
            out <- select_cont(out, nCont, x@level, x@fixed)
            new("sim_rs_c", out)
          })