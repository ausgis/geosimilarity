#' @title function for the best kappa parameter
#' @description
#' Computationally optimized function for determining the best kappa parameter for the optimal similarity
#' @references
#' Song, Y. (2022). Geographically Optimal Similarity. Mathematical Geosciences. doi: 10.1007/s11004-022-10036-8.
#'
#' @param formula A formula of GOS model.
#' @param data A data.frame or tibble of observation data.
#' @param kappa (optional) A numeric value of the percentage of observation locations
#' with high similarity to a prediction location. \eqn{kappa = 1 - tau}, where `tau` is
#' the probability parameter in quantile operator. kappa is 0.25 means that 25% of
#' observations with high similarity to a prediction location are used for modelling.
#' @param nrepeat (optional) A numeric value of the number of cross-validation training times.
#'                The default value is `10`.
#' @param nsplit (optional) The sample training set segmentation ratio,which in `(0,1)`.
#' Default is `0.5`.
#' @param cores (optional) Positive integer. If cores > 1, a `parallel` package
#' cluster with that many cores is created and used. You can also supply a cluster
#' object. Default is `1`.
#'
#' @return A list of the result of the best kappa and the computation process curve.
#' \describe{
#' \item{\code{bestkappa}}{the result of best kappa}
#' \item{\code{cvrmse}}{all RMSE calculations during cross-validation}
#' \item{\code{cvmean}}{the average RMSE corresponding to different kappa in the cross-validation process}
#' \item{\code{plot}}{the plot of rmse changes corresponding to different kappa}
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
#' # determine the best kappa
#' system.time({
#' b1 <- gos_bestkappa(Zn ~ Slope + Water + NDVI  + SOC + pH + Road + Mine,
#'                     data = dt,
#'                     kappa = c(0.01, 0.1, 1),
#'                     nrepeat = 1,
#'                     cores = 1)
#' })
#' b1$bestkappa
#' b1$plot
#'
gos_bestkappa = \(formula,data = NULL,kappa = seq(0.05,1,0.05),
                  nrepeat = 10, nsplit = 0.5, cores = 1){
  doclust = FALSE
  if (inherits(cores, "cluster")) {
    doclust = TRUE
  } else if (cores > 1) {
    doclust = TRUE
    cores = parallel::makeCluster(cores)
    on.exit(parallel::stopCluster(cores), add=TRUE)
  }

  no = nrow(data)
  formula = stats::as.formula(formula)
  namey = all.vars(formula)[1]

  calcvrmse = \(paramp){# The function is wrapped this way to use `parallel::parLapply`.
    i = paramp[[1]]
    seed = paramp[[2]]
    kappa = paramp[[3]]
    set.seed(seed)
    trainindex = sample.int(n = no,
                            size = floor(nsplit * no),
                            replace = F)
    cvtrain = data[trainindex, ]
    cvtest = data[-trainindex, ]

    g = gos(formula, data = cvtrain, newdata = cvtest,
            kappa = kappa, cores = 1)
    pred = g$pred

    cvrmse = c(kappa,CalRMSE(cvtest[[namey]], pred))
    names(cvrmse) = c('kappa','rmse')
    return(cvrmse)
  }

  paradf = data.frame("i" = seq_along(rep(kappa, times = nrepeat)),
                      "seed" = rep(c(1:nrepeat), each = length(kappa)),
                      "kappa" = rep(kappa, times = nrepeat))
  parak = split(paradf, seq_len(nrow(paradf)))

  if (doclust) {
    parallel::clusterExport(cores,c('gos','CalRMSE'))
    out_rmse = parallel::parLapply(cores,parak,calcvrmse)
    out_rmse = tibble::as_tibble(do.call(rbind, out_rmse))
  } else {
    out_rmse = purrr::map_dfr(parak,calcvrmse)
  }

  cv.out = out_rmse %>%
    dplyr::summarise(rmse = mean(rmse,na.rm = T),
                     .by = kappa)
  k = which(cv.out$rmse == min(cv.out$rmse))[1]
  best_kappa = cv.out$kappa[k]

  l1 = (max(cv.out$rmse)-min(cv.out$rmse))*0.1
  best_x = cv.out$kappa[k]
  best_y = cv.out$rmse[k]
  p1 = ggplot2::ggplot(cv.out,
                       ggplot2::aes(x = kappa, y = rmse))+
    ggplot2::geom_point()+
    ggplot2::geom_line() +
    ggrepel::geom_label_repel(data = data.frame(kappa = best_x,
                                                rmse = best_y),
                              label=as.character(best_kappa)) +
    ggplot2::scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.2)) +
    ggplot2::scale_y_continuous(limits = c(min(cv.out$rmse) - l1,
                                           max(cv.out$rmse))) +
    ggplot2::theme_bw()

  out = list("bestkappa" = best_kappa,
             "cvrmse" = out_rmse,
             "cvmean" = cv.out,
             "plot" = p1)
  return(out)
}
