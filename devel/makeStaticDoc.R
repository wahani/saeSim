library(devtools)
document()
build_vignettes()
staticdocs::build_site()

#system('git push origin --delete gh-pages')
system('git add -f inst/web && git commit -m "gh-pages subtree commit"')
system('git subtree push --prefix inst/web origin gh-pages')
