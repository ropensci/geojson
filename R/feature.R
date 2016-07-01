#' feature class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' x <- '{ "type": "Feature", "properties": {}, "geometry": { "type": "Point", "coordinates": [100.0, 0.0]} }'
#' (y <- feature(x))
#' y$string
#' y$type()
#' y$pretty()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # make multilinestring into a feature
#' x <- '{ "type": "MultiLineString", "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
#' (y <- multilinestring(x))
#' feature(y)
feature <- function(x) {
  UseMethod("feature")
}

#' @export
feature.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
feature.mls <- function(x) {
  feature(x[[1]]$string)
}

#' @export
feature.character <- function(x) {
  x <- as_feature(x)
  verify_class_(x, "Feature")
  switch_verify_names(x)
  hint_geojson(x)
  Feature$new(x = x)
}

Feature <- R6::R6Class(
  "Feature",
  public = list(
    x = NULL,
    string = NULL,
    initialize = function(x = NULL) {
      self$string <- x
    },
    print = function(...) {
      cat("<Feature>", "\n")
      cat("  type: ", get_type(self$string), "\n")
      cat("  coordinates: ", get_coordinates(self$string), "\n")
    },
    type = function() {
      cchar(jqr::jq(unclass(self$string), ".type"))
    },
    pretty = function() {
      jsonlite::prettify(self$string)
    },
    write = function(file) {
      cat(jsonlite::toJSON(jsonlite::fromJSON(self$string), pretty = TRUE, auto_unbox = TRUE), file = file)
    }
  )
)

as_feature <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    x
  } else {
    sprintf('{ "type": "Feature", "properties": {}, "geometry": %s }', x)
  }
}
