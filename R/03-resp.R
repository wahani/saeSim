#' @export
resp_eq <- function(...) {
  
  mc <- match.call(expand.dots = TRUE)
  mc[[1L]] <- quote(mutate)
  mc[[length(mc) + 1]] <- quote(dat)
  
  function(dat) {
    eval(mc)
  }
}