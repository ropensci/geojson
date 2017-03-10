#' linestring class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geolinestring and either geojson (string input),
#' or geo_list (list input)
#' @examples
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' (y <- linestring(x))
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
#' x <- list(type = "LineString")
#' x$coordinates <- matrix(c(100.0, 101.0, 0.0, 1.0), ncol = 2)
#' (y <- linestring(x))
#'
#' lngs <- c(-131.5, -123.4, -124.5, -118.8, -122, -114.6, -108.3, -105.8,
#'   -105.1, -97.7, -96.3, -92.1, -90.7, -85.8, -84, -78, -69.6, -83.7, -90.4,
#'   -93.9, -100.9, -97.7, -117.8, -124.8, -132.9)
#' lats <- c(60.9, 60.4, 56.8, 55.4, 50.1, 51.4, 57.1, 55.2, 51.8, 55.6, 51.6,
#'   54, 50.7, 51.2, 48.9, 49.2, 55.2, 53.5, 56.4, 59.4, 63.9, 66.8, 65.9,
#'   70.5, 69.3)
#' x$coordinates <- matrix(c(lngs, lats), ncol = 2, byrow = FALSE)
#' (y <- linestring(x))
#' y %>% feature()
#' y %>% feature() %>% featurecollection()
linestring <- function(x) {
  UseMethod("linestring")
}

#' @export
linestring.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
linestring.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x(x, "LineString")
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "LineString")
  coords <- get_coordinates(x)
  structure(x,
            class = c("geolinestring", "geojson"),
            coords = coords)
}

#' @export
linestring.list <- function(x) {
  # hint_geojson(x) # skipping since requires string
  x <- as_x(x, "LineString")
  verify_names(x, c('type', 'coordinates'))
  verify_class(x, "LineString")
  coords <- coords2str(x$coordinates)
  structure(x,
    class = c("geolinestring", "geo_list"),
    coords = coords
  )
}

#' @export
print.geolinestring <- function(x, ...) {
  cat("<LineString>", "\n")
  cat("  coordinates: ", attr(x, 'coords'), "\n")
}
