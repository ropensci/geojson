#' point class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geopoint and either geojson (string input),
#' or geo_list (list input)
#' @examples
#' # character
#' ## make a point
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' (y <- point(x))
#' ## type
#' geo_type(y)
#' ## pretty print
#' geo_pretty(y)
#' ## write to disk
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#' ## add to a data.frame
#' library('tibble')
#' (df <- data_frame(a = 1:5, b = list(y)))
#' df$b
#' df$b[[1]]
#'
#' # list
#' x <- list(type = "Point", coordinates = c(100.0, 0.0))
#' (y <- point(x))
#' y
#' y$type
#' y$coordinates
#' ## type
#' geo_type(y)
#' ## write to disk
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f)
#' unlink(f)
#' ## add to a data.frame
#' library('tibble')
#' (df <- data_frame(a = 1:5, b = list(y)))
#' df$b
#' df$b[[1]]
point <- function(x) {
  UseMethod("point")
}

#' @export
point.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
point.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x(x, "Point")
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "Point")
  hint_geojson(x)
  structure(x,
            class = c("geopoint", "geojson"),
            coords = cchar(jqr::jq(unclass(x), ".coordinates")))
}

#' @export
point.list <- function(x) {
  # hint_geojson(x) # skipping since requires string
  x <- as_x(x, "Point")
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "Point")
  structure(x,
            class = c("geopoint", "geo_list"),
            coords = sprintf("[%s]", paste0(x$coordinates, collapse = ",")))
}

#' @export
print.geopoint <- function(x, ...) {
  cat("<Point>", "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}
