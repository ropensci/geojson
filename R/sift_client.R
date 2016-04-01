#' Sift geojson - low level client
#'
#' @export
#' @param x input, one of character string, json, list, or ...
#' @param query query
#' @return an object of class \code{character}
#' @examples
#' library("leaflet")
#'
#' # get sample data
#' file <- system.file("examples", "zillow_or.geojson", package = "siftgeojson")
#'
#' # plot as is
#' dat <- jsonlite::fromJSON(file, FALSE)
#' leaflet() %>% addTiles() %>% addGeoJSON(dat) %>% setView(-122.8, 44.8, zoom = 8)
#'
#' # filter to features in Multnomah County only
#' json <- paste0(readLines(file), collapse = "")
#' json2 <- sift_client(json, '.features[] | select(.properties.COUNTY == "Multnomah")')
#' dat <- jsonlite::fromJSON(json2, FALSE)
#' leaflet() %>% addTiles() %>% addGeoJSON(dat) %>% setView(-122.6, 45.5, zoom = 10)

sift_client <- function(x, query) {
  UseMethod("sift_client")
}

#' @export
#' @rdname sift_client
sift_client.character <- function(x, query) {
  unclassattr(jqr::combine(jqr::jq(x, query)))
}

#' @export
#' @rdname sift_client
sift_client.json <- function(x, query) {
  unclassattr(jqr::combine(jqr::jq(x, query)))
}

#' @export
#' @rdname sift_client
sift_client.list <- function(x, query) {
  unclassattr(jqr::combine(jqr::jq(jsonlite::toJSON(x, auto_unbox = TRUE), query)))
}

unclassattr <- function(x) {
  x <- unclass(x)
  attr(x, "pretty") <- NULL
  x
}
