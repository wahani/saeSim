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
            
            new("sim_rs", out)
          })


nCont <- 1
setGeneric("select_cont", function(dat, nCont, level, fixed, ...) standardGeneric("select_cont"))
setMethod("select_cont", c(nCont = "integer"), 
          function(dat, nCont, level, fixed, ...) {
            # Unit - fixed
            if (level == "unit" & fixed) {
              out <- rbind_all(lapply(split(dat, dat$idD), 
                     function(df) {
                       df[1:(nrow(df) - nCont), !grepl("id", names(df))] <- 0
                       df
                     }))
              return(out)  
            }
            # Unit - random
            if (level == "unit" & !fixed) {
              out <- rbind_all(lapply(split(dat, dat$idD), 
                                      function(df) {
                                        sample()
                                        df[1:(nrow(df) - nCont), !grepl("id", names(df))] <- 0
                                        df
                                      }))
              return(out)  
            }
            # Area - fixed
            # Area - random
          })


select_cont


sim_rec <- function(generator = generator_e_norm(), nCont = 1, level = "unit", fixed = TRUE) {
  function(sim_base) {
    new("smstp_c", nDomains = sim_base$nDomains, nUnits = sim_base$nUnits, 
        generator = generator)
  }
}