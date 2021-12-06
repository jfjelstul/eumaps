# Joshua C. Fjelstul, Ph.D.
# eumaps R package

get_bounding_box_ranges <- function(bounding_box) {

  x <- bounding_box$xmax - bounding_box$xmin
  y <- bounding_box$ymax - bounding_box$ymin

  out <- list(
    x = x,
    y = y
  )

  return(out)
}
