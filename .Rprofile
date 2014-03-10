.First <- function() {
  if (grepl("Windows", Sys.getenv("OS"))) {
    .libPaths(paste(getwd(), "libWin", sep = "/"))
    # Fix for Git under RStudio to locate SSH-Keys
    Sys.setenv(USERPROFILE=Sys.getenv("HOME"))
  } else {
      .libPaths(paste(getwd(), "libLinux", sep = "/"))
    }

}
.First()
