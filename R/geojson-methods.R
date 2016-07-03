#' convenience methods to get various geojson attribute information
#'
#' @export
#' @param x input
#' @param file a file name
geo_type <- function(x) {
  UseMethod("geo_type")
}

#' @export
geo_type.default <- function(x) {
  cchar(jqr::jq(unclass(x), ".type"))
}

#' @export
geo_type.geometrycollection <- function(x) {
  cchar(unclass(jqr::jq(unclass(x), ".geometries[].type")))
}

#' @export
#' @rdname geo_type
geo_pretty <- function(x) {
  jsonlite::prettify(x)
}

#' @export
#' @rdname geo_type
geo_write <- function(x, file) {
  cat(jsonlite::toJSON(jsonlite::fromJSON(x), pretty = TRUE, auto_unbox = TRUE), file = file)
}
