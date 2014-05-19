#' Generation component
#' 
#' One of the components which can be added to a simulation set-up. \code{sim_gen} is the generic interface to add components for data from some generator. Everything else are preconfigured wrapper functions of \code{sim_gen}. 
#' 
#' @param generator generator function used to generate random numbers.
#' @param const constant/intercept in a fixed effects part.
#' @param slope slope in a fixed effects part.
#' @param name variable name used in the resulting \code{data.frame}.
#' @param level "unit", "area" or "none" - is the whole area contaminated, units inside an area or random observations in the data.
#' @param nCont gives the number of contaminated observations. Values between 0 and 1 will be trated as proportion. If length is larger 1, the expected length is the number of domains, you can specify something else in each domain. Integers are expected in that cas - numeric will be converted to integer.
#' @param fixed TRUE fixes the observations which will be contaminated. FALSE will result in a random selection of contaminated observations. Default is NULL for non-contaminated scenarios.
#' 
#' @details \code{fe}: fixed-effect component; \code{e}: model-error; \code{ec}: contaminated model error; \code{re}: random-effect (error constant for each domain); \code{rec} contaminated random-effect. Note that for contamination you are expected to add both, a non-contaminated component and a contaminated component. They are simply added up in the response \code{y}.
#' 
#' Potentially you can define a \code{generator} yourself. Take care that it has three arguments, named \code{nDomains}, \code{nUnits} and \code{name}, and returns a \code{data.frame} with the variables \code{idD}, \code{idU} and one named with \code{name}. Use \code{make_id} to stay in the correct format.
#' @export
#' @rdname sim_gen
#' @seealso \code{\link{gen_norm}}, \code{\link{gen_v_norm}}, \code{\link{gen_v_sar}}, \code{\link{sim_agg}}, \code{\link{sim_calc}}, \code{\link{sim_sample}}
#' @examples
#' # Data setup for a mixed model
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_re %+% sim_gen_e()
#' # Adding contamination in the model error
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_re %+% sim_gen_e() %+% sim_gen_ec()
#' 
#' # Simple user generated generator:
#' gen_myVar <- function(nDomains, nUnits, name) {
#'   dat <- make_id(nDomains, nUnits)
#'   dat[name] <- rnorm(nrow(dat))
#'   dat
#' }
#' 
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_e(gen_myVar)
sim_gen <- function(generator, const = 0, slope = 1, name = "variableName", 
                    nCont = NULL, level = NULL, fixed = NULL) {
  # if all contamination parameter are NULL construct a 'sim_gen' object, sim_genCont
  # otherwise
  if(any(c(is.null(nCont), is.null(level), is.null(fixed)))) {
    new("sim_gen", fun = generator, const = const, slope = slope, name = name)
  } else {
    new("sim_genCont", fun = generator, const = const, slope = slope, name = name,
        nCont = nCont, level = level, fixed = fixed)
  }
  
}


#' @rdname sim_gen
#' @export
sim_gen_fe <- function(generator = gen_norm(0, 4), const = 100, slope = 1, name = "x") {
  sim_gen(generator = generator, slope = slope, const = const, name = name)  
}

#' @rdname sim_gen
#' @export
sim_gen_e <- function(generator = gen_norm(0, 4), name = "e") {
  sim_gen(generator = generator, name = name, slope = 1, const = 0)
}

#' @rdname sim_gen
#' @export
sim_gen_ec <- function(generator = gen_norm(mean=0, sd=150), nCont = 0.05, 
                       level = "unit", fixed = TRUE, name = "e") {
  sim_gen(generator = generator, slope = 1, const = 0, nCont = nCont, 
          level = level, fixed = fixed, name = name)
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

