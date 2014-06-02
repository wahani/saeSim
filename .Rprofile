.First <- function() {
  if (grepl("Windows", Sys.getenv("OS"))) {
    .libPaths(paste(getwd(), "../libWin-3.1.0", sep = "/"))
    # Fix for Git under RStudio to locate SSH-Keys
    Sys.setenv(USERPROFILE=Sys.getenv("HOME"))
  } else {
      .libPaths("~/R/x86_64-pc-linux-gnu-library/3.1/")
    }

}
.First()
