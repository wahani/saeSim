#' Sampling functions
#' 
#' This function is intended to be used with \code{\link{sim_sample}} and not interactively. This is a wrapper around \link[dplyr]{sample_frac} and \link[dplyr]{sample_n}.
#' 
#' @param groupVars character with names of variables to be used for grouping.
#' 
#' @inheritParams dplyr::sample_frac
#' 
#' @rdname sampling
#' @export
#' 
#' @examples
#' sim_base_lm() %>% sim_sample(sample_number(5))
#' sim_base_lm() %>% sim_sample(sample_fraction(0.5))
sample_fraction <- function(size, replace = FALSE, weight = NULL, groupVars = NULL) {
  force(size); force(replace); force(weight); force(groupVars)
  function(dat) {
    if(is.null(groupVars)) {
      dat %>% sample_frac(size = size, replace = replace, weight = weight)
    } else {
      s_group_by(dat, groupVars) %>% 
        sample_frac(size = size, replace = replace, weight = weight) %>% as.data.frame
    }
  }
}

#' @rdname sampling
#' @export
sample_number <- function(size, replace = FALSE, weight = NULL, groupVars = NULL) {
  force(size); force(replace); force(weight); force(groupVars)
  function(dat) {
    if(is.null(groupVars)) {
      dat %>% sample_n(size = size, replace = replace, weight = weight)
    } else {
      s_group_by(dat, groupVars) %>% 
        sample_n(size = size, replace = replace, weight = weight) %>% as.data.frame
    }
  }
}
