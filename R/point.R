#' point class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' (y <- point(x))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
point <- function(x) {
  UseMethod("point")
}

#' @export
point.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
point.character <- function(x) {
  x <- as_pt(x)
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "Point")
  hint_geojson(x)
  structure(x, class = "point", coords = cchar(jqr::jq(unclass(x), ".coordinates")))
}

#' @export
print.point <- function(x, ...) {
  cat("<Point>", "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}

# Point <- R6::R6Class(
#   "Point",
#   public = list(
#     x = NULL,
#     string = NULL,
#     initialize = function(x = NULL) {
#       self$string <- x
#     },
#     print = function(...) {
#       cat("<Point>", "\n")
#       cat("  type: ", get_type(self$string), "\n")
#       cat("  coordinates: ", cchar(jqr::jq(unclass(self$string), ".coordinates")), "\n")
#     },
#     type = function() {
#       cchar(jqr::jq(unclass(self$string), ".type"))
#     },
#     pretty = function() {
#       jsonlite::prettify(self$string)
#     },
#     write = function(file) {
#       cat(jsonlite::toJSON(jsonlite::fromJSON(self$string), pretty = TRUE, auto_unbox = TRUE), file = file)
#     }
#   )
# )

as_pt <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    jqr::jq(unclass(x), ".geometry")
  } else if (asc(jqr::jq(unclass(x), ".type")) == "Point") {
    x
  }
}
