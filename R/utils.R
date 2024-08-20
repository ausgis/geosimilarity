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

#' @title Calculate RMSE
#' @noRd
CalRMSE = \(yobse,ypred){
  return(sqrt(mean((yobse-ypred)^2)))
}
