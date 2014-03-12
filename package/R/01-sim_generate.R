setGeneric("sim_generate", function(x, ...) standardGeneric("sim_generate"))

setMethod("sim_generate", signature=c(x = "smstp_fe"),
          function(x, ...) {
            new("sim_rs_fe", x@generator(x@nDomains, x@nUnits, x@const, x@slope))
          })

setMethod("sim_generate", signature=c(x = "smstp_"),
          function(x, ...) {
            new("sim_rs", x@generator(x@nDomains, x@nUnits))
          })

setMethod("sim_generate", signature=c(x = "smstp_c"),
          function(x, ...) {
            out <- x@generator(x@nDomains, x@nUnits)
            nCont <- if(length(x@nCont) > 1) as.list(as.integer(x@nCont)) else if(x@nCont >= 1) as.integer(x@nCont) else x@nCont 
            out <- select_cont(out, nCont, x@level, x@fixed)
            new("sim_rs", out)
          })



sim_rec <- function(generator = generator_e_norm(), nCont = 0.05, level = "unit", fixed = TRUE) {
  function(sim_base) {
    new("smstp_c", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, generator = generator,
        nCont = nCont, level = level, fixed = fixed)
  }
}