#' Add generated data
#' 
#' These functions can be used to add data to a setup. The terminology comes from mixed models.
#' 
#' @param generator generator function used to generate random numbers
#' @param const constant/intercept in a fixed effects part
#' @param slope slope in a fixed effects part
#' @param name variable name used in the resulting \code{data.frame}
#' @param level "unit", "area" or "none" - is the whole area contaminated, units inside an area or random observations in the data
#' @param nCont gives the number of contaminated observations. Values between 0 and 1 will be trated as proportion. If length is larger 1, the expected length is the number of domains, you can specify something else in each domain. Integers are expected in that cas - numeric will be converted to integer
#' 
#' @return These functions are not designed to be used interactively but added to a setup. See examples
#' @export
#' @rdname sim_gen
#' @seealso \code{\link{gen_norm}}, \code{\link{gen_v_norm}}, \code{\link{gen_v_sar}}
#' @examples
#' # Data setup for a mixed model
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_re %+% sim_gen_e()
#' # Adding contamination in the model error
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_re %+% sim_gen_e() %+% sim_gen_ec()
sim_gen_fe <- function(generator = gen_norm(0, 4), const = 100, slope = 1, name = "x") {
  new("smstp_fe", generator = generator, slope = slope, const = const, name = name)  
}

#' @rdname sim_gen
#' @export
sim_gen_e <- function(generator = gen_norm(0, 4), name = "e") {
  new("smstp_", generator = generator, name = name)
}

#' @rdname sim_gen
#' @export
sim_gen_ec <- function(generator = gen_norm(mean=0, sd=150), nCont = 0.05, level = "unit", fixed = TRUE, name = "e") {
  out <- new("smstp_c", generator = generator, nCont = nCont, level = level, fixed = fixed, name = name)
}

#' @rdname sim_gen
#' @export
# wrapper:
sim_gen_re <- function(generator = gen_v_norm(), name = "v") {
  sim_gen_e(generator, name)
}

#' @rdname sim_gen
#' @export
sim_gen_rec <- function(generator = gen_v_norm(mean=0, sd=40), nCont = 0.05, level = "area", fixed = TRUE, name = "v") {
  sim_gen_ec(generator, nCont, level, fixed, name)
}

# Base:
sim_base_standard <- function(nDomains = 100, nUnits = 100) {
  new("sim_base", list(nDomains = nDomains, nUnits = nUnits))
}
