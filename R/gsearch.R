#' Search geojson
#' @export
#' @examples
#' x <- "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[-99.74,32.45]},\"properties\":{}}]}"
#' x <- as.geojson(x)
#' gsearch(x, ".")
#' gsearch(x, "keys")
#'
#' library("lawn")
#' x <- lawn_data$polygons_average
#' x <- as.geojson(x)
#' gsearch(x, ".")
#' gsearch(x, "keys")
#' gsearch(x, ".[]")
#' gsearch(x, ".features")
#' gsearch(x, ".features[]")
#' gsearch(x, ".features[].type")
#' gsearch(x, ".features[].properties")
#' gsearch(x, ".features[].geometry[]")
gsearch <- function(x, y) {
  jqr::jq(unclass(x), y)
}
