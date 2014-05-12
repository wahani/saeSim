#' @export
is.sim_gen_virtual <- function(x) sapply(x, inherits, what = "sim_gen_virtual")
#' @export
is.sim_sample <- function(x) sapply(x, inherits, what = "sim_sample")
#' @export
is.sim_cpopulation <- function(x) sapply(x, inherits, what = "sim_cpopulation")
#' @export
is.sim_csample <- function(x) sapply(x, inherits, what = "sim_csample")
#' @export
is.sim_cagg <- function(x) sapply(x, inherits, what = "sim_cagg")
#' @export
is.sim_agg <- function(x) sapply(x, inherits, what = "sim_agg")
#' @export
is.sim_id_virtual <- function(x) sapply(x, inherits, what = "sim_id_virtual")

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Documentation is available at wahani.github.io/saeSim", domain = NULL, appendLF = TRUE)
}

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
sep = "", collapse = " " )
sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}
