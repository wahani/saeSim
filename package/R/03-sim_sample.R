#' @export
sim_sample <- function(smplFun = sample_csrs(size=5L)) {
  new("sim_sample", fun = smplFun)
}