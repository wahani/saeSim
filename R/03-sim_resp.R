#' @export
sim_resp <- function(simSetup, respFun = resp_eq()) {
  sim_setup(simSetup, new("sim_fun", order = 3, respFun))
}
