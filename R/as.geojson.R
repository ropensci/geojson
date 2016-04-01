#' Geojson class
#' @export
#' @param x input
#' @examples
#' x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
#' as.geojson(x)
#'
#' x <- lawn_data$polygons_average
#' as.geojson(x)
as.geojson <- function(x) {
  structure(x, class = "geojson")
}

#' @export
print.geojson <- function(x, ...) {
  cat("<geojson>", "\n")
  cat("  type: ", gsub("\\\"", "", sift_client(x, ".type")), "\n")
  cat("  features (n): ", sift_client(x, ".features | length"), "\n")
  cat("  bounding box: ", bound_box(x), "\n")
  cat("  features: ", gsub("\\\"", "", sift_client(x, ".features[].type")), "\n")
  #cat(x)
}

#' @export
summary.geojson <- function(object, ...) {
  cat(x)
}
