.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Documentation is available at wahani.github.io/saeSim", domain = NULL, appendLF = TRUE)
}

mutate_wrapper <- function(...) {
  mc <- match.call(expand.dots = TRUE)
  mc[[1L]] <- quote(mutate)
  mc[[length(mc) + 1]] <- quote(dat)
  
  function(dat) {
    eval(mc)
  }
}

apply_by <- function(by, fun) {
  # by: variable names used for split
  force(fun)
  force(by)
  function(dat) {
    stopifnot(all(by %in% names(dat)))
    savedAttr <- attributes(dat)
    out <- split(dat, dat[by]) %>% lapply(fun) %>% rbind_all
    attrToKeep <- which(!(names(savedAttr) %in% names(attributes(out))))
    attributes(out)[names(savedAttr)[attrToKeep]] <- savedAttr[attrToKeep]
    out
  }
}

mapply_by <- function(by, funs) {
  # by: variable names used for split
  force(funs)
  force(by)
  function(dat) {
    stopifnot(all(by %in% names(dat)))
    savedAttr <- attributes(dat)
    out <- mapply(function(dat, fun) fun(dat), dat = split(dat, dat[by]), fun = funs, SIMPLIFY = FALSE) %>% rbind_all
    attrToKeep <- which(!(names(savedAttr) %in% names(attributes(out))))
    attributes(out)[names(savedAttr)[attrToKeep]] <- savedAttr[attrToKeep]
    out
  }
}