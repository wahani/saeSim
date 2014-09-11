library("magrittr")
dat1 <- data.frame(make_id(3, 2), x = 1)
dat2 <- data.frame(make_id(3, 2), c = 2, idC = rep(c(TRUE, FALSE), 3))

expect_true((add(dat1, dat1)$x == 2) %>% all)
expect_equal(names(add(dat1, dat2)), c("idD", "idU", "x", "c", "idC"))
expect_equal(add(dat2, dat2)$idC, dat2$idC + dat2$idC)

add <- function(dat1, dat2) {
  idVars <- c("idD", "idU")
  indNewVars <- !names(dat2) %in% names(dat1)
  namesNewVars <- names(dat2)[indNewVars]
  namesDuplicateVars <- names(dat2)[!indNewVars]
  
  dat <- dat1
  dat[namesNewVars] <- dat2[namesNewVars]
  dat[namesDuplicateVars] <- dat1[namesDuplicateVars] + dat2[namesDuplicateVars]
  
  dat[idVars] <- dat1[idVars]
  dat
}

# 1. generator1(dat, ...) %>% generator2(...) %>%
# 2. add(slect_cont(generator3(dat, ...))) %>%
# 3. makeResponse %>% 
# 4. sampling...
