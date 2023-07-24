#' Read and write newline-delimited GeoJSON (GeoJSON text sequences)
#'
#' There are various flavors of newline-delimited GeoJSON, all of which
#' we aim to handle here. See Details for more.
#'
#' @name ndgeo
#' @param x input, an object of class `geojson`
#' @param file (character) a file. not a connection. required.
#' @param sep (character) a character separator to use in [writeLines()]
#' @param txt text, a file, or a url. required.
#' @param pagesize (integer) number of lines to read/write from/to the
#' connection per iteration
#' @param verbose (logical) print messages. default: `TRUE`
#'
#' @note **IMPORTANT**: `ngeo_read` for now only handles lines of geojson
#' in your file that are either features or geometry objects (e.g., point,
#' multipoint, polygon, multipolygon, linestring, multilinestring)
#'
#' @details
#'
#' - `ndgeo_write`: writes \pkg{geojson} package types as
#' newline-delimited GeoJSON to a file
#' - `ndgeo_read`: reads newline-delimited GeoJSON from a string,
#' file, or URL into the appropriate geojson type
#'
#' As an alternative to `ndgeo_read`, you can simply use
#' [jsonlite::stream_in()] to convert newline-delimited GeoJSON
#' to a data.frame
#'
#' @return a `geojson` class object
#' @references Newline-delimited JSON has a few flavors.
#' The only difference between ndjson <http://ndjson.org/> and
#' JSON Lines <https://jsonlines.org/> I can tell is that the former
#' requires UTF-8 encoding, while the latter does not.
#'
#' GeoJSON text sequences has a specification found at
#' <https://datatracker.ietf.org/doc/html/rfc8142>. The spec states that:
#'
#' - a GeoJSON text sequence is any number of GeoJSON RFC7946 texts
#' - each line encoded in UTF-8 RFC3629
#' - each line preceded by one ASCII RFC20 record separator (RS; "0x1e")
#' character
#' - each line followed by a line feed (LF)
#' - each JSON text MUST contain a single GeoJSON object as defined in RFC7946
#'
#' See also the GeoJSON specification <https://datatracker.ietf.org/doc/html/rfc7946>
#'
#' @examples
#' # featurecollection
#' ## write
#' file <- system.file("examples", 'featurecollection2.geojson',
#'   package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (x <- featurecollection(str))
#' outfile <- tempfile(fileext = ".geojson")
#' ndgeo_write(x, outfile)
#' readLines(outfile)
#' jsonlite::stream_in(file(outfile))
#' ## read
#' ndgeo_read(outfile)
#' unlink(outfile)
#'
#' # read from an existing file
#' ## GeoJSON objects all of same type: Feature
#' file <- system.file("examples", 'ndgeojson1.json', package = "geojson")
#' ndgeo_read(file)
#' ## GeoJSON objects all of same type: Point
#' file <- system.file("examples", 'ndgeojson2.json', package = "geojson")
#' ndgeo_read(file)
#' ## GeoJSON objects of mixed type: Point, and Feature
#' file <- system.file("examples", 'ndgeojson3.json', package = "geojson")
#' ndgeo_read(file)
#'
#' \dontrun{
#' # read from a file
#' url <- "https://raw.githubusercontent.com/ropensci/geojson/main/inst/examples/ndgeojson1.json"
#' f <- tempfile(fileext = ".geojsonl")
#' download.file(url, f)
#' x <- ndgeo_read(f)
#' x
#' unlink(f)
#'
#' # read from a URL
#' url <- "https://raw.githubusercontent.com/ropensci/geojson/main/inst/examples/ndgeojson1.json"
#' x <- ndgeo_read(url)
#' x
#'
#' # geojson text sequences from file
#' file <- system.file("examples", 'featurecollection2.geojson',
#'   package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' x <- featurecollection(str)
#' outfile <- tempfile(fileext = ".geojson")
#' ndgeo_write(x, outfile, sep = "\u001e\n")
#' con <- file(outfile)
#' readLines(con)
#' close(con)
#' ndgeo_read(outfile)
#' unlink(outfile)
#' }

#' @export
#' @rdname ndgeo
ndgeo_write <- function(x, file, sep = "\n") {
  UseMethod("ndgeo_write")
}

#' @export
#' @rdname ndgeo
ndgeo_write.default <- function(x, file, sep = "\n") {
  stop("no 'ndgeo_write' method for ", class(x)[1L], call. = FALSE)
}

#' @export
#' @rdname ndgeo
ndgeo_write.geofeaturecollection <- function(x, file, sep = "\n") {
  stopifnot(is.character(file))
  con <- file(file)
  on.exit(close(con))
  tmp <- jqr::jq(unclass(x), ".features[]")
  writeLines(tmp, con = con, sep = sep)
}

#' @export
#' @rdname ndgeo
ndgeo_write.geofeature <- function(x, file, sep = "\n") {
  stopifnot(is.character(file))
  con <- file(file)
  on.exit(close(con))
  tmp <- jqr::jq(unclass(x), ".features[]")
  writeLines(tmp, con = con, sep = sep)
}

#' @export
#' @rdname ndgeo
ndgeo_read <- function(txt, pagesize = 500, verbose = TRUE) {
  if (!is.character(txt) && !inherits(txt, "connection")) {
    stop("'txt' must be a string, URL or file.")
  }
  if (is.character(txt) && length(txt) == 1) {
    if (grepl("^https?://", txt, useBytes = TRUE)) {
      tfile <- tempfile()
      utils::download.file(txt, tfile, quiet = TRUE)
      txt <- file(tfile)
    } else if (file.exists(txt)) {
      txt <- file(txt)
    }
  }
  tmp <- stream_in_geojson(txt, pagesize = pagesize, verbose = verbose)
  as.geojson(sprintf("{\"type\":\"FeatureCollection\",\"features\":[ %s ]}",
      paste0(tmp, collapse = ", ")))
}
