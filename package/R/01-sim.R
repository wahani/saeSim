setGeneric("sim", function(x, ...) standardGeneric("sim"))

setMethod("sim", c(x = "sim_base"),
          function(x, ..., idC = TRUE) {
            # Preparing:
            setup <- sim_setup(x, ..., R = 1, simName = "", idC = idC)
            results <- lapply(setup[is.smstp_(setup)], sim)
            
            # Generating pop
            out <- as.data.frame(Reduce(add, results))
            out$y <- rowSums(out[!grepl("id", names(out), ignore.case=FALSE) | grepl(".B$", names(out), ignore.case=FALSE)])
            out <- out[!grepl(".B$", names(out), ignore.case=FALSE)]
            # Features:
            if(idC) {
              out$idC <- Reduce("|", out[grepl("idC", names(out))])
              out <- out[!grepl("idC.", names(out))]
            }
            
            # Calculating stuff:
            for (smstp_calc in setup[is.smstp_cpopulation(setup)])
              out <- sim(smstp_calc, out)
            
            # Drawing sample:
            for (smstp_sample in setup[is.smstp_sample(setup)])
              out <- sim(smstp_sample, out)
            
            # Calculating stuff:
            for (smstp_calc in setup[is.smstp_csample(setup)])
              out <- sim(smstp_calc, out)
            
            # Aggregating:
            for (smstp_agg in setup[is.smstp_agg(setup)])
              out <- sim(smstp_agg, out)
            
            # Return:
            out
          })

setMethod("sim", c(x = "smstp_agg"),
          function(x, dat, ...) {
            x@aggFun(dat)
          })

setMethod("sim", c(x = "smstp_calc"),
          function(x, dat, ...) {
            x@calcFun(dat)
          })

setMethod("sim", c(x = "smstp_sample"),
          function(x, dat, ...) {
            dat[x@smplFun(x@nDomains, x@nUnits), ]
          })

setMethod("sim", c(x = "sim_setup"),
          function(x, ...) {
            lapply(as.list(1:x@R), 
                   function(i) {
                     df <- sim(x@base, S3Part(x, TRUE), idC = x@idC)
                     df$idR <- i
                     df$simName <- x@simName
                     df
                   })
          })

setMethod("sim", signature=c(x = "smstp_fe"),
          function(x, ...) {
            dat <- x@generator(x@nDomains, x@nUnits, x@name)
            dat[paste(x@name, "B", sep = "")] <- x@const + x@slope * dat[[x@name]]
            new("sim_rs_fe", dat)
          })

setMethod("sim", signature=c(x = "smstp_"),
          function(x, ...) {
            new("sim_rs", x@generator(x@nDomains, x@nUnits, x@name))
          })

setMethod("sim", signature=c(x = "smstp_c"),
          function(x, ...) {
            out <- x@generator(x@nDomains, x@nUnits, x@name)
            nCont <- if(length(x@nCont) > 1) as.list(as.integer(x@nCont)) else if(x@nCont >= 1) as.integer(x@nCont) else x@nCont 
            out <- select_cont(out, nCont, x@level, x@fixed)
            names(out)[grepl("idC", names(out))] <- paste("idC", x@name, sep = "")
            new("sim_rs_c", out)
          })