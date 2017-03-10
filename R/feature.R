#' feature class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geofeature and either geojson (string input),
#' or geo_list (list input)
#' @details Feature objects:
#' \itemize{
#'  \item A feature object must have a member with the name "geometry". The
#'  value of the geometry member is a geometry object as defined above or a
#'  JSON null value.
#'  \item A feature object must have a member with the name "properties". The
#'  value of the properties member is an object (any JSON object or a JSON
#'  null value).
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
#' x <- '{ "type": "MultiLineString",
#'  "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
#' multilinestring(x) %>% feature()
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(multilinestring(x)))
#'
#' # from a list
#' x <- list(type = "MultiPoint", coordinates =
#'   matrix(c(100.0, 101.0, 0.0, 1.0), ncol = 2))
#' multipoint(x) %>% feature()
feature <- function(x) {
  UseMethod("feature")
}

#' @export
feature.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
feature.geofeature <- function(x) x

#' @export
feature.geopoint <- function(x) {
  feature(unclass(x))
}

#' @export
feature.geomultipoint <- function(x) {
  feature(unclass(x))
}

#' @export
feature.geolinestring <- function(x) {
  feature(unclass(x))
}

#' @export
feature.geomultilinestring <- function(x) {
  feature(unclass(x))
}

#' @export
feature.geopolygon <- function(x) {
  feature(unclass(x))
}

#' @export
feature.geomultipolygon <- function(x) {
  feature(unclass(x))
}

#' @export
feature.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_feature(x)
  verify_class_(x, "Feature")
  switch_verify_names(x)
  type <- get_type(x)
  coords <- get_coordinates(x)
  structure(x, class = c("geofeature", "geojson"),
            type = type,
            coords = coords)
}

#' @export
feature.geo_list <- function(x) {
  #hint_geojson(x)
  x <- as_feature(x)
  verify_class_(x, "Feature")
  switch_verify_names(x)
  type <- get_type(x)
  coords <- get_coordinates(x)
  structure(x, class = c("geofeature", "geo_list"),
            type = type,
            coords = coords)
}

#' @export
feature.list <- feature.geo_list

#' @export
print.geofeature <- function(x, ...) {
  cat("<Feature>", "\n")
  cat("  type: ", attr(x, "type"), "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}

as_feature <- function(x) UseMethod("as_feature")
as_feature.character <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    return(x)
  } else {
    return(sprintf('{ "type": "Feature", "properties": {}, "geometry": %s }', x))
  }
}
as_feature.list <- function(x) {
  if (unclass(x)[["type"]] == "Feature") {
    return(x)
  } else {
    return(list(type = "Feature", properties = c(), geometry = x))
  }
}
