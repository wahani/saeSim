#' Autoplot methods
#' 
#' Use this function to produce plots for an object of class \code{sim_setup} and you like to have plots based on ggplot2. At this time it is a ggplot2 implementation which mimics the behavior of \code{\link{smoothScatter}} without all the options.
#' 
#' @param x character of variable name in the data on the x-axis
#' @param y character of variable name in the data on the y-axis
#' 
#' @inheritParams autoplot
#' @export
#' 
#' @rdname autoplot
#' @examples
#' setup <- sim_setup(sim_base_standard(), sim_gen_fe(), sim_gen_e())
#' 
#' \dontrun{
#' autoplot(setup)
#' }
setGeneric("autoplot")

#' @rdname autoplot
#' @export
setMethod("autoplot", "sim_setup", function(object, x = "x", y = "y", ...) {
            dat <- sim(object@base, S3Part(object, TRUE))
            ggplot(dat, aes_string(x = x, y = y)) + 
              stat_density2d(geom="tile", aes(fill=..density..^0.25, alpha=1), contour=FALSE) + 
              geom_point(alpha = 0.1, size = 0.5) +
              stat_density2d(geom="tile", aes(fill=..density..^0.25, alpha=ifelse(..density..^0.25<0.4,0,1)), contour=FALSE) +
              scale_fill_gradientn(colours = colorRampPalette(c("white", blues9))(256)) + 
              theme_classic() + theme(legend.position = "none")
          })