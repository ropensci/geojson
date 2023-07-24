#' Add or get CRS
#'
#' @export
#' @name crs
#' @param x An object of class \code{geojson}
#' @param crs (character) a CRS string. required.
#' @references \url{https://github.com/OSGeo/PROJ},
#'\url{https://geojson.org/geojson-spec.html#coordinate-reference-system-objects}
#'
#' @details According to RFC 7946
#' (\url{https://datatracker.ietf.org/doc/html/rfc7946#page-12}) the CRS for all GeoJSON
#' objects must be WGS-84, equivalent to \code{urn:ogc:def:crs:OGC::CRS84}.
#' And lat/long must be in decimal degrees.
#'
#' Given the above, but considering that GeoJSON blobs exist that have CRS
#' attributes in them, we provide CRS helpers here. But moving forward
#' these are not likely to be used much.
#'
#' @examples
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
#'   ]
#' }'
#'
#' # add crs
#' crs <- '{"type": "name",
#'  "properties": {
#'      "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
#' }}'
#' x %>% feature() %>% crs_add(crs)
#'
#' # get crs
#' z <- x %>% feature() %>% crs_add(crs)
#' crs_get(z)
crs_add <- function(x, crs) {
  stopifnot(inherits(x, "geojson"))
  stopifnot(inherits(crs, "character"))
  jqr::jq(unclass(x), paste0(". | .crs = ", crs))
}

#' @name crs
#' @export
crs_get <- function(x) {
  stopifnot(inherits(x, c("jqson", "character")))
  tmp <- unclass(jqr::jq(unclass(x), ".crs"))
  if (tmp == "null") {
    NULL
  } else {
    jsonlite::fromJSON(tmp)
  }
}
