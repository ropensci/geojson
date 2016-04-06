#' multilinestring class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "MultiLineString", "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
#' (y <- multilinestring(x))
#' y$string
#' y$type()
#' y$pretty()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
multilinestring <- function(x) {
  UseMethod("multilinestring")
}

#' @export
multilinestring.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multilinestring.character <- function(x) {
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "MultiLineString")
  hint_geojson(x)
  #structure(x, class = c("geojson", "multilinestring"))
  MultiLineString$new(x = x)
}

MultiLineString <- R6::R6Class(
  "MultiLineString",
  public = list(
    x = NULL,
    string = NULL,
    initialize = function(x = NULL) {
      self$string <- x
    },
    print = function(...) {
      cat("<MultiLineString>", "\n")
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
