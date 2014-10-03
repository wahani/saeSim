#' @export
sim_simName <- function(simSetup, name) {
  slot(simSetup, "simName") <- name
  simSetup
}