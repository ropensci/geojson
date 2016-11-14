#' Pretty print geojson
#'
#' @export
#' @param x input, an object of class \code{geojson}
#' @details Wrapper around \code{\link[jsonlite]{prettify}}
#' @examples
#' geo_pretty(point('{ "type": "Point", "coordinates": [100.0, 0.0] }'))
#'
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]
#'   ]
#' }'
#' poly <- polygon(x)
#' geo_pretty(poly)
geo_pretty <- function(x) {
  UseMethod("geo_pretty")
}

#' @export
geo_pretty.default <- function(x) {
  stop("no 'geo_pretty' method for ", class(x), call. = FALSE)
}

#' @export
geo_pretty.geojson <- function(x) {
  jsonlite::prettify(x)
}
