#' Overlay
#' @export
#' @param points geojson points
#' @param polygons geojson polygons
#' @examples
#' library("lawn")
#' lawn_data$points_within %>% view
#' overlay(lawn_data$points_within, lawn_data$polygons_within) %>% view
overlay <- function(points, polygons) {
  lawn::lawn_within(points, polygons)
}
