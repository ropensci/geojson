#' Read and write newline-delimited GeoJSON
#'
#' @name ndgeo
#' @param x input, an object of class \code{geojson}
#' @param con a connection. required.
#' @param sep (character) a character separator to use in \code{writeLines}
#' 
#' @details Wrapper around \code{\link[jsonlite]{toJSON}} and
#' \code{\link{cat}}
#' @return a \code{geojson} class object
#' 
#' @examples
#' # write
#' file <- system.file("examples", 'featurecollection2.geojson',
#'   package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (x <- featurecollection(str))
#' outfile <- tempfile(fileext = ".geojson")
#' ndgeo_write(x, file(outfile))
#' readLines(file(outfile))
#' jsonlite::stream_in(file(outfile))
#' 
#' # read
#' ndgeo_read(outfile)
#' 
#' \dontrun{
#' # geojson text sequences
#' ndgeo_write(x, file(outfile), sep = "\\u001e")
#' readLines(file(outfile))
#' }

#' @export
#' @rdname ndgeo
ndgeo_write <- function(x, con, sep = "\n") {
  UseMethod("ndgeo_write")
}

#' @export
#' @rdname ndgeo
ndgeo_write.default <- function(x, con, sep = "\n") {
  stop("no 'ndgeo_write' method for ", class(x), call. = FALSE)
}

#' @export
#' @rdname ndgeo
ndgeo_write.geofeaturecollection <- function(x, con, sep = "\n") {
  tmp <- jqr::jq(unclass(x), ".features[]")
  if (!inherits(con, "connection")) stop("'con' must be a connection")
  on.exit(close(con))
  writeLines(tmp, con = con, sep = sep)
}

#' @export
#' @rdname ndgeo
ndgeo_read <- function(con) {
  on.exit(close(con))
  tmp <- readLines(con = con)
  sprintf('{"type": "FeatureCollection", "features": [ %s ]}', 
    paste0(tmp, collapse = ", "))
}
