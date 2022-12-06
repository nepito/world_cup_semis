return_one <- function() {
  return(solution_mexico_86[[1, 2]])
}

#' @export
read_csv <- function(path) {
  return(readr::read_csv(path, show_col_types = FALSE))
}
