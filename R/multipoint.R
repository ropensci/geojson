#' multipoint class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- multipoint(x))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
multipoint <- function(x) {
  UseMethod("multipoint")
}

#' @export
multipoint.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multipoint.character <- function(x) {
  x <- as_mpt(x)
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "MultiPoint")
  hint_geojson(x)
  structure(x, class = "multipoint", coords = cchar(jqr::jq(unclass(x), ".coordinates")))
}

#' @export
print.multipoint <- function(x, ...) {
  cat("<MultiPoint>", "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}

as_mpt <- function(x) {
  ext <- asc(jqr::jq(unclass(x), ".type"))
  if (ext == "Feature") {
    jqr::jq(unclass(x), ".geometry")
  } else if (ext == "MultiPoint") {
    x
  } else {
    stop("type can not be '", ext, "'; must be one of 'MultiPoint' or 'Feature'", call. = FALSE)
  }
}
