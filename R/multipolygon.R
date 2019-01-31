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
#' tibble(a = 1:5, b = list(y))

multipolygon <- function(x) {
  UseMethod("multipolygon")
}

#' @export
multipolygon.default <- function(x) {
  stop("no method for ", class(x)[1L], call. = FALSE)
}

#' @export
multipolygon.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x("MultiPolygon", x)
  switch_verify_names(x)
  verify_class(x, "MultiPolygon")
  no_polygons <- length(asc(jqr::jq(x, ".coordinates[] | length ")))
  coords <- get_coordinates(x)
  structure(x, class = c("geomultipolygon", "geojson"),
            no_polygons = no_polygons,
            coords = coords)
}

#' @export
print.geomultipolygon <- function(x, ...) {
  cat("<MultiPolygon>", "\n")
  cat("  no. polygons: ", attr(x, "no_polygons"), "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}
