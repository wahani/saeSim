setGeneric("sim_generate", function(x, ...) standardGeneric("sim_generate"))

setMethod("sim_generate", signature=c(x = "smstp_fe"),
          function(x, ...) {
            new("sim_rs_fe", x@generator(x@nDomains, x@nUnits, x@const, x@slope))
          })