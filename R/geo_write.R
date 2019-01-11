#' Write geojson to disk
#'
#' @export
#' @param x input, an object of class \code{geojson}
#' @param file (character) a file path, or connection
#' @details Wrapper around \code{\link[jsonlite]{toJSON}} and
#' \code{\link{cat}}
#' @examples
#' file <- tempfile(fileext = ".geojson")
#' geo_write(
#'   point('{ "type": "Point", "coordinates": [100.0, 0.0] }'),
#'   file
#' )
#' readLines(file)
#' unlink(file)
geo_write <- function(x, file) {
  UseMethod("geo_write")
}

#' @export
geo_write.default <- function(x, file) {
  stop("no 'geo_write' method for ", class(x), call. = FALSE)
}

#' @export
geo_write.geojson <- function(x, file) {
  if (inherits(file, "file")) on.exit(close(file)) 
  cat(
    jsonlite::toJSON(jsonlite::fromJSON(x), pretty = TRUE, auto_unbox = TRUE),
    "\n",
    file = file
  )
}
