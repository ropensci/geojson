#' Calculate a bounding box
#'
#' @export
#' @param x an object of class geojson
#' @examples
#' # point
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' (y <- point(x))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
#'
#' # multipoint
#' x <- '{"type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- multipoint(x))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
#'
#' # linestring
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- linestring(x))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
#' file <- system.file("examples", 'linestring_one.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- linestring(str))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
#'
#' # multilinestring
#' x <- '{ "type": "MultiLineString",
#'  "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }'
#' (y <- multilinestring(x))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
#'
#' # polygon
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
#'   ]
#' }'
#' (y <- polygon(x))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
#'
#' # multipolygon
#' x <- '{ "type": "MultiPolygon",
#' "coordinates": [
#'   [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
#'   [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
#'   [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
#'   ]
#' }'
#' (y <- multipolygon(x))
#' geo_bbox(y)
#' y %>% feature() %>% geo_bbox()
geo_bbox <- function(x) {
  UseMethod("geo_bbox")
}

#' @export
geo_bbox.feature <- function(x) {
  type <- tolower(cchar(jqr::jq(unclass(x), '.geometry.type')))
  x <- structure(jqr::jq(unclass(x), '.geometry'), class = type)
  geo_bbox(x)
}

#' @export
geo_bbox.point <- function(x) {
  longs <- grab_coords(x, ".coordinates[0]")
  lats <- grab_coords(x, ".coordinates[1]")
  make_box(longs, lats)
}

#' @export
geo_bbox.multipoint <- function(x) {
  longs <- grab_coords(x, ".coordinates | map(.[0])")
  lats <- grab_coords(x, ".coordinates | map(.[1])")
  make_box(longs, lats)
}

#' @export
geo_bbox.linestring <- function(x) {
  longs <- grab_coords(x, ".coordinates | map(.[0])")
  lats <- grab_coords(x, ".coordinates | map(.[1])")
  make_box(longs, lats)
}

#' @export
geo_bbox.multilinestring <- function(x) {
  longs <- grab_coords(x, ".coordinates[] | map(.[0])")
  lats <- grab_coords(x, ".coordinates[] | map(.[1])")
  make_box(longs, lats)
}

#' @export
geo_bbox.polygon <- function(x) {
  longs <- grab_coords(x, ".coordinates[] | map(.[0])")
  lats <- grab_coords(x, ".coordinates[] | map(.[1])")
  make_box(longs, lats)
}

#' @export
geo_bbox.multipolygon <- function(x) {
  longs <- grab_coords(x, ".coordinates[] | map(.[0])")
  lats <- grab_coords(x, ".coordinates[] | map(.[1])")
  make_box(longs, lats)
}

# helpers ----------------------
grab_coords <- function(x, str) {
  as.numeric(stex(cchar(unclass(
    jqr::jq(unclass(x), str)
  )), "[[:digit:]]+"))
}

make_box <- function(x, y) {
  c(min(x), min(y), max(x), max(y))
}
