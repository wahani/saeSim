sim_setup <- function(base, ..., R = 500, simName = "test", idC = TRUE) {
  # Taking care of the smstp-family:
  dots <- list(...)
  if (class(dots[[1]]) == "list") dots <- dots[[1]]
  
  smstp_objects <- lapply(dots, function(x) {
    x@nDomains <- base$nDomains
    x@nUnits <- base$nUnits
    x
  })
  
  # Putting everything in a list:
  new("sim_setup", base = base, R = R, simName = simName, idC = idC, smstp_objects)
}