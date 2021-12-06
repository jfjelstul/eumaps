# Joshua C. Fjelstul, Ph.D.
# eumaps R package

prepare_plot_data <- function(geography, palette, inset = FALSE) {

  geometry <- dplyr::left_join(
    geography$geometry,
    palette$mapping,
    by = c("country" = "member_state")
  )

  geometry <- dplyr::rename(
    geometry,
    label = bin
  )

  geometry$label[geometry$member_state == 0] <- palette$label_non_member_state
  geometry$label[geometry$member_state == 1 & geometry$country %in% palette$not_applicable] <- palette$label_not_applicable
  geometry$label[geometry$member_state == 1 & !(geometry$country %in% palette$not_applicable) & is.na(geometry$label)] <- palette$label_missing

  geometry <- dplyr::arrange(geometry, label)

  palette$labels <- palette$bins
  palette$colors <- palette$color_ramp

  if (any(geometry$label == palette$label_missing)) {
    palette$labels <- c(palette$labels, palette$label_missing)
    palette$colors <- c(palette$colors, palette$color_missing)
  }

  if (any(geometry$label == palette$label_not_applicable)) {
    palette$labels <- c(palette$labels, palette$label_not_applicable)
    palette$colors <- c(palette$colors, palette$color_not_applicable)
  }

  if (any(geometry$label == palette$label_non_member_state)) {
    palette$labels <- c(palette$labels, palette$label_non_member_state)
    palette$colors <- c(palette$colors, palette$color_non_member_state)
  }

  geometry$label <- factor(geometry$label, levels = palette$labels)

  plot_data <- list(
    geometry = geometry,
    bounding_box = geography$bounding_box,
    colors = palette$colors
  )

  return(plot_data)
}
