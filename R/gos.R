#' @title geographically optimal similarity
#' @description
#' Computationally optimized function for geographically optimal similarity (GOS) model
#' @references
#' Song, Y. (2022). Geographically Optimal Similarity. Mathematical Geosciences. doi: 10.1007/s11004-022-10036-8.
#'
#' @param formula A formula of GOS model.
#' @param data A data.frame or tibble of observation data.
#' @param newdata A data.frame or tibble of prediction variables data.
#' @param kappa (optional) A numeric value of the percentage of observation locations
#' with high similarity to a prediction location. \eqn{kappa = 1 - tau}, where `tau` is
#' the probability parameter in quantile operator. The default kappa is 0.25, meaning
#' that 25% of observations with high similarity to a prediction location are used for
#' modelling.
#' @param cores (optional) Positive integer. If cores > 1, a `parallel` package
#' cluster with that many cores is created and used. You can also supply a cluster
#' object. Default is `1`.
#'
#' @return A tibble made up of predictions and uncertainties.
#' \describe{
#' \item{\code{pred}}{GOS model prediction results}
#' \item{\code{uncertainty90}}{uncertainty under 0.9 quantile}
#' \item{\code{uncertainty95}}{uncertainty under 0.95 quantile}
#' \item{\code{uncertainty99}}{uncertainty under 0.99 quantile}
#' \item{\code{uncertainty99.5}}{uncertainty under 0.995 quantile}
#' \item{\code{uncertainty99.9}}{uncertainty under 0.999 quantile}
#' \item{\code{uncertainty100}}{uncertainty under 1 quantile}
#' }
#' @export
#'
#' @examples
#' data("zn")
#' # log-transformation
#' hist(zn$Zn)
#' zn$Zn <- log(zn$Zn)
#' hist(zn$Zn)
#' # remove outliers
#' library(SecDim)
#' k <- rmvoutlier(zn$Zn, coef = 2.5)
#' dt <- zn[-k,]
#' # split data for validation: 70% training; 30% testing
#' split <- sample(1:nrow(dt), round(nrow(dt)*0.7))
#' train <- dt[split,]
#' test <- dt[-split,]
#' system.time({
#' g1 <- gos(Zn ~ Slope + Water + NDVI  + SOC + pH + Road + Mine,
#'           data = train, newdata = test, kappa = 0.25, cores = 1)
#' })
#' test$pred <- g1$pred
#' plot(test$Zn, test$pred)
#' cor(test$Zn, test$pred)
#'
gos = \(formula, data = NULL, newdata = NULL, kappa = 0.25, cores = 1){
  doclust = FALSE
  tau = 1 - kappa
  formula = stats::as.formula(formula)
  formula.vars = all.vars(formula)
  response = data[, formula.vars[1], drop = TRUE]
  no = nrow(data)
  np = nrow(newdata)
  nv = ifelse(formula.vars[2] == ".", ncol(data) - 1, length(formula.vars) - 1)

  if (formula.vars[2] == "."){
    obs_explanatory = data[,-which(colnames(data) == formula.vars[1])]
    pred_explanatory = newdata[,-which(colnames(newdata) == formula.vars[1])]
  } else {
    obs_explanatory = subset(data, TRUE, match(formula.vars[-1], colnames(data)))
    pred_explanatory = subset(newdata, TRUE, match(formula.vars[-1], colnames(newdata)))
  }

  if (inherits(cores, "cluster")) {
    doclust = TRUE
  } else if (cores > 1) {
    doclust = TRUE
    cores = parallel::makeCluster(cores)
    on.exit(parallel::stopCluster(cores), add=TRUE)
  }

  Ej = function(xobs, xp1, snp, sdv){
    sdj = sqrt(sum((xp1 - xobs)^2)/snp)
    ej = exp(-(xp1 - xobs)^2/(2*(sdv*sdv/sdj)^2))
    return(ej)
  }

  obs_explanatory = as.matrix(obs_explanatory)
  pred_explanatory = as.matrix(pred_explanatory)
  xall = rbind(obs_explanatory, pred_explanatory)
  sdv = sapply(1:nv, \(x) stats::sd(xall[,x]))

  calculgos = \(u){
    xpredvalues = pred_explanatory[u,]
    ej1 = lapply(1:nv, \(x) Ej(obs_explanatory[,x], xpredvalues[x], np, sdv[x]))
    ej = do.call(pmin, ej1)
    k = which(ej >= stats::quantile(ej, tau))
    ej2 = ej[k]

    c(sum(response[k] * ej2) / sum(ej2),
      1 - stats::quantile(ej2, 0.9),
      1 - stats::quantile(ej2, 0.95),
      1 - stats::quantile(ej2, 0.99),
      1 - stats::quantile(ej2, 0.995),
      1 - stats::quantile(ej2, 0.999),
      1 - stats::quantile(ej2, 1)) -> pred_unce
    names(pred_unce) = c('pred',paste0('uncertainty',
                                       c(90, 95, 99, 99.5, 99.9, 100)))
    return(pred_unce)
  }

  if (doclust) {
    out = parallel::parLapply(cores, 1:np, calculgos)
    out = tibble::as_tibble(do.call(rbind, out))
  } else {
    out = purrr::map_dfr(1:np,calculgos)
  }

  return(out)
}
