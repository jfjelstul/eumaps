# Joshua C. Fjelstul, Ph.D.
# eumaps R package

#' Create a color palette
#'
#' @description This function creates a color palette for a map of the European
#'   Union (EU) made by `eumaps::make_map()`. It creates a object of type
#'   `eumaps.palette`, which you can pass to the `palette` argument of
#'   `make_map()`. An `eumaps.palette` object creates a mapping between a
#'   continuous variable and a color ramp with a fixed number of colors. It also
#'   defines the colors and labels to use for member states with missing data,
#'   member states where the data is not applicable, and non-member states.
#'
#'   An `eumaps.palette` object only defines the colors used for shading
#'   countries on the map. It does not define the background color (i.e., the
#'   color of the water), the color of country borders, or the color of the
#'   border around the map, These are defined using `create_theme()`, which
#'   returns an `eumaps.theme` object that you can pass to the `theme` argument
#'   of `make_map()`.
#'
#' @details This function creates a mapping between a continuous variable and a
#'   color ramp with a fixed number of colors. To make a palette, you need to
#'   provide two vectors: a vector that contains member state names and a vector
#'   that contains values corresponding to each member state to be used for
#'   shading the member states. Member state names should not be repeated. You
#'   can run `list_member_states()` to get a list of valid member state names.
#'   The function will map the values you provide to colors.
#'
#'   You also need to specify minimum and maximum data values (these values
#'   should be reasonably rounded, and all of the data points that you want to
#'   plot should fall within this range), a low color and a high color for the
#'   color ramp (there is also an optional middle color, so you can create a
#'   diverging color palette), and the number of colors in the color ramp
#'   (usually, for a choropleth map, you do not want to plot more than 10
#'   colors).
#'
#'   The number of colors in the color ramp determines the number of bins that
#'   the data will be divided into. The number of bins is always the same as the
#'   number of colors. The break points between the bins (the number of break
#'   points is always 1 less than the number of colors/bins) will be evenly
#'   spaced between the minimum and maximum data values you provide.
#'
#'   You can also use `create_palette()` to specify the colors to use for member
#'   states with missing data, for member states where the data is not
#'   applicable, and for non-member states, along with the labels to use for
#'   these three categories in the map legend. These three colors only appear in
#'   the legend when applicable. In other words, the color for missing values
#'   doesn't appear in the legend if there are no missing values, the color for
#'   member states where the data is not applicable states doesn't appear if the
#'   data is applicable to all member states, and the color for non-member
#'   states doesn't appear if non-member states are not plotted.
#'
#' @return This function returns an object of type `eumaps.palette`, which you
#'   can pass to the `palette` argument of `make_maps()`.
#'
#' @param member_states String. Required, without a default value. A vector
#'   that contains member state names. Needs to be the same length as `values`.
#'   You can run `list_member_states()` to get a list of valid member state
#'   names. Member state names should not be repeated.
#' @param values Numeric. Required, without a default value. A vector that
#'   contains values corresponding to each member state in `member_states` to be
#'   used for shading the member states. Needs to be the same length as
#'   `member_states`.
#' @param not_applicable String. Optional. A vector of member states to code as
#'   not applicable. These member states will not be shaded using the color
#'   ramp. You can run `list_member_states()` to get a list of valid member
#'   state names. The default value is `NULL`.
#' @param value_min Numeric. Required, without a default value. The value of
#'   the data that corresponds to the lower bound of the bin for the lowest
#'   color in the gradient. Should be a reasonably rounded value that is just
#'   less than the minimum value that occurs in the data.
#' @param value_max Numeric. Required, without a default value. The value of the data
#'   that corresponds to the upper bound of the bin for the highest color in the
#'   gradient. Should be a reasonably rounded value that is just greater than
#'   the maximum value that occurs in the data.
#' @param count_colors Numeric. Required, without a default value. The number of colors
#'   to use in the discrete gradient. The minimum is 2 and the maximum is 10.
#' @param color_low Color.. Required (does not have a default). The color to
#'   use for the low end of the gradient. Can be any value accepted by
#'   `convert_color()`.
#' @param color_high Color. Required, without a default value. The color to
#'   use for the high end of the gradient. Can be any value accepted by
#'   `convert_color()`.
#' @param color_mid Color. Optional. The color to use for the middle
#'   of the gradient. Specifying a value creates a diverging color palette.
#'   Usually you want this color to be white. Can be any value accepted by
#'   `convert_color()`. The default value is `NULL`.
#' @param color_missing Color. Required, with a default value. The color to
#'   use for member states with missing data. Can be any value accepted by
#'   `convert_color()`. The default value is `c(0.75, 0.75, 0.75)`.
#' @param color_not_applicable Color. Required, with a default value. The
#'   color to use for member states that are coded as not applicable. Can be any
#'   value accepted by `convert_color()`. The default value is `c(0.85, 0.85,
#'   0.85)`.
#' @param color_non_member_state Color. Required, with a default value. The
#'   color to use for non-member states. Can be any value accepted by
#'   `convert_color()`. The default value is `c(0.95, 0.95, 0.95)`.
#' @param label_missing String. Required, with a default value. The label to use in the
#'   legend for the color for member states with missing data. The default value
#'   is `Missing`.
#' @param label_not_applicable String. Required, with a default value. The label to use
#'   in the legend for the color for member states that are coded as not
#'   applicable. The default value is `Not applicable`.
#' @param label_non_member_state String. Required, with a default value. The label to
#'   use in the legend for the color for non-member states. The default value is
#'   `Not a member state`.
#'
#' @examples
#' # using the default values
#' data <- simulate_data()
#' palette <- create_palette(
#'   member_states = data$member_state,
#'   values = data$variable,
#'   value_min = 0,
#'   value_max = 1,
#'   count_colors = 8,
#'   color_low = "#3498DB",
#'   color_high = "#E74C3C",
#'   color_mid = "#FFFFFF"
#' )
#'
#' # using all options
#' data <- simulate_data()
#' palette <- create_palette(
#'   member_states = data$member_state,
#'   values = data$variable,
#'   not_applicable = NULL,
#'   value_min = 0,
#'   value_max = 1,
#'   count_colors = 8,
#'   color_low = "#3498DB",
#'   color_high = "#E74C3C",
#'   color_mid = "#FFFFFF",
#'   color_missing = c(0.75, 0.75, 0.75),
#'   color_not_applicable = c(0.85, 0.85, 0.85),
#'   color_non_member_state = c(0.95, 0.95, 0.95),
#'   label_missing = "Missing",
#'   label_not_applicable = "Not applicable",
#'   label_non_member_state = "Not a member state"
#' )
#'
#' @export
create_palette <- function(
  member_states,
  values,
  not_applicable = NULL,
  value_min,
  value_max,
  count_colors,
  color_low,
  color_high,
  color_mid = NULL,
  color_missing = c(0.75, 0.75, 0.75),
  color_not_applicable = c(0.85, 0.85, 0.85),
  color_non_member_state = c(0.95, 0.95, 0.95),
  label_missing = "Missing",
  label_not_applicable = "Not applicable",
  label_non_member_state = "Not a member state"
) {

  if (length(unique(member_states)) != length(member_states)) {
    stop("The argument 'member_states' cannot include repeated member state names. Run 'list_member_states()' to see a list of valid member state names.")
  }

  if (length(member_states) != length(values)) {
    stop("The arguments 'member_states' and 'values' need to be vectors with the same length.")
  }

  if (count_colors < 2) {
    stop("The minimum value for the argument 'count_colors' is 2.")
  }

  if (count_colors > 10) {
    stop("The maximum value for the argument 'count_colors' is 10.")
  }

  # convert colors
  color_low <- convert_color(color_low)
  color_high <- convert_color(color_high)
  color_missing <- convert_color(color_missing)
  color_not_applicable <- convert_color(color_not_applicable)
  color_non_member_state <- convert_color(color_non_member_state)

  # make a tibble
  data <- dplyr::tibble(member_state = member_states, value = values)

  # cut variable
  breaks <- seq(value_min, value_max, length.out = count_colors + 1)
  upper <- breaks[-1]
  bins <- cut(upper, breaks = breaks)
  bins <- as.character(bins)
  data$bin <- cut(data$value, breaks = breaks)

  # index
  data$index <- as.numeric(data$bin)

  # convert bin from a factor to a string
  data$bin <- as.character(data$bin)

  # make palette
  if(!is.null(color_mid)) {
    color_mid <- convert_color(color_mid)
    generate_color_ramp <- colorRampPalette(c(color_low, color_mid, color_high))
  } else {
    generate_color_ramp <- colorRampPalette(c(color_low, color_high))
  }

  # make a color ramp
  color_ramp <- generate_color_ramp(count_colors)
  for(i in 1:length(color_ramp)) {
    color_ramp[i] <- convert_color(color_ramp[i])
  }

  # select variables
  mapping <- dplyr::select(data, member_state, bin)

  # make a list
  palette <- list(
    mapping = mapping,
    not_applicable = not_applicable,
    bins = bins,
    color_ramp = color_ramp,
    color_missing = color_missing,
    color_not_applicable = color_not_applicable,
    color_non_member_state = color_non_member_state,
    label_missing = label_missing,
    label_not_applicable = label_not_applicable,
    label_non_member_state = label_non_member_state
  )

  # set class
  class(palette) <- c(class(palette), "eumaps.palette")

  return(palette)
}
