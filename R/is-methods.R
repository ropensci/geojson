is_generator <- function(x, y) {
  if (!inherits(x, y)) {
    stop("x must be of class '", class(x), "'", call. = FALSE)
  }
}
is.point <- function(x) is_generator(x, "point")
is.multipoint <- function(x) is_generator(x, "multipoint")
is.linestring <- function(x) is_generator(x, "linestring")
is.multilinestring <- function(x) is_generator(x, "multilinestring")
is.polygon <- function(x) is_generator(x, "polygon")
is.multipolygon <- function(x) is_generator(x, "multipolygon")
is.feature <- function(x) is_generator(x, "feature")
is.featurecollection <- function(x) is_generator(x, "featurecollection")
is.geometrycollection <- function(x) is_generator(x, "geometrycollection")
