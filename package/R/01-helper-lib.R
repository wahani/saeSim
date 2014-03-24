setGeneric("make_id", function(nDomains, nUnits, ...) standardGeneric("make_id"))

setMethod("make_id", signature=c(nDomains = "numeric", nUnits = "numeric"),
          function(nDomains, nUnits, ...) {
            out <- data.frame(idD = rep(1:nDomains, each = nUnits)) %.% group_by(idD) %.%
              mutate(idU = 1:n()) %.% arrange(idD, idD)
            as.data.frame(out)
          })

setMethod("make_id", signature=c(nDomains = "numeric", nUnits = "list"),
          function(nDomains, nUnits, ...) {
            out <- data.frame(idD = unlist(lapply(1:nDomains, function(i) rep(i, nUnits[[i]])))) %.% group_by(idD) %.%
              mutate(idU = 1:n()) %.% arrange(idD, idD)
            as.data.frame(out)
          })

is.smstp_ <- function(x) sapply(x, inherits, what = "smstp_")
is.smstp_sample <- function(x) sapply(x, inherits, what = "smstp_sample")
is.smstp_cpopulation <- function(x) sapply(x, inherits, what = "smstp_cpopulation")
is.smstp_csample <- function(x) sapply(x, inherits, what = "smstp_csample")
is.smstp_cresult <- function(x) sapply(x, inherits, what = "smstp_cresult")
is.smstp_agg <- function(x) sapply(x, inherits, what = "smstp_agg")