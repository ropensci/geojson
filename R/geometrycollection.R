#' geometrycollection class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geogeometrycollection and either geojson
#' (string input), or geo_list (list input)
#' @examples
#' m <- '{
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
#' (y <- geometrycollection(m))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # bigger geometrycollection
#' file <- system.file("examples", "geometrycollection1.geojson",
#'   package = "geojson")
#' (y <- geometrycollection(paste0(readLines(file), collapse="")))
#' geo_type(y)
#' geo_pretty(y)
#'
#'
#' # list
#' x <- list(
#'  type = "GeometryCollection",
#'  geometries = list(
#'    list(
#'      type = "Point",
#'      coordinates = c(100.0, 0.0)
#'    ),
#'    list(
#'      type = "LineString",
#'      coordinates = list(c(101.0, 0.0), c(102.0, 1.0) )
#'    )
#'  )
#' )
#' geometrycollection(x)
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
  structure(x, class = c("geogeometrycollection", "geojson"),
            geoms = feat_geom_n(x),
            featgeoms = feat_geom(x))
}

#' @export
geometrycollection.list <- function(x) {
  # hint_geojson(x)
  verify_names(x, c('type', 'geometries'))
  verify_class(x, "GeometryCollection")
  structure(x, class = c("geogeometrycollection", "geo_list"),
            geoms = feat_geom_n(x),
            featgeoms = feat_geom(x))
}

#' @export
print.geogeometrycollection <- function(x, ...) {
  cat("<GeometryCollection>", "\n")
  cat(attr(x, 'geoms'), "\n")
  cat(attr(x, 'featgeoms'), "\n")
}
