#' multilinestring class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geomultilinestring and either geojson (string
#' input), or geo_list (list input)
#' @examples
#' # character
#' x <- '{ "type": "MultiLineString",
#'  "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0],
#'   [103.0, 3.0] ] ] }'
#' (y <- multilinestring(x))
#' y[1]
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' file <- system.file("examples", 'multilinestring_one.geojson',
#'   package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- multilinestring(str))
#' y[1]
#' geo_type(y)
#' geo_pretty(y)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
#'
#' # list
#' x <- list(type = "MultiLineString")
#' x$coordinates <- list(
#'   matrix(c(100, 101, 0, 1), ncol = 2),
#'   matrix(c(102, 103, 1, 2), ncol = 2),
#'   matrix(c(104, 105, 2, 3), ncol = 2)
#' )
#' (y <- multilinestring(x))
#'
#' # bigger
#' lngs <- c(-131.5, -123.4, -124.5, -118.8, -122, -114.6, -108.3, -105.8,
#'   -105.1, -97.7, -96.3, -92.1, -90.7, -85.8, -84, -78, -69.6, -83.7, -90.4,
#'   -93.9, -100.9, -97.7, -117.8, -124.8, -132.9)
#' lats <- c(60.9, 60.4, 56.8, 55.4, 50.1, 51.4, 57.1, 55.2, 51.8, 55.6, 51.6,
#'   54, 50.7, 51.2, 48.9, 49.2, 55.2, 53.5, 56.4, 59.4, 63.9, 66.8, 65.9,
#'   70.5, 69.3)
#' x$coordinates <- list(
#'   matrix(c(lngs, lats), ncol = 2, byrow = FALSE),
#'   matrix(c(lngs + 1, lats + 1), ncol = 2, byrow = FALSE),
#'   matrix(c(lngs - 1, lats - 1), ncol = 2, byrow = FALSE),
#'   matrix(c(lngs + 2, lats + 2), ncol = 2, byrow = FALSE),
#'   matrix(c(lngs - 2, lats - 2), ncol = 2, byrow = FALSE)
#' )
#' (y <- multilinestring(x))
#' y %>% feature()
#' y %>% feature() %>% featurecollection()
multilinestring <- function(x) {
  UseMethod("multilinestring")
}

#' @export
multilinestring.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
multilinestring.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x(x, "MultiLineString")
  switch_verify_names(x)
  verify_class(x, "MultiLineString")
  no_lines <- length(asc(jqr::jq(x, ".coordinates[] | length ")))
  no_nodes_each_line <- get_each_nodes(x)
  coords <- get_coordinates(x)
  structure(x, class = c("geomultilinestring", "geojson"),
            no_lines = no_lines,
            no_nodes_each_line = no_nodes_each_line,
            coords = coords)
}

#' @export
multilinestring.list <- function(x) {
  # hint_geojson(x)
  x <- as_x(x, "MultiLineString")
  switch_verify_names(x)
  verify_class(x, "MultiLineString")
  no_nodes_each_line <- get_each_nodes(x)
  coords <- get_coordinates(x)
  structure(x, class = c("geomultilinestring", "geo_list"),
            no_lines = length(x[["coordinates"]]),
            no_nodes_each_line = no_nodes_each_line,
            coords = coords)
}

#' @export
print.geomultilinestring <- function(x, ...) {
  cat("<MultiLineString>", "\n")
  cat("  no. lines: ", attr(x, 'no_lines'), "\n")
  cat("  no. nodes / line: ", attr(x, 'no_nodes_each_line'), "\n")
  cat("  coordinates: ", attr(x, 'coords'), "\n")
}
