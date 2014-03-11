setGeneric("sim", function(x, ...) standardGeneric("sim"))

setMethod("sim", c(x = "sim_base"),
          function(x, ...) {
            smstp_objects <- lapply(list(...), function(fun) fun(x))
            results <- lapply(smstp_objects, sim_generate)
            out <- as.data.frame(Reduce(add, results))
            out$y <- rowSums(out[!grepl("x|id", names(out), ignore.case=FALSE) | grepl("XB", names(out), ignore.case=FALSE)])
            out <- out[!grepl("XB", names(out), ignore.case=FALSE)]
            out
          })