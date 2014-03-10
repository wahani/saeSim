generator_fe_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits, const, slope) {
    idD <- if (length(nUnits) == 1) rep(1:nDomains, each = nUnits) else 
      unlist(lapply(1:nDomains, function(i) rep(i, nUnits[i])))    
    x <- rnorm(length(idD), mean = mean, sd = sd)
    out <- data.frame(idD, x) %.% group_by(idD) %.% 
      mutate(idU = 1:n(), XB = const + slope * x) %.% arrange(idD, idU, x, XB)
    return(as.data.frame(out))
    
    
  }
}