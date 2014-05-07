#' @importFrom ggplot2 autoplot
#' @export
setGeneric("autoplot")

#' @export
setMethod("autoplot", "sim_setup", function(object, x = "x", y = "y", ...) {
            require(ggplot2)
            dat <- sim(object@base, S3Part(object, TRUE))
            ggplot(dat, aes_string(x = x, y = y)) + 
              stat_density2d(geom="tile", aes(fill=..density..^0.25, alpha=1), contour=FALSE) + 
              geom_point(alpha = 0.1, size = 0.5) +
              stat_density2d(geom="tile", aes(fill=..density..^0.25, alpha=ifelse(..density..^0.25<0.4,0,1)), contour=FALSE) +
              scale_fill_gradientn(colours = colorRampPalette(c("white", blues9))(256)) + 
              theme_classic() + theme(legend.position = "none")
          })