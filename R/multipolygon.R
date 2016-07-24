#' multipolygon class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "MultiPolygon",
#' "coordinates": [
#'   [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
#'   [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
#'   [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
#'   ]
#' }'
#' (y <- multipolygon(x))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))

multipolygon <- function(x) {
  UseMethod("multipolygon")
}

#' @export
multipolygon.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multipolygon.character <- function(x) {
  x <- as_multipoly(x)
  switch_verify_names(x)
  verify_class(x, "MultiPolygon")
  hint_geojson(x)
  no_polygons <- length(asc(jqr::jq(x, ".coordinates[] | length ")))
  coords <- get_coordinates(x)
  structure(x, class = "multipolygon",
            no_polygons = no_polygons,
            coords = coords)
}

#' @export
print.multipolygon <- function(x, ...) {
  cat("<MultiPolygon>", "\n")
  cat("  no. polygons: ", attr(x, 'no_polygons'), "\n")
  cat("  coordinates: ", attr(x, 'coords'), "\n")
}

as_multipoly <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    jqr::jq(unclass(x), ".geometry")
  } else if (asc(jqr::jq(unclass(x), ".type")) == "MultiPolygon") {
    x
  }
}