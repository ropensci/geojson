#' Read and write newline-delimited GeoJSON (GeoJSON text sequences)
#' 
#' There are various flavors of newline-delimited GeoJSON, all of which
#' we aim to handle here. See Details for more.
#'
#' @name ndgeo
#' @param x input, an object of class `geojson`
#' @param file a file. required.
#' @param sep (character) a character separator to use in [writeLines()]
#' @param txt text, a file, or a url. required.
#' @param pagesize (integer) number of lines to read/write from/to the 
#' connection per iteration
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
#' JSON Lines <http://jsonlines.org/> I can tell is that the former 
#' requires UTF-8 encoding, while the latter does not.
#' 
#' GeoJSON text sequences has a specification found at  
#' <https://tools.ietf.org/html/rfc8142>. The spec states that:
#' 
#' - a GeoJSON text sequence is any number of GeoJSON RFC7946 texts
#' - each line encoded in UTF-8 RFC3629
#' - each line preceded by one ASCII RFC20 record separator (RS; "0x1e") 
#' character
#' - each line followed by a line feed (LF)
#' - each JSON text MUST contain a single GeoJSON object as defined in RFC7946
#' 
#' See also the GeoJSON specification <https://tools.ietf.org/html/rfc7946>
#' 
#' @examples
#' # featurecollection
#' ## write
#' file <- system.file("examples", 'featurecollection2.geojson',
#'   package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (x <- featurecollection(str))
#' outfile <- tempfile(fileext = ".geojson")
#' # fconn <- file(outfile)
#' ndgeo_write(x, outfile)
#' fconn <- file(outfile)
#' readLines(outfile)
#' jsonlite::stream_in(file(outfile))
#' ## read
#' ndgeo_read(outfile)
#' 
#' # feature
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' (z <- point(x) %>% feature())
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
#' hawaii_small <- '/Users/sckott/Downloads/honolulu_hawaii_small.geojsonl'
#' res = ndgeo_read(hawaii_small)
#' res
#' 
#' hawaii_big <- '/Users/sckott/Downloads/honolulu_hawaii.geojsonl'
#' res = ndgeo_read(hawaii_big)
#' res
#' 
#' # read from a URL
#' url <- "https://storage.googleapis.com/osm-extracts.interline.io/honolulu_hawaii.geojsonl"
#' f <- tempfile(fileext = ".geojsonl")
#' download.file(url, f)
#' ndgeo_read(f)
#' 
#' 
#' # geojson text sequences
#' ndgeo_write(x, outfile, sep = "\\u001e")
#' readLines(file(outfile))
#' }

#' @export
#' @rdname ndgeo
ndgeo_write <- function(x, file, sep = "\n") {
  UseMethod("ndgeo_write")
}

#' @export
#' @rdname ndgeo
ndgeo_write.default <- function(x, file, sep = "\n") {
  stop("no 'ndgeo_write' method for ", class(x), call. = FALSE)
}

#' @export
#' @rdname ndgeo
ndgeo_write.geofeaturecollection <- function(x, file, sep = "\n") {
  con <- file(file)
  on.exit(close(con))
  tmp <- jqr::jq(unclass(x), ".features[]")
  writeLines(tmp, con = con, sep = sep)
}

#' @export
#' @rdname ndgeo
ndgeo_write.geofeature <- function(x, file, sep = "\n") {
  con <- file(file)
  on.exit(close(con))
  tmp <- jqr::jq(unclass(x), ".features[]")
  writeLines(tmp, con = con, sep = sep)
}

#' @export
#' @rdname ndgeo
ndgeo_read <- function(txt, pagesize = 500) {
  if (!is.character(txt) && !inherits(txt, "connection")) {
    stop("'txt' must be a string, URL or file.")
  }
  if (is.character(txt) && length(txt) == 1) {
    if (grepl("^https?://", txt, useBytes = TRUE)) {
      tfile <- tempfile()
      utils::download.file(txt, file, quiet = TRUE)
      txt <- file(tfile)
    } else if (file.exists(txt)) {
      txt <- file(txt)
    }
  }
  # on.exit(close(txt))
  tmp <- stream_in_geojson(txt, pagesize = pagesize)
  as.geojson(sprintf('{"type": "FeatureCollection", "features": [ %s ]}', 
      paste0(tmp, collapse = ", ")))

  # (txt <- file(file))
  # jsonlite::stream_in(txt, )
  # res <- vector("character", length = length(tmp))
  # foobar <- function(x) {
  #   # res <<- to_feature(x)
  #   res <<- x
  # }

  # tmp <- readLines(con = txt)
  # tmp2 <- vector("character", length = length(tmp))
  # for (i in seq_along(tmp)) {
  #   tmp2[i] <- to_feature(tmp[i])
  # }
  # as.geojson(sprintf('{"type": "FeatureCollection", "features": [ %s ]}', 
  #     paste0(tmp2, collapse = ", ")))
}
