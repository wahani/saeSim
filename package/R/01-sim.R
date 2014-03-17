setGeneric("sim", function(x, ...) standardGeneric("sim"))

setMethod("sim", c(x = "sim_base"),
          function(x, ..., idC = TRUE) {
            #browser()
            setup <- sim_setup(x, ..., R = 1, simName = "", idC = idC)
            results <- lapply(setup[is.smstp(setup)], sim)
            out <- as.data.frame(Reduce(add, results))
            out$y <- rowSums(out[!grepl("id", names(out), ignore.case=FALSE) | grepl("B$", names(out), ignore.case=FALSE)])
            out <- out[!grepl("B$", names(out), ignore.case=FALSE)]
            # Features:
            if(idC) {
              out$idC <- Reduce("|", out[grepl("idC", names(out))])
              out <- out[!grepl("idC.", names(out))]
            }
            out
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