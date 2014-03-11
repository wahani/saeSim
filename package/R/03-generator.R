generator_fe_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits, const, slope) {
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    x <- rnorm(nrow(idD), mean = mean, sd = sd)
    out <- data.frame(idD, x) %.% mutate(XB = const + slope * x) %.% arrange(idD, idU) %.% select(idD, idU, x, XB)
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

generator_v_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits) {    
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    v <- rnorm(nDomains, mean = mean, sd = sd)
    out <- data.frame(idD, v = v[idD$idD]) %.% arrange(idD, idU) %.% select(idD, idU, v)
    return(as.data.frame(out))
  }
}

generator_v_sar <- function(mean = 0, sp_sd = 1, rho = 0.5, type = "rook") {
  function(nDomains, nUnits) {    
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    
    # Spatial Structure:
    W <- nb2mat(cell2nb(nDomains, 1, type), style = "W")
    identity <- diag(1, nDomains, nDomains)
    tmp <- identity - rho * W
    sp_var <- sp_sd^2 * chol2inv(chol(crossprod(tmp, tmp)))
    
    # Drawing the numbers:
    v <- mvrnorm(1, mu = rep(mean, length.out = nDomains), Sigma = sp_var)
        
    out <- data.frame(idD, v_sp = v[idD$idD]) %.% arrange(idD, idU) %.% select(idD, idU, v_sp)
    return(as.data.frame(out))
  }
}



