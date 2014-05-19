#' Generator functions
#' 
#' These functions are intended to be used with \code{\link{sim_gen}} and not interactively. They are designed to draw random numbers according to the setting of grouping variables.
#'  
#'  @param mean the mean passed to the random number generator, for example \code{\link{rnorm}}.
#'  @param sd the standard deviation passed to the random number generator, for example \link{rnorm}.
#'  @param rho the correlation used to create the variance covariance matrix for a SAR process - see \code{\link[spdep]{cell2nb}}.
#'  @param type either "rook" or "queen". See \code{\link[spdep]{cell2nb}} for details.
#'  
#'  @details \code{gen_norm} is used to draw random numbers from a normal distribution where all generated numbers are independent.
#'  
#'  \code{gen_v_norm} and \code{gen_v_sar} will create an area-level random component. In the case of \code{v_norm}, the error component will be from a normal distribution and i.i.d. from an area-level perspective (all units in an area will have same value, all areas are independent). v_sar will also be from a normal distribution, but the errors are correlated. The variance covariance matrix is constructed for a SAR(1) - spatial/simultanous autoregressive process. \link[MASS]{mvrnorm} is used for the random number generation. 
#'  
#'  @rdname generators
#'  @export
#'  @seealso For examples: \code{\link{sim_gen}}, \code{\link{sim_gen_fe}}, \code{\link{sim_gen_e}}, \code{\link{sim_gen_ec}}, \code{\link{sim_gen_re}}, \code{\link{sim_gen_rec}}, \code{\link[spdep]{cell2nb}}
#'  
#'  @examples
#'  sim_base_standard %+% sim_gen_fe %+% sim_gen_e() %+% sim_gen_re %+% sim_gen_re(gen_v_sar())
gen_norm <- function(mean = 0, sd = 1) {
  desc <- paste("~ N(", mean, ", ", sd^2, ")", sep = "")
  function(nDomains, nUnits, name) {
    idD <- make_id(nDomains, nUnits)
    idD[name] <- rnorm(nrow(idD), mean = mean, sd = sd)
    idD
  }
}

#' @rdname generators
#' @export
gen_v_norm <- function(mean = 0, sd = 1) {
  desc <- paste("~ N(", mean, ", ", sd^2, ")", sep = "")
  function(nDomains, nUnits, name) {    
    idD <- make_id(nDomains, nUnits)
    tmp <- rnorm(nDomains, mean = mean, sd = sd)
    idD[name] <- tmp[idD$idD]
    idD
  }
}

#' @importFrom MASS mvrnorm
#' @importFrom spdep cell2nb nb2mat
#' @rdname generators
#' @export
gen_v_sar <- function(mean = 0, sd = 1, rho = 0.5, type = "rook") {
  desc <- paste("~ N(", mean, ", SAR1(", rho, ", ", sd^2, ")", sep = "")
  function(nDomains, nUnits, name) {    
    idD <- make_id(nDomains, nUnits)
    
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