#' Bounding box
#' @export
#' @param x input
#' @examples
#' library("lawn")
#' bound_box(as.geojson(lawn_data$polygons_count))
bound_box <- function(x) {
  lawn::lawn_extent(x)
}
