setGeneric("sim", function(x, ...) standardGeneric("sim"))

setMethod("sim", c(x = "sim_base"),
          function(x, ...) {
            smstp_objects <- lapply(list(...), function(fun) fun(sim_base))
            results <- lapply(smstp_objects, sim_generate)
            Reduce(add, results)
          })