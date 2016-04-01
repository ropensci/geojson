#' Sift geojson - high level DSL
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
#' json2 <- sifter(json, '.features[] | select(.properties.COUNTY == "Multnomah")')
#' dat <- jsonlite::fromJSON(json2, FALSE)
#' leaflet() %>% addTiles() %>% addGeoJSON(dat) %>% setView(-122.6, 45.5, zoom = 10)
#'
#' # sift to Multnomah County only
#' res <- sifter(json, COUNTY == Multnomah)
#' ## check that only Multnomah County came back
#' res %>% jqr::index() %>% jqr::dotstr(properties.COUNTY)

sifter <- function(.data, ...) {
  sifter_(.data, .dots = lazyeval::lazy_dots(...))
}

#' @export
#' @rdname sifter
sifter_ <- function(.data, ..., .dots) {
  tmp <- lazyeval::all_dots(.dots, ...)
  x <- deparse(pluck(tmp, "expr")[[1]])
  xsplit <- strsplit(x, "\\s")[[1]]
  qry <- sprintf('%s %s "%s"', xsplit[[1]], xsplit[[2]], xsplit[[3]])
  z <- paste0(".features[] | select(.properties.", qry, ")")
  sift_client(.data, z)
}
