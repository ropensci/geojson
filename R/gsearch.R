#' Search geojson
#' @export
#' @examples
#' x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
#' x <- as.geojson(x)
#' gsearch(x, ".")
gsearch <- function(x, y) {
  jqr::jq(unclass(x), y)
}
