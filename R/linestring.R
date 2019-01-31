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
#' tibble(a = 1:5, b = list(y))
linestring <- function(x) {
  UseMethod("linestring")
}

#' @export
linestring.default <- function(x) {
  stop("no method for ", class(x)[1L], call. = FALSE)
}

#' @export
linestring.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x("LineString", x)
  verify_names(x, c("type", "coordinates"))
  verify_class(x, "LineString")
  structure(x,
            class = c("geolinestring", "geojson"),
            coords = get_coordinates(x))
}

#' @export
print.geolinestring <- function(x, ...) {
  cat("<LineString>", "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}
