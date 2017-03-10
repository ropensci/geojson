#' multipoint class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geomultipoint and either geojson (string input),
#' or geo_list (list input)
#' @examples
#' x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- multipoint(x))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
#'
#' # list
#' x <- list(type = "MultiPoint", coordinates =
#'   matrix(c(100.0, 101.0, 0.0, 1.0), ncol = 2))
#' (y <- multipoint(x))
#' y
multipoint <- function(x) {
  UseMethod("multipoint")
}

#' @export
multipoint.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multipoint.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x(x, "MultiPoint")
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "MultiPoint")
  structure(x,
            class = c("geomultipoint", "geojson"),
            coords = cchar(jqr::jq(unclass(x), ".coordinates")))
}

#' @export
multipoint.list <- function(x) {
  # hint_geojson(x) # skipping since requires string
  x <- as_x(x, "MultiPoint")
  verify_names(x, c('type', 'coordinates'))
  # verify_class(x, "MultiPoint")
  structure(x,
            class = c("geomultipoint", "geo_list"),
            coords = sprintf("[%s]", paste0(x$coordinates, collapse = ",")))
}

#' @export
print.geomultipoint <- function(x, ...) {
  cat("<MultiPoint>", "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}
