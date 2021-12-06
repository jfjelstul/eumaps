# Joshua C. Fjelstul, Ph.D.
# eumaps R package

#' List member states
#'
#' @description This function lists all current and former European Union (EU)
#'   member states. These are the values that are accepted by the `eumaps`
#'   package.
#'
#' @return This function returns a `tibble` with 2 columns: `member_state_id`
#'   and `member_state`.
#'
#' @examples
#' # get a list of all current and former member states
#' list_member_states()
#'
#' @export
list_member_states <- function() {
  dplyr::select(member_states, member_state_id, member_state)
}
