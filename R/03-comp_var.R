#' Compute variables in data
#' 
#' This function is intended to be used with \code{\link{sim_comp_pop}}, \code{\link{sim_comp_sample}} or \code{\link{sim_comp_agg}} and not interactively. This is a wrapper around \code{\link[dplyr]{mutate}}
#' 
#' @param ... variables interpreted in the context of that data frame.
#' 
#' @seealso \code{\link{sim_comp_pop}}, \code{\link{sim_comp_sample}}, \code{\link{sim_comp_agg}}
#' @export
#' 
#' @examples
#' sim_base_lm() %>% sim_comp_pop(comp_var(yExp = exp(y)))
comp_var <- function(...) {
  mc <- match.call(expand.dots = TRUE)
  mc[[1]] <- quote(mutate_wrapper)
  eval(mc)
}

mutate_wrapper <- function(...) {
  mc <- match.call(expand.dots = TRUE)
  mc[[1L]] <- quote(mutate)
  mc[[length(mc) + 1]] <- quote(dat)
  
  function(dat) {
    eval(mc)
  }
}

apply_by <- function(by, fun) {
  force(fun)
  force(by)
  function(dat) {
    stopifnot(all(by %in% names(dat)))
    savedAttr <- attributes(dat)
    out <- split(dat, dat[by]) %>% lapply(fun) %>% rbind_all
    attrToKeep <- which(!(names(savedAttr) %in% names(attributes(out))))
    attributes(out)[names(savedAttr)[attrToKeep]] <- savedAttr[attrToKeep]
    out
  }
}

