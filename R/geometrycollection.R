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
#' y$types()
geometrycollection <- function(x) {
  UseMethod("geometrycollection")
}

#' @export
geometrycollection.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
geometrycollection.character <- function(x) {
  verify_names(x, c('type', 'geometries'))
  verify_class(x, "GeometryCollection")
  hint_geojson(x)
  coords <- get_coordinates(x)
  structure(x, class = "geometrycollection",
            geoms = feat_geom_n(x),
            featgeoms = feat_geom(x),
            coords = coords)
}

#' @export
print.geometrycollection <- function(x, ...) {
  cat("<GeometryCollection>", "\n")
  cat(attr(x, 'geoms'), "\n")
  cat(attr(x, 'featgeoms'), "\n")
}

# GeometryCollection <- R6::R6Class(
#   "GeometryCollection",
#   public = list(
#     x = NULL,
#     string = NULL,
#     initialize = function(x = NULL) {
#       self$string <- x
#     },
#     print = function(...) {
#       cat("<GeometryCollection>", "\n")
#       cat("  type: ", get_type(self$string), "\n")
#       cat(feat_geom_n(self$string), "\n")
#       cat(feat_geom(self$string), "\n")
#     },
#     type = function() {
#       cchar(jqr::jq(unclass(self$string), ".type"))
#     },
#     pretty = function() {
#       jsonlite::prettify(self$string)
#     },
#     types = function() {
#       cchar(unclass(jqr::jq(self$string, ".geometries[].type")))
#     },
#     write = function(file) {
#       cat(jsonlite::toJSON(jsonlite::fromJSON(self$string), pretty = TRUE, auto_unbox = TRUE), file = file)
#     }
#   )
# )
