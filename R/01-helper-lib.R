is.sim_gen_virtual <- function(x) sapply(x, inherits, what = "sim_gen_virtual")
is.sim_gen <- function(x) sapply(x, inherits, what = "sim_gen")
is.sim_resp <- function(x) sapply(x, inherits, what = "sim_resp")
is.sim_sample <- function(x) sapply(x, inherits, what = "sim_sample")
is.sim_cpopulation <- function(x) sapply(x, inherits, what = "sim_cpopulation")
is.sim_csample <- function(x) sapply(x, inherits, what = "sim_csample")
is.sim_cagg <- function(x) sapply(x, inherits, what = "sim_cagg")
is.sim_agg <- function(x) sapply(x, inherits, what = "sim_agg")
is.sim_id_virtual <- function(x) sapply(x, inherits, what = "sim_id_virtual")
is.sim_genData <- function(x) sapply(x, inherits, what = "sim_genData")
is.sim_genCont <- function(x) sapply(x, inherits, what = "sim_genCont")

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Documentation is available at wahani.github.io/saeSim", domain = NULL, appendLF = TRUE)
}

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
{s <- substring(s, 2); if(strict) tolower(s) else s},
sep = "", collapse = " " )
sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}
