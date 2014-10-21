library(devtools)
document()
build_vignettes()
staticdocs::build_site()
file.remove(
  list.files(path = "vignettes", pattern = "*.html", full.names = TRUE))

