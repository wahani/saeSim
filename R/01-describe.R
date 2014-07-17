#' Describe
#' 
#' Use this function to get a description of your setup. At the moment only the data generation is being described. Contamination will be ignored.
#' 
#' @param x object
#' @param ... arguments passed to method
#' 
#' @export
#' 
#' @examples
#' describe(sim_lmm())
describe <- function(x, ...) UseMethod("describe")

#' @rdname describe
#' @export
describe.sim_setup <- function(x, ...) {
  genComponents <- S3Part(x, strictS3 = TRUE)[is.sim_gen_virtual(x)]
  
  descData <- lapply(genComponents, function(genC) 
    data.frame(const = genC@const, slope = genC@slope, name = genC@name, 
               desc = get(x = "desc", envir = environment(genC@fun)))) %>% 
    do.call(what = rbind)
  
  tmp1 <- paste(descData$slope, descData$name, sep = " * ", collapse = " + ")
  tmp2 <- paste(sum(descData$const), tmp1, sep = " + ")
  
  modelString <- paste("y =", tmp2) %>% 
    gsub(pattern = " 1 \\* ", replacement = " ")
  
  variableString <- paste(descData$name, descData$desc) %>% paste(collapse = "\n")
  
  cat("Model for response:\n")
  cat(modelString, "\n\n")
  cat("with:\n")
  cat(variableString)
  
  invisible(NULL)
}


