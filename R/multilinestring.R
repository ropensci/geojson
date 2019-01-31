#' multilinestring class
#'
#' @export
#' @param x input
#' @examples
#' x <- '{ "type": "MultiLineString",
#'  "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
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
#' con <- file(file)
#' str <- paste0(readLines(con), collapse = " ")
#' (y <- multilinestring(str))
#' y[1]
#' geo_type(y)
#' geo_pretty(y)
#' close(con)
#'
#' # add to a data.frame
#' library('tibble')
#' tibble(a = 1:5, b = list(y))

multilinestring <- function(x) {
  UseMethod("multilinestring")
}

#' @export
multilinestring.default <- function(x) {
  stop("no method for ", class(x)[1L], call. = FALSE)
}

#' @export
multilinestring.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_x("MultiLineString", x)
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
print.geomultilinestring <- function(x, ...) {
  cat("<MultiLineString>", "\n")
  cat("  no. lines: ", attr(x, "no_lines"), "\n")
  cat("  no. nodes / line: ", attr(x, "no_nodes_each_line"), "\n")
  cat("  coordinates: ", attr(x, "coords"), "\n")
}
