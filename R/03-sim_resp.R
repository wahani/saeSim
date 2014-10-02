#' @export
sim_resp <- function(respFun = resp_eq()) {
  new("sim_resp", fun = respFun)
}
