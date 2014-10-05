#' Calculator function
#' 
#' This function is intended to be used with \code{\link{sim_calc}} and not interactively. It can be used to calculate statistics for gouping variables in the data.
#' 
#' @param by variable names as character to split the data. Computed values will be constant within each group.
#' @param ... variables interpreted in the context of that data frame.
#' 
#' @seealso \code{\link{sim_calc}}
#' @export
#' 
#' @examples
#' sim_lm() %>% sim_comp_pop(calc_var(yExp = exp(y)))
calc_var <- function(...) {
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

