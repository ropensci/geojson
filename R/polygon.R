#' polygon class
#'
#' @export
#' @param x input, either JSON character string or a list
#' @return an object of class geopolygon and either geojson (string input),
#' or geo_list (list input)
#' @examples
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [100.0, 1.0], [101.0, 1.0], [101.0, 0.0], [100.0, 0.0] ]
#'   ]
#' }'
#' (y <- polygon(x))
#' y[1]
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
#'   [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
#'   ]
#' }'
#' (y <- polygon(x))
#' y[1]
#' geo_type(y)
#' geo_pretty(y)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
#'
#' # list
#' x <- list(type = "Polygon")
#' x$coordinates <- list(
#'   matrix(c(100, 101, 0, 1), ncol = 2),
#'   matrix(c(102, 103, 1, 2), ncol = 2),
#'   matrix(c(104, 105, 2, 3), ncol = 2)
#' )
#' (y <- polygon(x))

polygon <- function(x) {
  UseMethod("polygon")
}

#' @export
polygon.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
polygon.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x(x, "Polygon")
  switch_verify_names(x)
  verify_class(x, "Polygon")
  no_lines <- length(asc(jqr::jq(x, ".coordinates[] | length ")))
  no_nodes_each_line <- get_each_nodes(x)
  coords <- get_coordinates(x)
  structure(x, class = c("geopolygon", "geojson"),
            no_lines = no_lines,
            no_holes = no_lines - 1,
            no_nodes_each_line = no_nodes_each_line,
            coords = coords)
}


#' @export
polygon.list <- function(x) {
  # hint_geojson(x)
  x <- as_x(x, "Polygon")
  switch_verify_names(x)
  verify_class(x, "Polygon")
  no_lines <- length(x[["coordinates"]])
  no_nodes_each_line <- get_each_nodes(x)
  coords <- get_coordinates(x)
  structure(x, class = c("geopolygon", "geo_list"),
            no_lines = no_lines,
            no_holes = no_lines - 1,
            no_nodes_each_line = no_nodes_each_line,
            coords = coords)
}

#' @export
print.geopolygon <- function(x, ...) {
  cat("<Polygon>", "\n")
  cat("  no. lines: ", attr(x, 'no_lines'), "\n")
  cat("  no. holes: ", attr(x, 'no_holes'), "\n")
  cat("  no. nodes / line: ", attr(x, 'no_nodes_each_line'), "\n")
  cat("  coordinates: ", attr(x, 'coords'), "\n")
}
