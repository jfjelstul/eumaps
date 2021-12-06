# Joshua C. Fjelstul, Ph.D.
# eumaps R package

create_bounding_box <- function(data) {

  bounding_box <- sf::st_bbox(data)

  bounding_box_data <- sf::st_as_sfc(bounding_box)

  matrix <- bounding_box_data[[1]][[1]]
  xmin <- min(matrix[,1])
  xmax <- max(matrix[,1])
  ymin <- min(matrix[,2])
  ymax <- max(matrix[,2])

  out <- list(
    xmin = xmin,
    xmax = xmax,
    ymin = ymin,
    ymax = ymax
  )

  return(out)
}
