#' Aggregation component
#' 
#' Aggregating the data is another component which can be used on the population or sample. The aggregation will simply be done after the sampling, if you haven't specified any sampling component, the population is aggregated (makes sense if you draw samples directly from the model). The unit identifier \code{idU} will be lost.
#' 
#' @param aggFun function which controls the aggregation process. At the moment only \code{\link{agg_standard}} is defined.
#' 
#' @seealso \code{\link{agg_standard}}
#' 
#' @export
#' @examples
#' # Aggregating the population:
#' sim_lm() %+% sim_agg()
#' 
#' # Aggregating after sampling:
#' sim_lm() %+% sim_sample() %+% sim_agg()
#' 
sim_agg <- function(aggFun = agg_standard()) {
  new("sim_agg", fun = aggFun)
}