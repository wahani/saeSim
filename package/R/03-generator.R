generator_fe_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits, const, slope) {
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    x <- rnorm(nrow(idD), mean = mean, sd = sd)
    out <- data.frame(idD, x) %.% mutate(XB = const + slope * x) %.% arrange(idD, idU) %.% select(idD, idU, x)
    return(as.data.frame(out))
  }
}

generator_e_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits) {
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    e <- rnorm(nrow(idD), mean = mean, sd = sd)
    out <- data.frame(idD, e) %.% arrange(idD, idU) %.% select(idD, idU, e)
    return(as.data.frame(out))
  }
}