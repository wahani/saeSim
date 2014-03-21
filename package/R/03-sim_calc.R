sim_calc <- function(calcFun = calc_var(), level = "population") {
  if(!(level %in% c("population", "sample", "result"))) stop("This level is not supported, check spelling.")
  new(paste("smstp_c", level, sep = ""), calcFun = calcFun)
}