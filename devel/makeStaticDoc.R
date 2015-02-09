library(devtools)
document()
install()
build_vignettes()
checkResult <- check()

if(checkResult) {
  system("rm -r inst/web") # needs to be deleted because the vignette was not updated
  staticdocs::build_site()
  #system('git push origin --delete gh-pages')
  system('git add -f inst/web && git commit -m "gh-pages subtree commit"')
  system('git subtree push --prefix inst/web origin gh-pages')
}
