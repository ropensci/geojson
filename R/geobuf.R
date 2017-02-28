#' Geobuf serialization
#'
#' @name geobuf
#' @export
#' @param x (character) a file or raw object for \code{from_geobuf}, and
#' json string for \code{to_geobuf}
#' @param file (character) file to write protobuf to. if NULL, geobuf
#' raw binary returned
#' @param decimals (integer) how many decimals (digits behind the dot) to
#' store for numbers
#' @param pretty (logical) pretty print JSON. Default: \code{FALSE}
#'
#' @return for \code{from_geobuf} JSON as a character string, and for
#' \code{to_geobuf} raw or file written to disk
#'
#' @details \code{from_geobuf} uses \code{\link[protolite]{geobuf2json}},
#' while \code{to_geobuf} uses \code{\link[protolite]{json2geobuf}}
#'
#' Note that \pkg{protolite} expects either a \strong{Feature},
#' \strong{FeatureCollection}, or \strong{Geometry} class geojson
#' object, Thus, for \code{to_geobuf} we check the geojson class, and
#' convert to a \strong{Feature} if the class is something other than
#' the acceptable set.
#'
#' @references Geobuf is a compact binary encoding for geographic data
#' using protocol buffers \url{https://github.com/mapbox/geobuf}
#'
#' @examples
#' file <- system.file("examples/test.pb", package = "geojson")
#' (json <- from_geobuf(file))
#' from_geobuf(file, pretty = TRUE)
#' pb <- to_geobuf(json)
#' f <- tempfile(fileext = ".pb")
#' to_geobuf(json, f)
#' from_geobuf(f)
#'
#' object.size(json)
#' object.size(pb)
#' file.info(file)$size
#' file.info(f)$size
#'
#' file <- system.file("examples/featurecollection1.geojson",
#'   package = "geojson")
#' json <- paste0(readLines(file), collapse = "")
#' to_geobuf(json)
#'
#' # other geojson class objects
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
#'   ]
#' }'
#' (y <- polygon(x))
#' to_geobuf(y)
#'
#' x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- multipoint(x))
#' to_geobuf(y)
from_geobuf <- function(x, pretty = FALSE) {
  UseMethod("from_geobuf")
}

#' @export
from_geobuf.default <- function(x, pretty = FALSE) {
  stop("no 'from_geobuf' method for ", class(x), call. = FALSE)
}

#' @export
from_geobuf.raw <- function(x, pretty = FALSE) {
  protolite::geobuf2json(x, pretty = pretty)
}

#' @export
from_geobuf.character <- function(x, pretty = FALSE) {
  if (!file.exists(x)) stop(x, " does not exist", call. = FALSE)
  protolite::geobuf2json(x, pretty = pretty)
}

#' @export
#' @rdname geobuf
to_geobuf <- function(x, file = NULL, decimals = 6) {
  UseMethod("to_geobuf")
}

#' @export
to_geobuf.default <- function(x, file = NULL, decimals = 6) {
  stop("no 'to_geobuf' method for ", class(x), call. = FALSE)
}

#' @export
to_geobuf.json <- function(x, file = NULL, decimals = 6) {
  to_geobuf(unclass(x), file, decimals)
}

#' @export
to_geobuf.character <- function(x, file = NULL, decimals = 6) {
  togb(x, file, decimals)
}

#' @export
to_geobuf.geofeature <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

#' @export
to_geobuf.geolinestring <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

#' @export
to_geobuf.geomultilinestring <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

#' @export
to_geobuf.geomultipoint <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

#' @export
to_geobuf.geomultipolygon <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

#' @export
to_geobuf.geopoint <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

#' @export
to_geobuf.geopolygon <- function(x, file = NULL, decimals = 6) {
  togb(as_feature(x[1]), file, decimals)
}

togb <- function(x, file = NULL, decimals = 6) {
  tmp <- protolite::json2geobuf(x, decimals = decimals)
  if (is.null(file)) {
    tmp
  } else {
    on.exit(close(file(file)))
    writeBin(tmp, con = file)
  }
}
