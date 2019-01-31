#' Get geometry type
#'
#' @export
#' @param x input, an object of class \code{geojson}
#' @examples
#' geo_type(point('{ "type": "Point", "coordinates": [100.0, 0.0] }'))
#'
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]
#'   ]
#' }'
#' poly <- polygon(x)
#'
#' geo_type(poly)
geo_type <- function(x) {
  UseMethod("geo_type")
}

#' @export
geo_type.default <- function(x) {
  stop("no 'geo_type' method for ", class(x)[1L], call. = FALSE)
}

#' @export
geo_type.geojson <- function(x) {
  cchar(jqr::jq(unclass(x), ".type"))
}

#' @export
geo_type.geometrycollection <- function(x) {
  cchar(unclass(jqr::jq(unclass(x), ".geometries[].type")))
}
