#' @export
setGeneric("select_cont", function(dat, nCont, level, fixed, ...) standardGeneric("select_cont"))

#' @export
setMethod("select_cont", c(dat = "data.frame", nCont = "integer"), 
          function(dat, nCont, level, fixed, ...) {
            # Def Variables:
            id_ind <- grepl("id", names(dat))
            # Unit - fixed
            if (level == "unit" & fixed) {
              out <- rbind_all(lapply(split(dat, dat$idD), 
                                      function(df) {
                                        ids <- df$idU < (max(nrow(df)) - nCont + 1)
                                        df[ids, !id_ind] <- 0
                                        df$idC <- !ids
                                        df
                                      }))
              return(out)  
            }
            # Unit - random
            if (level == "unit" & !fixed) {
              out <- rbind_all(lapply(split(dat, dat$idD), 
                                      function(df) {
                                        ids <- df$idU %in% sample(df$idU, max(0, nrow(df) - nCont))
                                        df[ids, !id_ind] <- 0
                                        df$idC <- !ids
                                        df
                                      }))
              return(out)
            }
            # Area - fixed
            if (level == "area" & fixed) {
              ids <- dat$idD < max(1, max(dat$idD) - nCont + 1)
            }
            # Area - random
            if (level == "area" & !fixed) {
              ids <- dat$idD %in% sample(1:max(dat$idD), max(0, max(dat$idD) - nCont))
            }
            # none - random
            if (level == "none" & fixed) {
              ids <- 1:nrow(dat) < (nrow(dat) - nCont + 1)              
            }
            # none - random
            if (level == "none" & !fixed) {
              ids <- 1:nrow(dat) %in% sample(1:nrow(dat), max(0, nrow(dat) - nCont))
            }
            dat[ids, !id_ind] <- 0
            dat$idC <- !ids
            return(dat)
          })

#' @export
setMethod("select_cont", c(nCont = "list"), 
          function(dat, nCont, level, fixed, ...) {
            # area | none
            # makes no sense
            if (level %in% c("area", "none")) stop("A vector for nCont is not supported fore level in c('area', 'none')!")
            # unit
            rbind_all(mapply(select_cont, split(dat, dat$idD), nCont, 
                             MoreArgs = list(level = level, fixed = fixed), 
                             SIMPLIFY = FALSE))
          })

#' @export
setMethod("select_cont", c(nCont = "numeric"), 
          function(dat, nCont, level, fixed, ...) {
            # area
            if (level %in% c("area")) {
              nCont <- as.integer(ceiling(nCont * max(dat$idD)))
            }
            # none
            if (level %in% c("none")) {
              nCont <- as.integer(ceiling(nCont * nrow(dat)))
            }
            # unit
            if (level == "unit") {
              nCont <- as.list(as.integer(ceiling(nCont * sapply(split(dat$idD, dat$idD), length))))
            }
            select_cont(dat, nCont, level, fixed)
          })