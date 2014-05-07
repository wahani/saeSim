#' @export
sim_agg <- function(aggFun = agg_standard()) {
  new("sim_agg", fun = aggFun)
}