# Joshua C. Fjelstul, Ph.D.
# eumaps R package

#' Create a theme
#'
#' @description This function creates a theme for a map of the European Union
#'   (EU) made by `eumaps::make_map()`. It creates an object of class
#'   `eumaps.theme`, which you can pass to the `theme` argument of `make_map()`.
#'   An `eumaps.theme` object defines the aesthetics of the map, including the
#'   style of the map border, the country borders, the title, the legend, and
#'   any insets.
#'
#' @return This function returns an object of class `eumaps.theme`, which you
#'   can pass to the `theme` argument of `make_maps()`.
#'
#' @param color_map_background Color. Required, and has a default value. The
#'   color of the background of the map (i.e., the color of the water). Can be
#'   any value accepted by `convert_color()`. The default value is `#FFFFFFFF`.
#' @param color_map_border Color. Required, and has a default value. The color
#'   of the border around the map. Can be any value accepted by
#'   `convert_color()`. The default value is `#000000FF`.
#' @param width_map_border Numeric. Required, and has a default value. The width
#'   of the border around the map in px. The default value is `1`.
#' @param space_around_map Numeric. Required, and has a default value. The space
#'   between the border around the map and the edge of the plot in px.  The
#'   default value is `16`.
#' @param color_country_borders Color. Required, and has a default value. The
#'   color of the country borders. Can be any value accepted by
#'   `convert_color()`. The default value is `#000000FF`.
#' @param width_country_borders Numeric. Required, and has a default value. The
#'   width of the country borders in px. The default value is `0.25`.
#' @param size_title Numeric. Required, and has a default value. The size of the
#'   title of the map in points.  The default value is `16`.
#' @param space_under_title Numeric. Required, and has a default value. The
#'   vertical space between the bottom of the map title and the top of the
#'   border around the map in px.  The default value is `8`.
#' @param size_legend_keys Numeric. Required, and has a default value. The size
#'   of the legend keys in px. This value is for both the horizontal and
#'   vertical size of the keys. The default value is `18`.
#' @param space_before_legend Numeric. Required, and has a default value. The
#'   horizontal space between the right border of the map and the legend in px.
#'   The default value is `16`.
#' @param space_between_legend_keys Numeric. Required, and has a default value.
#'   The vertical space between legend keys in px. The default value is `8`.
#' @param size_legend_labels Numeric. Required, and has a default value. The
#'   size of the labels of the legend keys in points. The default value is `10`.
#' @param space_before_legend_labels Numeric. Required, and has a default value.
#'   The horizontal space between the right side of the legend keys and the
#'   labels of the keys in px. The default value is `8`.
#' @param size_insets Numeric. Required, and has a default value. The size of
#'   the insets as a percentage of the height of the map. This value is for both
#'   the horizontal and vertical size of the insets. Values between `0.15` and
#'   `0.2` usually look good. The default value is `0.15`.
#' @param space_between_insets Numeric. Required, and has a default value. The
#'   vertical space between insets (and between the column of insets and the
#'   right border of the map) as a percentage of the height of the map. Values
#'   between `0.03` and `0.04` usually look good. The default value is `0.03`.
#'
#' @examples
#' # using the default values
#' theme <- create_theme()
#'
#' # using all options
#' theme <- create_theme(
#'   color_map_background = c(1, 1, 1),
#'   color_map_border = c(0, 0, 0),
#'   width_map_border = 1,
#'   space_around_map = 16,
#'   color_country_borders = c(0, 0, 0),
#'   width_country_borders = 0.25,
#'   size_title = 16,
#'   space_under_title = 8,
#'   size_legend_keys = 18,
#'   space_before_legend = 16,
#'   space_between_legend_keys = 8,
#'   size_legend_labels = 10,
#'   space_before_legend_labels = 8,
#'   size_insets = 0.15,
#'   space_between_insets = 0.03
#' )
#'
#' @export
create_theme <- function(
  color_map_background = c(1, 1, 1),
  color_map_border = c(0, 0, 0),
  width_map_border = 1,
  space_around_map = 16,
  color_country_borders = c(0, 0, 0),
  width_country_borders = 0.25,
  size_title = 16,
  space_under_title = 8,
  size_legend_keys = 22,
  space_before_legend = 16,
  space_between_legend_keys = 8,
  size_legend_labels = 10,
  space_before_legend_labels = 8,
  size_insets = 0.15,
  space_between_insets = 0.03
) {

  # convert colors
  color_map_background <- convert_color(color_map_background)
  color_map_border <- convert_color(color_map_border)
  color_country_borders <- convert_color(color_country_borders)

  # make output object
  theme <- list(

    # formatting
    color_map_background = color_map_background,
    color_map_border = color_map_border,
    width_map_border = width_map_border,
    space_around_map = space_around_map,

    # country borders
    color_country_borders = color_country_borders,
    width_country_borders = width_country_borders,

    # title
    size_title = size_title,
    space_under_title = space_under_title,

    # legend
    size_legend_keys = size_legend_keys,
    space_before_legend = space_before_legend,
    space_between_legend_keys = space_between_legend_keys,
    size_legend_labels = size_legend_labels,
    space_before_legend_labels = space_before_legend_labels,

    # insets
    size_insets = size_insets,
    space_between_insets = space_between_insets
  )

  # add class
  class(theme) <- c(class(theme), "eumaps.theme")

  return(theme)
}
