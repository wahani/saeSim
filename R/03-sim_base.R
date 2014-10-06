#' Constructor for sim_base
#' 
#' Use the `sim_base` functions to start a new simulation setup.
#' 
#' @param nDomains the number of domains.
#' @param nUnits the number of units. Can have \code{length(nUnits) == nDomains} where it is interpreted as number of units in each domain. Else the number of units in each domain is constant.
#' 
#' @export
#' @rdname sim_base
#' 
#' @examples
#' # Example for a linear model:
#' sim_base() %>% sim_gen_fe() %>% sim_gen_e()
sim_base <- function(data = base_id(100, 100)) {
  new("sim_setup", base = data, simName = "")
}

#' Construct a design-based set-up
#' 
#' \code{sim_base} is still an experimental implementation to extend the whole approach for design-based simulation studies. 
#' 
#' @param data a data.frame containing a population.
#' @param domainID variable names in \code{data} as character which will identify the domains/groups/cluster in the data.
#' 
#' @rdname base_addId
#' @export
base_addId <- function(data, domainID) {
  dataList <- split(data, data[domainID])
  nUnits <- sapply(dataList, nrow)
  nDomains <- length(nUnits)
  cbind(base_id(nDomains, nUnits), rbind_all(dataList))
}

#' Preconfigured set-ups
#' 
#' \code{sim_lm()} will start a linear model: One regressor, one error component. \code{sim_lmm()} will start a linear mixed model: One regressor, one error component and one random effect for the domain. \code{sim_lmc()} and \code{sim_lmmc()} add outlier contamination to the scenarios. Use these as a quick start, then you probably want to configure your own scenario.
#' 
#' @rdname sim_setup_preconfigured
#' @export
#' 
#' @examples
#' # The preconfigured set-ups:
#' sim_lm()
#' sim_lmm()
#' sim_lmc()
#' sim_lmmc()
sim_lm <- function() {
  sim_base() %>% 
    sim_gen_fe(gen_norm(0, 4, name = "x")) %>% 
    sim_gen_e(gen_norm(0, 4, name = "e")) %>%
    sim_resp(resp_eq(y = 100 + x + e))
}

#' @rdname sim_setup_preconfigured
#' @export
sim_lmm <- function() {
  sim_lm() %>% sim_gen_re(gen_v_norm(0, 1, name = "v")) %>% 
    sim_resp(resp_eq(y = y + v))
}

#' @rdname sim_setup_preconfigured
#' @export
sim_lmc <- function() {
  sim_lm() %>% sim_gen_ec()
}

#' @rdname sim_setup_preconfigured
#' @export
sim_lmmc <- function() {
  sim_lmm() %>% 
    sim_gen_ec() %>%
    sim_gen_rec()
}
