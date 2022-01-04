# Joshua C. Fjelstul, Ph.D.
# eumaps R package

#' Make an choropleth map of the EU
#'
#' @description This function is the main function of the `eumaps` package. It
#'   creates a choropleth map of the European Union (EU). It breaks down the
#'   process of making a map into three basic steps: (1) specifying the
#'   geography to plot, (2) specifying the color palette to use, and (3)
#'   specifying a theme that defines the aesthetics of the map. The `make_map()`
#'   function has three inputs, one for each step: an object created by
#'   `create_geography()` that the specifies geography to plot, an object
#'   created by `create_palette()` that specifies the color palette to use, and
#'   an object created by `create_theme()` that specifies the theme.
#'
#'   The data for the country borders comes from Natural Earth, a public domain
#'   database.
#'
#' @details The choropleth maps created by `make_map()` visually differentiate
#'   between four groups of countries: member states without missing data,
#'   member states with missing data, member states that are coded as not
#'   applicable, and non-member states.
#'
#'   Member states without missing data are shaded according to a color ramp
#'   with a fixed number of colors. Each color in the color ramp maps to a bin
#'   of values in the data. The color ramp can be linear or diverging. The
#'   legend always includes all colors in the color ramp, regardless of whether
#'   the corresponding bin actually appears in the data. That way, if you use
#'   the same palette across multiple maps, the legend stays the same.
#'
#'   The other three groups of countries (member states with missing data,
#'   member state that are coded as not applicable, and non-member states) each
#'   have their own colors (by default, shades of gray) and labels, which you
#'   can customize. These colors only appear in the legend when applicable.
#'
#'   Distinguishing between member states where the data is and is not
#'   applicable is useful in many applications. For example, if you're making a
#'   map of the Eurozone, you may only want to plot data for Eurozone members
#'   (some of which could have missing data), but still want to visually
#'   differentiate between member states that are not members of the Eurozone
#'   and countries that are not EU member states. Here, the data would not be
#'   applicable for member states that are not members of the Eurozone.
#'
#'   The `geography` input, which needs to be an object of class
#'   `eumaps.geography` created by `create_geography()`, specifies the geography
#'   to plot. The appropriate geography to plot is influenced by which countries
#'   are member states on the date of the data, whether the map should center on
#'   a subset of member states, the aspect ratio of the map, how zoomed out the
#'   map should be, whether the map should include non-member states, whether
#'   there should be insets for some member states, and whether the map should
#'   use high or low resolution border data.
#'
#'   The `palette` input, which needs to be an object of class `eumaps.palette`
#'   created by `create_palette()`, specifies a mapping between a continuous
#'   variable and a color ramp with a fixed number of colors. It also specifies
#'   the colors and labels to use for member states with missing data, for
#'   member states where the data is not applicable, and for non-member states.
#'
#'   The `theme` input, which needs to be an object of class `eumaps.theme`
#'   created by `create_theme()`, specifies the aesthetics of the map, including
#'   the style of the map border, the country borders, the title, the legend,
#'   and any insets.
#'
#' @return This function returns a standard `ggplot` object.
#'
#' @param geography An object of class `eumaps.geography` created by the
#'   function `create_geography()`. Required, and does not have a default value.
#'   See the documentation for `create_geography()`.
#' @param palette An object of class `eumaps.palette` created by the function
#'   `create_palette()`. Required, and does not have a default value. See the
#'   documentation for `create_palette()`.
#' @param theme An object of class `eumaps.theme` created by the function
#'   `create_theme()`. Required, and does not have a default value. See the
#'   documentation for `create_theme()`.
#' @param title String. Optional. The title of the map. The default value is
#'   `NULL`.
#'
#' @examples
#' # simulate data
#' data <- simulate_data()
#'
#' # create the geography using the default values
#' geography <- create_geography()
#'
#' # create the palette using the default values
#' palette <- create_palette(
#'   member_states = data$member_state,
#'   values = data$value,
#'   value_min = 0,
#'   value_max = 1,
#'   count_colors = 8,
#'   color_low = "#E74C3C",
#'   color_high = "#3498DB",
#'   color_mid = "#FFFFFF"
#' )
#'
#' # create the theme using the default values
#' theme <- create_theme()
#'
#' # make the map
#' map <- make_map(
#'   geography = geography,
#'   palette = palette,
#'   theme = theme
#' )
#'
#' @export
make_map <- function(geography, palette, theme, title = NULL) {

  if (!("eumaps.geography" %in% class(geography))) {
    stop("The argument 'geography' must be an object of class 'eumaps.geography' created by the function 'create_geography()'.")
  }

  if (!("eumaps.palette" %in% class(palette))) {
    stop("The argument 'palette' must be an object of class 'eumaps.palette' created by the function 'create_palette()'.")
  }

  if (!("eumaps.theme" %in% class(theme))) {
    stop("The argument 'theme' must be an object of class 'eumaps.theme' created by the function 'create_theme()'.")
  }

  plot_data <- prepare_plot_data(geography, palette)

  map <- ggplot2::ggplot() +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf, fill = theme$color_map_background) +
    ggplot2::geom_sf(data = plot_data$geometry, ggplot2::aes(fill = label, geometry = geometry), size = theme$width_country_borders, color = theme$color_country_borders) +
    ggplot2::scale_fill_manual(values = plot_data$colors, guide = "legend", name = NULL, drop = FALSE) +
    ggplot2::guides(fill = ggplot2::guide_legend(byrow = TRUE)) +
    ggplot2::scale_x_continuous(limits = c(plot_data$bounding_box$xmin, plot_data$bounding_box$xmax), expand = c(0, 0)) +
    ggplot2::scale_y_continuous(limits = c(plot_data$bounding_box$ymin, plot_data$bounding_box$ymax), expand = c(0, 0)) +
    ggplot2::theme_void() +
    ggplot2::ggtitle(title) +
    ggplot2::theme(
      legend.position = "right",
      legend.key = ggplot2::element_blank(),
      legend.box.margin = ggplot2::margin(t = 0, r = 0, b = 0, l = theme$space_before_legend),
      legend.key.size = ggplot2::unit(theme$size_legend_keys, "pt"),
      legend.text = ggplot2::element_text(size = theme$size_legend_labels),
      legend.spacing.x = ggplot2::unit(theme$space_before_legend_labels, "pt"),
      legend.spacing.y = ggplot2::unit(theme$space_between_legend_keys, "pt"),
      plot.background = ggplot2::element_rect(fill = "white", color = "white"),
      plot.margin = ggplot2::margin(t = theme$space_around_map, r = theme$space_around_map, b = theme$space_around_map, l = theme$space_around_map),
      plot.title = ggplot2::element_text(size = theme$title_text_size, margin = ggplot2::margin(b = theme$space_under_title)),
      panel.background = ggplot2::element_rect(size = theme$width_map_border, fill = NA, color = theme$color_map_border),
      panel.ontop = TRUE
    )

  if (length(geography$options$insets) > 0) {

    scale <- 1 / geography$options$aspect_ratio

    padding_right <- 1 - (theme$space_between_insets * scale)
    padding_left <- 1 - ((theme$space_between_insets + theme$size_insets) * scale)

    for (i in 1:length(geography$options$insets)) {

      valid <- geography$geometry$country[geography$geometry$member_state == 1 & geography$geometry$subset == 1]

      if (geography$options$insets[i] %in% valid) {

        geography_inset <- create_geography(
          subset = geography$options$insets[i],
          aspect_ratio = 1,
          zoom = 0.5,
          show_non_member_states = geography$options$show_non_member_states
        )

        plot_data_inset <- prepare_plot_data(geography_inset, palette, inset = TRUE)

        inset <- ggplot2::ggplot() +
          ggplot2::geom_sf(data = plot_data_inset$geometry, ggplot2::aes(fill = label, geometry = geometry), size = theme$width_country_borders, color = theme$color_country_borders) +
          ggplot2::scale_fill_manual(values = plot_data_inset$colors, guide = "none", name = NULL, drop = FALSE) +
          ggplot2::scale_x_continuous(limits = c(plot_data_inset$bounding_box$xmin, plot_data_inset$bounding_box$xmax), expand = c(0, 0)) +
          ggplot2::scale_y_continuous(limits = c(plot_data_inset$bounding_box$ymin, plot_data_inset$bounding_box$ymax), expand = c(0, 0)) +
          ggplot2::theme_void() +
          ggplot2::theme(
            plot.margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0),
            plot.background = ggplot2::element_rect(fill = "white"),
            panel.background = ggplot2::element_rect(size = theme$width_map_border, fill = NA, color = theme$color_map_border),
            panel.ontop = TRUE
          )

        map <- map + patchwork::inset_element(inset, left = padding_left, right = padding_right, top = 1 - theme$space_between_insets - (i - 1) * (theme$space_between_insets + theme$size_insets), bottom = 1 - i * (theme$space_between_insets + theme$size_insets), align_to = "panel")
      }
    }
  }

  return(map)
}
