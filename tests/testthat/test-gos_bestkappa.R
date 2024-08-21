test_that("Whether multi-core parallel computing is the same as single-core computing in gos_bestkappa", {
  data("zn")
  zn$Zn <- log(zn$Zn)
  k <- SecDim::rmvoutlier(zn$Zn, coef = 2.5)
  dt <- zn[-k,]
  b1 <- gos_bestkappa(Zn ~ Slope + Water + NDVI  + SOC + pH + Road + Mine,
                      data = dt,
                      kappa = c(0.01, 0.05, 0.1, 0.2, 0.5, 1),
                      nrepeat = 2,
                      cores = 1)
  b2 <- gos_bestkappa(Zn ~ Slope + Water + NDVI  + SOC + pH + Road + Mine,
                      data = dt,
                      kappa = c(0.01, 0.05, 0.1, 0.2, 0.5, 1),
                      nrepeat = 2,
                      cores = 4)
  expect_equal(b1$bestkappa, b2$bestkappa)
})
