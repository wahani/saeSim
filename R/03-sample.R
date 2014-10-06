#' Sampling function
#' 
#' This is a wrapper around \link[dplyr]{sample_frac}.
#' 
#' @param groupVars character with names of variables to be used for grouping.
#' 
#' @inheritParams dplyr::sample_frac
#' 
#' @rdname sampling
#' @export
#' 
sample_fraction <- function(size, replace = FALSE, weight = NULL, groupVars = NULL) {
  force(size); force(replace); force(weight); force(groupVars)
  function(dat) {
    if(is.null(groupVars)) {
      dat %>% dplyr:::sample_frac.data.frame(size = size, replace = replace, weight = weight)
    } else {
      s_group_by(dat, groupVars) %>% 
        dplyr:::sample_frac.grouped_df(size = size, replace = replace, weight = weight) %>% as.data.frame
    }
  }
}

#' @rdname sampling
#' @export
sample_number <- function(size, replace = FALSE, weight = NULL, groupVars = NULL) {
  force(size); force(replace); force(weight); force(groupVars)
  function(dat) {
    if(is.null(groupVars)) {
      dat %>% dplyr:::sample_n.data.frame(size = size, replace = replace, weight = weight)
    } else {
      s_group_by(dat, groupVars) %>% 
        dplyr:::sample_n.grouped_df(size = size, replace = replace, weight = weight) %>% as.data.frame
    }
  }
}


s_group_by = function(.data, ...) {
  eval.string.dplyr(.data,"group_by", ...)
}

eval.string.dplyr = function(.data, .fun.name, ...) {
  args = list(...)
  args = unlist(args)
  code = paste0(.fun.name,"(.data,", paste0(args, collapse=","), ")")
  df = eval(parse(text=code,srcfile=NULL))
  df
}
