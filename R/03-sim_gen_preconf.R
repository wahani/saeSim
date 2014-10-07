#' Preconfigured generation components
#' 
#' These are some preconfigured generation components and all wrappers around \code{\link{sim_gen}} and \code{\link{sim_gen_cont}}.
#' 
#' @inheritParams sim_gen_cont
#' 
#' @details \code{fe}: fixed-effect component; \code{e}: model-error; \code{ec}: contaminated model error; \code{re}: random-effect (error constant for each domain); \code{rec} contaminated random-effect. Note that for contamination you are expected to add both, a non-contaminated component and a contaminated component. They are simply added up in the response \code{y}.
#' @rdname sim_gen_preconf
#' @export
sim_gen_fe <- function(simSetup, generator = gen_norm(0, 4, name = "x")) {
  sim_gen(simSetup, generator = generator)
}

#' @rdname sim_gen_preconf
#' @export
sim_gen_e <- function(simSetup, generator = gen_norm(0, 4, name = "e")) {
  sim_gen(simSetup, generator = generator)
}

#' @rdname sim_gen_preconf
#' @export
sim_gen_ec <- function(simSetup,
                       generator = gen_norm(mean=0, sd=150, name = "e"), 
                       nCont = 0.05, type = "unit", areaVar = "idD", fixed = TRUE) {
  sim_gen_cont(simSetup, generator = generator, nCont = nCont, type = type, areaVar = areaVar, fixed = fixed)
}

#' @rdname sim_gen_preconf
#' @export
# wrapper:
sim_gen_re <- function(simSetup, generator = gen_v_norm(name = "v")) {
  sim_gen_e(simSetup, generator)
}

#' @rdname sim_gen_preconf
#' @export
sim_gen_rec <- function(simSetup,
                        generator = gen_v_norm(mean=0, sd=40, name = "v"), 
                        nCont = 0.05, type = "area", areaVar = "idD", fixed = TRUE) {
  sim_gen_ec(simSetup, generator = generator, nCont = nCont, type = type, areaVar = areaVar, fixed = fixed)
}
