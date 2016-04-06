pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

verify_names <- function(x, nms) {
  keys <- strsplit(gsub("\\\"|\\[|\\]", "", unclass(jqr::jq(unclass(x), "keys"))), ",")[[1]]
  if (!all(nms %in% keys)) stop("keys not correct", call. = FALSE)
}

verify_class <- function(x, clss) {
  cl <- cchar(jqr::jq(unclass(x), ".type"))
  if (cl != clss) stop("object is not of type ", clss, call. = FALSE)
}

hint <- function(x) geojsonlint::geojson_hint(x) == "valid"

hint_geojson <- function(x) {
  if (!hint(x)) stop("object not proper GeoJSON", call. = FALSE)
}

cchar <- function(x) {
  gsub("\"", "", as.character(x))
}
