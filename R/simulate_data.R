# Joshua C. Fjelstul, Ph.D.
# eumaps R package

#' Simulate map data
#'
#' @description This function simulates data for a map of the European Union
#'   (EU) made by `eumaps::make_map()`. The data is drawn from a standard
#'   uniform distribution. It creates a tibble. You can pass the column
#'   `member_state` to the `member_states` argument of `create_palette()` and
#'   the column `value` to the `values` argument of `create_palette()`.
#'
#' @return This function returns a `tibble` with 3 columns: `member_state_id`,
#'   `member_state`, and `value`.
#'
#' @param date String or date. Optional. If not `NULL`, data will only be
#'   simulated for countries that were member states on this date. If not
#'   `NULL`, today's date is used, and data will only be simulated for current
#'   member states. The default value is `NULL`.
#' @param missing String. Optional. A vector of member states names. The data
#'   for these member states will be coded as `NA`. This is option is useful for
#'   testing out color palettes. The default value is `NULL`.
#'
#' @examples
#' # using the default values
#' data <- simulate_data()
#'
#' # using all options
#' data <- simulate_data(
#'   date = "2015-01-01",
#'   missing = c("France", "Germany")
#' )
#'
#' @export
simulate_data <- function(date = NULL, missing = NULL) {
  if (is.null(date)) {
    date <- Sys.Date()
  }
  data <- make_template(date)
  data$value <- runif(n = nrow(data), min = 0, max = 1)
  data$value[data$member_state %in% missing] <- NA
  data <- dplyr::select(data, member_state_id, member_state, value)
  return(data)
}
