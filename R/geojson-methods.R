#' @export
geo_type <- function(x) {
  UseMethod("geo_type")
}

geo_type.default <- function(x) {
  cchar(jqr::jq(unclass(x), ".type"))
}

geo_type.geometrycollection <- function(x) {
  cchar(unclass(jqr::jq(unclass(x), ".geometries[].type")))
}

#' @export
geo_pretty <- function(x) {
  jsonlite::prettify(x)
}

#' @export
geo_write <- function(x, file) {
  cat(jsonlite::toJSON(jsonlite::fromJSON(x), pretty = TRUE, auto_unbox = TRUE), file = file)
}
