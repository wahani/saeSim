#' @export
setGeneric("make_id", function(nDomains, nUnits, ...) standardGeneric("make_id"))

#' @export
setMethod("make_id", signature=c(nDomains = "numeric", nUnits = "numeric"),
          function(nDomains, nUnits, ...) {
            out <- data.frame(idD = rep(1:nDomains, each = nUnits)) %.% group_by(idD) %.%
              mutate(idU = 1:n()) %.% arrange(idD, idD)
            as.data.frame(out)
          })

#' @export
setMethod("make_id", signature=c(nDomains = "numeric", nUnits = "list"),
          function(nDomains, nUnits, ...) {
            out <- 
              data.frame(idD = unlist(lapply(1:nDomains, 
                                             function(i) rep(i, nUnits[[i]])))) %.% 
              group_by(idD) %.%
              mutate(idU = 1:n()) %.% arrange(idD, idD)
            as.data.frame(out)
          })

#' @export
is.sim_gen_virtual <- function(x) sapply(x, inherits, what = "sim_gen_virtual")
#' @export
is.sim_sample <- function(x) sapply(x, inherits, what = "sim_sample")
#' @export
is.sim_cpopulation <- function(x) sapply(x, inherits, what = "sim_cpopulation")
#' @export
is.sim_csample <- function(x) sapply(x, inherits, what = "sim_csample")
#' @export
is.sim_cresult <- function(x) sapply(x, inherits, what = "sim_cresult")
#' @export
is.sim_agg <- function(x) sapply(x, inherits, what = "sim_agg")
#' @export
is.sim_id_virtual <- function(x) sapply(x, inherits, what = "sim_id_virtual")

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Documentation is available at wahani.github.io/saeSim", domain = NULL, appendLF = TRUE)
}

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
sep = "", collapse = " " )
sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}
