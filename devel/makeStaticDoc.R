library(devtools)
document()
build_vignettes()
staticdocs::build_site()
file.remove(
  list.files(path = "vignettes", pattern = "*.html", full.names = TRUE))

system('git add -f inst/web && git commit -m "Initial dist subtree commit"')
system('git subtree push --prefix inst/web origin gh-pages')
