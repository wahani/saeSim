#' Generation Component for contamination
#' @param nCont gives the number of contaminated observations. Values between 0 and 1 will be trated as probability. If length is larger 1, the expected length is the number of areas.
#' @param type "unit" or "area" - unit- or area-level contamination.
#' @param areaVar character with variable name(s) identifying areas.
#' @param fixed TRUE fixes the observations which will be contaminated. FALSE will result in a random selection of observations or areas.
#' @export
sim_gen_cont <- function(simSetup, generator, nCont, type, areaVar = NULL, fixed = TRUE) {
  
  generator <- gen_cont(generator, nCont, type, areaVar, fixed)
  
  sim_setup(simSetup, 
            new("sim_fun", order = 2, generator))
}

gen_cont <- function(generator, nCont, type, areaVar, fixed) {
  force(generator); force(nCont); force(type); force(areaVar); force(fixed)
  check_cont_input(nCont, type, fixed)
  
  function(dat) {
    contData <- generator(dat)
    contData <- select_cont(contData, nCont, type, areaVar, fixed)
    replace_contData(contData, dat)
  }
}

check_cont_input <- function(nCont, type, fixed) {
    
  if(length(nCont) == 1 && nCont == 1) {
    warning("nCont is equal to 1, will not be interpreted as proportion!")
  }
  
  if(!(type %in% c("area", "unit"))) {
    stop("Supported types are area and unit!")
  }
  
  if(length(nCont) > 1 & (type %in% c("area"))) {
    stop("A vector of nCont with type 'area' can not be interpreted!")
  }
}

replace_contData <- function(contData, dat) {
  vars <- names(contData)[names(contData) %in% names(dat)]
  for(var in vars) contData[var] <- replace_cont(contData[[var]], dat[[var]])
  contData
}

replace_cont <- function(var1, var2) ifelse(var1 == 0, var2, var1)


