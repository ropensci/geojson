#' Search geojson
#' @export
#' @examples
#' x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
#' x <- as.geojson(x)
#' library("lawn")
#' lawn_data$points_within %>% view
#' overlay(lawn_data$points_within, lawn_data$polygons_within) %>% view
overlay <- function(points, polygons) {
  lawn::lawn_within(points, polygons)
}
