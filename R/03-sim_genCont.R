#' Generation Component for contamination
#' @param level "unit", "area" or "none" - is the whole area contaminated, units inside an area or random observations in the data.
#' @param nCont gives the number of contaminated observations. Values between 0 and 1 will be trated as proportion. If length is larger 1, the expected length is the number of domains, you can specify something else in each domain. Integers are expected in that cas - numeric will be converted to integer.
#' @param fixed TRUE fixes the observations which will be contaminated. FALSE will result in a random selection of contaminated observations. Default is NULL for non-contaminated scenarios.
#' @export
sim_gen_cont <- function(simSetup, generator, nCont, level, fixed) {
  
  generator <- gen_cont(generator, nCont, level, fixed)
  
  sim_setup(simSetup, 
            new("sim_fun", order = 2, generator))
}

gen_cont <- function(generator, nCont, level, fixed) {
  force(generator); force(nCont); force(level); force(fixed)
  
  check_cont_input(nCont, level, fixed)
  
  # This is important for the dispatch for select_cont
  nCont <- if(length(nCont) > 1) as.list(as.integer(nCont)) else 
    if(nCont >= 1) as.integer(nCont) else nCont 
  
  function(dat) {
    contData <- generator(dat)
    contData <- select_cont(contData, nCont, level, fixed)
    replace_contData(contData, dat)
  }
}

check_cont_input <- function(nCont, level, fixed) {
  if(any(nCont <= 0)) {
    stop("nCont is expected to be larger than 0!")
  }
  
  if(length(nCont) == 1 && nCont == 1) {
    warning("nCont is equal to 1, will not be interpreted as proportion!")
  }
  
  if(!(level %in% c("area", "unit", "none"))) {
    stop("Supported levels are area, unit and none!")
  }
  
  if(length(nCont) > 1 & (level %in% c("area", "none"))) {
    stop("A vector of nCont on level area or none can not be interpreted!")
  }
}

replace_contData <- function(contData, dat) {
  vars <- names(contData)[names(contData) %in% names(dat)]
  for(var in vars) contData[var] <- replace_cont(contData[[var]], dat[[var]])
  contData
}

replace_cont <- function(var1, var2) ifelse(var1 == 0, var2, var1)


