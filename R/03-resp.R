#' @export
resp_eq <- function(...) {
  mc <- match.call(expand.dots = TRUE)
  mc[[1]] <- quote(mutate_wrapper)
  eval(mc)
}
