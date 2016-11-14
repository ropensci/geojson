#' geometrycollection class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{
#'  "type": "GeometryCollection",
#'  "geometries": [
#'    {
#'      "type": "Point",
#'      "coordinates": [100.0, 0.0]
#'    },
#'    {
#'      "type": "LineString",
#'      "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
#'    }
#'   ]
#' }'
#' (y <- geometrycollection(x))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # bigger geometrycollection
#' file <- system.file("examples", "geometrycollection1.geojson", package = "geojson")
#' (y <- geometrycollection(paste0(readLines(file), collapse="")))
#' geo_type(y)
#' geo_pretty(y)
geometrycollection <- function(x) {
  UseMethod("geometrycollection")
}

#' @export
geometrycollection.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
geometrycollection.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  verify_names(x, c('type', 'geometries'))
  verify_class(x, "GeometryCollection")
  coords <- get_coordinates(x)
  structure(x, class = c("geogeometrycollection", "geojson"),
            geoms = feat_geom_n(x),
            featgeoms = feat_geom(x),
            coords = coords)
}

#' @export
print.geogeometrycollection <- function(x, ...) {
  cat("<GeometryCollection>", "\n")
  cat(attr(x, 'geoms'), "\n")
  cat(attr(x, 'featgeoms'), "\n")
}
