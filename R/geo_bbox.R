#' Calculate a bounding box
#'
#' @export
#' @param x an object of class geojson
#' @return a vector of four doubles: min lon, min lat, max lon, max lat
#' @details Supports inputs of type: character, point, multipoint,
#' linestring, multilinestring, polygon, multipoygon, feature, and
#' featurecollection
#'
#' On character inputs, we lint the input to make sure it's proper
#' JSON and GeoJSON, then caculate the bounding box
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
#'
#' # featurecollection
#' file <- system.file("examples", 'featurecollection2.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' x <- featurecollection(str)
#' geo_bbox(x)
#'
#' # character
#' file <- system.file("examples", 'featurecollection2.geojson', package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' geo_bbox(str)

geo_bbox <- function(x) {
  UseMethod("geo_bbox")
}

#' @export
geo_bbox.default <- function(x) {
  stop("no 'geo_bbox' method for ", paste0(class(x), collapse = "/"), call. = FALSE)
}

#' @export
geo_bbox.character <- function(x) {
  geojsonlint::geojson_hint(x, verbose = TRUE, error = TRUE)
  geo_bbox(structure(x, class = tolower(get_type(x))))
}

#' @export
geo_bbox.featurecollection <- function(x) {
  feats <- jqr::jq(unclass(x), '.features[]')
  featsbboxs <- lapply(feats, function(z) {
    class(z) <- tolower(get_type(z))
    x <- structure(jqr::jq(unclass(z), '.geometry'), class = class(z))
    geo_bbox(x)
  })
  c(
    min(vapply(featsbboxs, "[[", numeric(1), 1)),
    min(vapply(featsbboxs, "[[", numeric(1), 2)),
    max(vapply(featsbboxs, "[[", numeric(1), 3)),
    max(vapply(featsbboxs, "[[", numeric(1), 4))
  )
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
  )), "[0-9.]+"))
}

make_box <- function(x, y) {
  c(min(x), min(y), max(x), max(y))
}
