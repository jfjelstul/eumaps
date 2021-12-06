# Joshua C. Fjelstul, Ph.D.
# eumaps R package

calculate_dimensions <- function(width, height, bounding_box) {

  # get bounding box ranges
  bounding_box_ranges <- get_bounding_box_ranges(bounding_box)

  # if height is specified, but not width, then calculate width
  if(class(height) == "numeric" & is.null(width)) {

    # get ratio of width to height
    x_to_y_ratio <- bounding_box_ranges$x / bounding_box_ranges$y

    # calculate width
    width <- height * x_to_y_ratio

    # round to nearest px
    width <- round(width)

    # if width is specified, but not height, then calculate height
  } else if(class(width) == "numeric" & is.null(height)) {

    # get ratio of height to width
    y_to_x_ratio <- bounding_box_ranges$y / bounding_box_ranges$x

    # calculate height
    height <- width * y_to_x_ratio

    # round in nearest px
    height <- round(height)

    # if height and width are specified, recalculate bounding box to match aspect ratio
  } else if(class(width) == "numeric" & class(height) == "numeric") {

    # get ratio of width to height
    x_to_y_ratio <- bounding_box_ranges$x / bounding_box_ranges$y

    # get ratio of height to width
    y_to_x_ratio <- bounding_box_ranges$y / bounding_box_ranges$x

    # get requested ratio of width to height
    requested_x_to_y_ratio <- width / height

    # get requested ratio of height to width
    requested_y_to_x_ratio <- height / width

    # if bounding box needs to be wider
    if(requested_x_to_y_ratio > x_to_y_ratio) {

      # calculate the new xrange
      new_x_range <- bounding_box_ranges$y * requested_x_to_y_ratio

      # calculate the change in the xrange
      change_x_range <- new_x_range - bounding_box_ranges$x

      # change xmin and xmax to achieve the new xrange
      bounding_box$xmin <- bounding_box$xmin - (change_x_range / 2)
      bounding_box$xmax <- bounding_box$xmax + (change_x_range / 2)
    }

    # if bounding box needs to be taller
    if(requested_y_to_x_ratio > y_to_x_ratio) {

      # calculate the new xrange
      new_y_range <- bounding_box_ranges$x * requested_y_to_x_ratio

      # calculate the change in the xrange
      change_y_range <- new_y_range - bounding_box_ranges$y

      # change xmin and xmax to achieve the new xrange
      bounding_box$ymin <- bounding_box$ymin - (change_y_range / 2)
      bounding_box$ymax <- bounding_box$ymax + (change_y_range / 2)
    }
  }

  # otherwise throw an error
  else {
    stop("Height or width incorrectly specified.")
  }

  out <- list(
    width = width,
    height = height,
    bounding_box = bounding_box
  )

  return(out)
}
