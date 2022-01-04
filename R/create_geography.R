# Joshua C. Fjelstul, Ph.D.
# eumaps R package

#' Create geography
#'
#' @description This function creates the geography for a map of the European
#'   Union (EU) made by `eumaps::make_map()`. It creates a object of type
#'   `eumaps.geography`, which you can pass to the `geography` argument of
#'   `make_maps()`.
#'
#'   `create_geography()` will automatically center the map on all countries
#'   that are member states on the date indicated by the argument `date`. This
#'   way, you never have to specify the bounds of the map, which can be
#'   complicated. You also don't have to know the accession dates of the member
#'   states. By default, `date` is set to today's date. You can use the optional
#'   argument `subset` to center the map on a subset of member states.
#'
#'   You can use `create_geography()` to set a variety of other options that
#'   make it easy to make the map look exactly how you want.
#'
#'   First, you can use the argument `aspect_ratio` to specify the aspect ratio
#'   of the map. A value greater than `1` makes a map that is wider than it is
#'   tall and a value less than `1` makes a map that is taller than it is wide.
#'   The minimum value is `0.5` and the maximum value is `2`.
#'
#'   Second, you can use `zoom` to choose a zoom factor. A value of `1` focuses
#'   the map tightly around the selected member states, and values less than `1`
#'   zoom out the map. The minimum value is `0.5`. The default is `0.9`.
#'
#'   Third, you can use `show_non_member_states` to choose whether or not to
#'   plot non-member states. The default value is `TRUE`.
#'
#'   Fourth, you can use `insets` to create insets for member states whose
#'   values would be hard to read otherwise. By default, `insets` equals `NULL`,
#'   in which case no insets are created. You can provide a vector of member
#'   state names to create insets for those member states. You can create insets
#'   for Luxembourg, Malta, and Cyprus. The insets will appear in the top right
#'   corner of the map in the order given by the vector.
#'
#'   Fifth, you can use `resolution` to choose between low or high resolution
#'   border data. The default value is `high` and the alternative is `low`. The
#'   map will take longer to render if you use the high resolution data. The
#'   function always uses high resolution border data for the insets.
#'
#' @return This function returns an object of type `eumaps.geography`, which you
#'   can pass to the `geography` argument of `make_maps()`.
#'
#' @param date String or date. Required, and has a default value. The date of
#'   the data. If a string, needs to have the format `YYYY-MM-DD`. The default
#'   is today's date.
#' @param subset String. Optional. A vector of member state names. The map will
#'   be centered on these member states. If `NULL`, the map will be centered on
#'   all member states. Any countries in the vector that aren't member states on
#'   the date indicated by `date` will be ignored. The default value is `NULL`.
#' @param aspect_ratio Numeric. Optional. The aspect ratio of the map. The
#'   minimum value is `0.5` and the maximum value is `2`. If `NULL`, the aspect
#'   ratio will be determined by the bounding box surrounding the selected
#'   member states. The default value is `NULL`.
#' @param zoom Numeric. Required, and has a default value. The zoom factor. A
#'   value of `1` focuses the map tightly around the selected member states, and
#'   values less than `1` zoom out the map. The minimum value is `0.5` and the
#'   maximum value is `1`. The default value is `0.9`.
#' @param show_non_member_states Logical. Required, and has a default value.
#'   Whether or not to plot non-member states. The default value is `TRUE`.
#' @param insets String. Optional. A vector of member states to create insets
#'   for. Possible values include `Luxembourg`, `Cyprus`, and `Malta`. Other
#'   countries will be ignored. If `NULL`, no insets are created. The default
#'   value is `NULL`.
#' @param resolution String. Required, and has a default value. The resolution
#'   to use for the border data. The possible values are `high` and `low`. The
#'   default is `high`.
#'
#' @examples
#' # using the default values
#' geography <- create_geography()
#'
#' # using all options
#' create_geography <- function(
#'   date = Sys.Date(),
#'   subset = NULL,
#'   aspect_ratio = NULL,
#'   zoom = 0.9,
#'   show_non_member_states = TRUE,
#'   insets = NULL,
#'   resolution = "high"
#' )
#'
#' @export
create_geography <- function(
  date = Sys.Date(),
  subset = NULL,
  aspect_ratio = NULL,
  zoom = 0.9,
  show_non_member_states = TRUE,
  insets = NULL,
  resolution = "high"
) {

  # validate 'insets'
  if (length(intersect(insets, member_states$member_state)) != length(insets)) {
    stop("The argument 'insets' should be a vector of member state names. Run list_member_states() to see the valid values.")
  }

  # convert the projection string into an ESRI or EPSG code
  projection <- "EPSG:3035"
  # projection <- switch(
  #   projection,
  #   "equidistant_conic" = "ESRI:102031",
  #   "lambert_conformal_conic" = "EPSG:3034",
  #   "albers_equal_area_conic" = "ESRI:102013",
  #   "lambert_azimuthal_equal_area" = "EPSG:3035",
  #   "mercator" = "EPSG:3395"
  # )

  # select geographic data
  if(resolution == "high") {
    geometry <- high_res_data
  } else if (resolution == "low"){
    geometry <- low_res_data
  } else {
    stop("The 'resolution' argument should be 'high' or 'low'.")
  }

  # apply projection
  geometry <- sf::st_transform(geometry, crs = projection)

  # make the template
  template <- make_template(date)
  if(!is.null(subset)) {
    bounding_box_sample <- make_template(date, subset)
  } else {
    bounding_box_sample <- template
  }

  # bounding box data
  geometry_bounding_box <- dplyr::filter(
    geometry,
    outlying == 0 & country %in% bounding_box_sample$member_state
  )
  geometry_bounding_box <- sf::st_as_sf(geometry_bounding_box)

  # make bounding box
  bounding_box <- create_bounding_box(geometry_bounding_box)

  # expand bounding box
  bounding_box <- expand_bounding_box(margin = 1 - zoom, height = NULL, width = 1, bounding_box = bounding_box)

  # if an aspect ratio is specified, adjust the bounding box
  if(!is.null(aspect_ratio)) {

    # adjust bounding box
    dimensions <- calculate_dimensions(height = 1, width = aspect_ratio, bounding_box = bounding_box)

    # new bounding box
    bounding_box <- dimensions$bounding_box
  }

  # if aspect ratio is not specified
  if (is.null(aspect_ratio)) {
    aspect_ratio <- (bounding_box$xmax - bounding_box$xmin) / (bounding_box$ymax - bounding_box$ymin)
  }

  # clip geometry based on the bounding box
  geometry <- run_quietly(sf::st_crop(sf::st_buffer(geometry, 0), xmin = bounding_box$xmin, ymin = bounding_box$ymin, xmax = bounding_box$xmax, ymax = bounding_box$ymax))
  geometry <- dplyr::select(
    geometry,
    country, outlying, geometry
  )

  # code which geometry observations are for a member state
  geometry$member_state <- as.numeric(geometry$country %in% template$member_state & geometry$outlying == 0)

  # code which geometry observations are for member states in the subset
  if(!is.null(subset)) {
    geometry$subset <- as.numeric(geometry$country %in% subset)
  } else {
    geometry$subset <- as.numeric(geometry$member_state == 1)
  }

  if (show_non_member_states == FALSE) {
    geometry <- dplyr::filter(geometry, member_state == 1)
  }

  # select variables
  geometry <- dplyr::select(
    geometry,
    country, member_state, subset, geometry
  )

  # make a list of options
  options <- list(
    subset = subset,
    aspect_ratio = aspect_ratio,
    show_non_member_states = show_non_member_states,
    insets = insets
  )

  # make output list
  geography <- list(
    geometry = geometry,
    bounding_box = bounding_box,
    options = options
  )

  # set class
  class(geography) <- c(class(geography), "eumaps.geography")

  return(geography)
}
