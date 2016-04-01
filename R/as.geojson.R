#' Geojson class
#' @export
#' @examples
#' x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
#' as.geojson(x)
as.geojson <- function(x) {
  structure(x, class = "geojson")
}

#' @export
print.geojson <- function(x) {
  cat(x)
}
