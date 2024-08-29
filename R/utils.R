#' @title Pipe operator
#' @description
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#' @rdname pipe
#'
#' @name %>%
#' @importFrom magrittr %>%
#' @export
#' @keywords internal
#' @usage lhs \%>\% rhs
NULL

#' Removing outliers.
#'
#' @description Function for removing outliers.
#'
#' @param x A vector of a variable
#' @param coef A number of the times of standard deviation. Default is `2.5`.
#'
#' @return Location of outliers in the vector
#'
#' @importFrom stats sd
#'
#' @examples
#' data("zn")
#' # log-transformation
#' hist(zn$Zn)
#' zn$Zn <- log(zn$Zn)
#' hist(zn$Zn)
#' # remove outliers
#' k <- rmvoutlier(zn$Zn, coef = 2.5)
#' k
#'
#' @export
#'

rmvoutlier = \(x, coef = 2.5){
  k = which((is.na(x)) |
               (x > (mean(x, na.rm = T) + coef * stats::sd(x, na.rm = T)) |
                  x < (mean(x, na.rm = T) - coef * stats::sd(x, na.rm = T))  ))
  if (length(k) > 0) {
    message("Remove ", length(k), " outlier(s)")
  } else {
    message("No outlier.")
  }
  return(k)
}
