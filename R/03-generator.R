#' Generator functions
#' 
#' These functions are intended to be used with \code{\link{sim_gen}} and not interactively. They are designed to draw random numbers according to the setting of grouping variables.
#'  
#'  @param mean the mean passed to the random number generator, for example \code{\link{rnorm}}.
#'  @param sd the standard deviation passed to the random number generator, for example \link{rnorm}.
#'  @param rho the correlation used to create the variance covariance matrix for a SAR process - see \code{\link[spdep]{cell2nb}}.
#'  @param type either "rook" or "queen". See \code{\link[spdep]{cell2nb}} for details.
#'  @param level character in \code{c("unit", "domain")}. If equal to 'unit' random numbers for all observations are generated. If equal to 'domain' they are different between domains and constant within.
#'  @param generator a function producing random numbers.
#'  @param ... arguments passed to \code{generator}.
#'  @param desc character used for describing the distribution from which the data is generated.
#'  
#'  @details \code{gen_norm} is used to draw random numbers from a normal distribution where all generated numbers are independent.
#'  
#'  \code{gen_v_norm} and \code{gen_v_sar} will create an area-level random component. In the case of \code{v_norm}, the error component will be from a normal distribution and i.i.d. from an area-level perspective (all units in an area will have the same value, all areas are independent). v_sar will also be from a normal distribution, but the errors are correlated. The variance covariance matrix is constructed for a SAR(1) - spatial/simultanous autoregressive process. \link[MASS]{mvrnorm} is used for the random number generation. 
#'  
#'  \code{gen_generic} can be used if your world is not normal. You can specify 'any' function as generator, like \code{\link{rnorm}}. Arguments in \code{...} are matched be name or position. The first argument of \code{generator} is expected to be the number of random numbers (not necessarily named \code{n}) and need not to be specified.
#'  
#'  @rdname generators
#'  @export
#'  @seealso \code{\link{sim_gen}}, \code{\link{sim_gen_fe}}, \code{\link{sim_gen_e}}, \code{\link{sim_gen_ec}}, \code{\link{sim_gen_re}}, \code{\link{sim_gen_rec}}, \code{\link[spdep]{cell2nb}}
#'  
#'  @examples
#'  sim_base() %>% sim_gen_fe() %>% sim_gen_e() %>% sim_gen_re() %>% sim_gen_re(gen_v_sar(name = "vSP"))
#'  
#'  # Generic interface
#'  set.seed(1)
#'  dat1 <- sim(base_id() %>%
#'                sim_gen(gen_generic(rnorm, mean = 0, sd = 4, name = "e")))
#'  set.seed(1)
#'  dat2 <- sim(base_id() %>% sim_gen_e())
#'  all.equal(dat1, dat2)
gen_norm <- function(mean = 0, sd = 1, name = "e") {
  desc <- paste(name, " ~ N(", mean, ", ", sd^2, ") unit-level", sep = "")
  function(dat) {
    dat <- add_var(dat, rnorm(nrow(dat), mean = mean, sd = sd), name)
    dat
  }
}

add_var <- function(dat, value, name) {
  dat[name] <- value + if(exists(name, dat)) dat[[name]] else 0
  dat
}

#' @rdname generators
#' @export
gen_v_norm <- function(mean = 0, sd = 1, name = "v") {
  desc <- paste(name, " ~ N(", mean, ", ", sd^2, ") domain-level", sep = "")
  function(dat) {
    tmp <- rnorm(length(unique(dat$idD)), mean = mean, sd = sd)
    dat <- add_var(dat, tmp[dat$idD], name)
    dat
  }
}

#' @importFrom MASS mvrnorm
#' @importFrom spdep cell2nb nb2mat
#' @rdname generators
#' @export
gen_v_sar <- function(mean = 0, sd = 1, rho = 0.5, type = "rook", name) {
  desc <- paste(name, " ~ N(", mean, ", SAR1(", type, ")(", rho, ", ", sd^2, ") domain-level", sep = "")
  function(dat) {
    nDomains <- length(unique(dat$idD))
    # Spatial Structure:
    W <- nb2mat(cell2nb(nDomains, 1, type), style = "W")
    identity <- diag(1, nDomains, nDomains)
    tmp <- identity - rho * W
    sp_var <- sd^2 * chol2inv(chol(crossprod(tmp, tmp)))
    
    # Drawing the numbers:
    v <- mvrnorm(1, mu = rep(mean, length.out = nDomains), Sigma = sp_var)
    
    dat <- add_var(dat, v[dat$idD], name)
    
    dat
  }
}

#' @rdname generators
#' @export
gen_generic <- function(generator, ..., groupVars = NULL, desc = "F", name) {
  genArgs <- list(...)
  force(generator)
  force(groupVars)
  
  desc <- paste(name, "~ ", desc, "(", paste(..., sep = ", "), ") ", groupVars, "-level", sep = "")
      
  gen_no_group <- function(dat) {
    randomNumbers <- do.call(generator, c(nrow(dat), genArgs))
    add_var(dat, randomNumbers, name)
  }
  
  gen_constant_within_group <- function(dat) {
    dat <- dat %>% s_arrange(groupVars)
    nrowGroup <- s_group_by(dat, groupVars) %>% group_size
    randomNumbers <- do.call(generator, c(length(nrowGroup), genArgs))
    add_var(dat, rep(randomNumbers, times = nrowGroup), name)
  }
  
  if(is.null(groupVars)) {
    gen_no_group
  } else {
    gen_constant_within_group
  }
}


