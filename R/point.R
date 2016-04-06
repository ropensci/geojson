#' point class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' (y <- point(x))
#' y$string
#' y$type()
#' y$pretty()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
point <- function(x) {
  UseMethod("point")
}

#' @export
point.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
point.character <- function(x) {
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "Point")
  hint_geojson(x)
  #structure(x, class = c("geojson", "point"))
  Point$new(x = x)
}

Point <- R6::R6Class(
  "Point",
  public = list(
    x = NULL,
    string = NULL,
    initialize = function(x = NULL) {
      self$string <- x
    },
    print = function(...) {
      cat("<Point>", "\n")
      cat("  type: ", get_type(self$string), "\n")
      cat("  coordinates: ", cchar(jqr::jq(unclass(self$string), ".coordinates")), "\n")
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
