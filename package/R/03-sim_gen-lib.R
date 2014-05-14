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
#' @export
#' @rdname sim_gen
#' @seealso \code{\link{gen_norm}}, \code{\link{gen_v_norm}}, \code{\link{gen_v_sar}}
#' @examples
#' # Data setup for a mixed model
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_re %+% sim_gen_e()
#' # Adding contamination in the model error
#' sim_base_standard() %+% sim_gen_fe() %+% sim_gen_re %+% sim_gen_e() %+% sim_gen_ec()
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


#' Basics for a simulation setup
#' 
#' Use the `sim_base_*` functions to start a new simulation setup. Everything else are just preconfigured setups.
#' 
#' @param nDomains the number of domains
#' @param nUnits the number of units
#' 
#' @export
#' @rdname sim_base
sim_base_standard <- function(nDomains = 100, nUnits = 100) {
  new("sim_base", list(nDomains = nDomains, nUnits = nUnits))
}


#' @rdname sim_base
#' @export
sim_lm <- function() {
  sim_base_standard(nDomains = 100, nUnits = 100) %+% 
    sim_gen_fe(gen_norm(0, 4), const = 100, slope = 1, name = "x") %+% 
    sim_gen_e(gen_norm(0, 4), name = "e")
}

#' @rdname sim_base
#' @export
sim_lmm <- function() {
  sim_lm() %+% sim_gen_re(gen_v_norm(0, 1), name = "v")
}

#' @rdname sim_base
#' @export
sim_lmc <- function() {
  sim_lm() %+% sim_gen_ec(gen_norm(mean = 0, sd = 150), nCont = 0.05,
                          level = "unit", fixed = TRUE, name = "e")
}

#' @rdname sim_base
#' @export
sim_lmmc <- function() {
  sim_lmc() %+% sim_gen_re(gen_v_norm(0, 1), name = "v") %+% 
    sim_gen_rec(gen_v_norm(mean = 0, sd = 40), nCont = 0.05,
                level = "area", fixed = TRUE, name = "v")
}

