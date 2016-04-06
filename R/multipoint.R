#' multipoint class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- multipoint(x))
#' y$string
#' y$type()
#' y$pretty()
#' y$write(file = (f <- tempfile(fileext = ".geojson")))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
multipoint <- function(x) {
  UseMethod("multipoint")
}

#' @export
multipoint.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multipoint.character <- function(x) {
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "MultiPoint")
  hint_geojson(x)
  #structure(x, class = c("geojson", "multipoint"))
  MultiPoint$new(x = x)
}

MultiPoint <- R6::R6Class(
  "MultiPoint",
  public = list(
    x = NULL,
    string = NULL,
    initialize = function(x = NULL) {
      self$string <- x
    },
    print = function(...) {
      cat("<MultiPoint>", "\n")
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
