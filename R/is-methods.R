is_generator <- function(x, y) {
  if (!inherits(x, y)) {
    stop("x must be of class '", class(x), "'", call. = FALSE)
  }
}
is.point <- function(x) is_generator(x, "geopoint")
is.multipoint <- function(x) is_generator(x, "geomultipoint")
is.linestring <- function(x) is_generator(x, "geolinestring")
is.multilinestring <- function(x) is_generator(x, "geomultilinestring")
is.polygon <- function(x) is_generator(x, "geopolygon")
is.multipolygon <- function(x) is_generator(x, "geomultipolygon")
is.feature <- function(x) is_generator(x, "geofeature")
is.featurecollection <- function(x) is_generator(x, "geofeaturecollection")
is.geometrycollection <- function(x) is_generator(x, "geogeometrycollection")
