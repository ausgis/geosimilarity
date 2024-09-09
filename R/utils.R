#' @title Pipe operator
#' @description
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @usage lhs \%>\% rhs
#' @rdname pipe
#' @keywords internal
#' @importFrom magrittr %>%
#' @return `NULL` (this is the magrittr pipe operator)
#' @export
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
#' @examples
#' data("zn")
#' # log-transformation
#' hist(zn$Zn)
#' zn$Zn <- log(zn$Zn)
#' hist(zn$Zn)
#' # remove outliers
#' k <- removeoutlier(zn$Zn, coef = 2.5)
#' k
#'
#' @export
#'
removeoutlier = \(x, coef = 2.5){
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
