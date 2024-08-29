test_that("Whether multi-core parallel computing is the same as single-core computing in gos", {
  data("zn")
  zn$Zn <- log(zn$Zn)
  k <- removeoutlier(zn$Zn, coef = 2.5)
  dt <- zn[-k,]
  g1 <- gos(Zn ~ Slope + Water + NDVI  + SOC + pH + Road + Mine,
            data = dt, newdata = grid, kappa = 0.08, cores = 1)
  g2 <- gos(Zn ~ Slope + Water + NDVI  + SOC + pH + Road + Mine,
            data = dt, newdata = grid, kappa = 0.08, cores = 2)
  expect_equal(g1, g2)
})
