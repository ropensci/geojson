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
#' y$string
#' y$type()
#' y$pretty()
#' y$types()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' unlink(f)
#'
#' # bigger geometrycollection
#' file <- system.file("examples", "geometrycollection1.geojson", package = "geojson")
#' (y <- geometrycollection(paste0(readLines(file), collapse="")))
#' y$string
#' y$type()
#' y$pretty()
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
  #structure(x, class = c("geojson", "geometrycollection"))
  GeometryCollection$new(x = x)
}

GeometryCollection <- R6::R6Class(
  "GeometryCollection",
  public = list(
    x = NULL,
    string = NULL,
    initialize = function(x = NULL) {
      self$string <- x
    },
    print = function(...) {
      cat("<GeometryCollection>", "\n")
      cat("  type: ", get_type(self$string), "\n")
      cat(feat_geom_n(self$string), "\n")
      cat(feat_geom(self$string), "\n")
    },
    type = function() {
      cchar(jqr::jq(unclass(self$string), ".type"))
    },
    pretty = function() {
      jsonlite::prettify(self$string)
    },
    types = function() {
      cchar(unclass(jqr::jq(self$string, ".geometries[].type")))
    },
    write = function(file) {
      cat(jsonlite::toJSON(jsonlite::fromJSON(self$string), pretty = TRUE, auto_unbox = TRUE), file = file)
    }
  )
)
