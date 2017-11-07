#' multipoint class
#'
#' @export
#' @param x input
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
#' # as.geojson coercion
#' as.geojson(x)
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
  x <- as_x("MultiPoint", x)
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "MultiPoint")
  coords <- dotprint(cchar(jqr::jq(unclass(x), ".coordinates")))
  structure(x,
            class = c("geomultipoint", "geojson"),
            coords = coords)
}

#' @export
print.geomultipoint <- function(x, ...) {
  cat("<MultiPoint>", "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}
