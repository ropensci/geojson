#' feature class
#'
#' @export
#' @param x input
#' @details Feature objects:
#' \itemize{
#'  \item A feature object must have a member with the name "geometry". The value of
#'  the geometry member is a geometry object as defined above or a JSON null value.
#'  \item A feature object must have a member with the name "properties". The value
#'  of the properties member is an object (any JSON object or a JSON null value).
#'  \item If a feature has a commonly used identifier, that identifier should be
#'  included as a member of the feature object with the name "id".
#' }
#' @examples
#' # point -> feature
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' point(x) %>% feature()
#'
#' # multipoint -> feature
#' x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' multipoint(x) %>% feature()
#'
#' # linestring -> feature
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' linestring(x) %>% feature()
#'
#' # multilinestring -> feature
#' x <- '{ "type": "MultiLineString", "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
#' multilinestring(x) %>% feature()
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
feature <- function(x) {
  UseMethod("feature")
}

#' @export
feature.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
feature.feature <- function(x) x

#' @export
feature.point <- function(x) {
  feature(unclass(x))
}

#' @export
feature.multipoint <- function(x) {
  feature(unclass(x))
}

#' @export
feature.linestring <- function(x) {
  feature(unclass(x))
}

#' @export
feature.multilinestring <- function(x) {
  feature(unclass(x))
}

#' @export
feature.polygon <- function(x) {
  feature(unclass(x))
}

#' @export
feature.multipolygon <- function(x) {
  feature(unclass(x))
}

#' @export
feature.character <- function(x) {
  x <- as_feature(x)
  verify_class_(x, "Feature")
  switch_verify_names(x)
  hint_geojson(x)
  coords <- get_coordinates(x)
  structure(x, class = "feature",
            type = get_type(x),
            coords = get_coordinates(x))
}

#' @export
print.feature <- function(x, ...) {
  cat("<Feature>", "\n")
  cat("  type: ", attr(x, "type"), "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}

as_feature <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    x
  } else {
    sprintf('{ "type": "Feature", "properties": {}, "geometry": %s }', x)
  }
}
