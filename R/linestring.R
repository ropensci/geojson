#' linestring class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- linestring(x))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
linestring <- function(x) {
  UseMethod("linestring")
}

#' @export
linestring.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
linestring.character <- function(x) {
  x <- as_ls(x)
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "LineString")
  hint_geojson(x)
  structure(x, class = "linestring", coords = get_coordinates(x))
}

#' @export
print.linestring <- function(x, ...) {
  cat("<LineString>", "\n")
  cat("  coordinates: ", attr(x, 'coords'), "\n")
}

as_ls <- function(x) {
  ext <- asc(jqr::jq(unclass(x), ".type"))
  if (ext == "Feature") {
    jqr::jq(unclass(x), ".geometry")
  } else if (ext == "LineString") {
    x
  } else {
    stop("type can not be '", ext, "'; must be one of 'LineString' or 'Feature'", call. = FALSE)
  }
}
