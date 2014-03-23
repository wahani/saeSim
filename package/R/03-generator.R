#' Generates random numbers
#' 
#'  This function family is designed to draw random numbers according to the setting for domains and units in a domain. fe stands for fixed effects, e for the model error and v for an additional error component defined on area level (random effect). These functions are used in combination with the \code{\link{sim_gen}} function family.
#'  
#'  @param mean the mean passed to the random number generator, for example \code{\link{rnorm}}
#'  @param sd the standard deviation passed to the random number generator, for example \link{rnorm}
#'  @param rho the correlation used to create the variance covariance matrix for a SAR process - see \code{\link[spdep]{cell2nb}}
#'  @param type either "rook" or "queen". See \code{\link[spdep]{cell2nb}} for detials
#'  
#'  @details \code{gen_norm} is used to draw random numbers from a homoscedastic normal distribution. This generator is used for the fixed effects part and model error.
#'  
#'  \code{gen_v_norm} and \code{gen_v_sar} will create an area-level random component. In the case of v_norm, the error component will be from a normal distribution and i.i.d. from an area-level perspective (all units in an area will get the same value, all areas are independent). v_sar will also come from a normal distribution, but the errors are correlated. The variance covariance matrix is constructed for a SAR(1) - spatial/simultanous autoregressive process. \link[MASS]{mvrnorm} is used for the random number generation. 
#'  
#'  @return These functions are not called directly but via \code{\link{sim_gen}} 
#'  @rdname generators
#'  @export
#'  @seealso For examples: \code{\link{sim_gen_fe}}, \code{\link{sim_gen_e}}, \code{\link{sim_gen_ec}}, \code{\link{sim_gen_re}} and \code{\link{sim_gen_rec}}
gen_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits, name) {
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    idD[name] <- rnorm(nrow(idD), mean = mean, sd = sd)
    idD
  }
}

#' @rdname generators
#' @export
gen_v_norm <- function(mean = 0, sd = 1) {
  function(nDomains, nUnits, name) {    
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    tmp <- rnorm(nDomains, mean = mean, sd = sd)
    idD[name] <- tmp[idD$idD]
    idD
  }
}

#' @rdname generators
#' @export
gen_v_sar <- function(mean = 0, sd = 1, rho = 0.5, type = "rook") {
  function(nDomains, nUnits, name) {    
    idD <- make_id(nDomains, if (length(nUnits) == 1) nUnits else as.list(nUnits))
    
    # Spatial Structure:
    W <- nb2mat(cell2nb(nDomains, 1, type), style = "W")
    identity <- diag(1, nDomains, nDomains)
    tmp <- identity - rho * W
    sp_var <- sd^2 * chol2inv(chol(crossprod(tmp, tmp)))
    
    # Drawing the numbers:
    v <- mvrnorm(1, mu = rep(mean, length.out = nDomains), Sigma = sp_var)
        
    idD[name] <- v[idD$idD]
    idD
  }
}