#' Add or get CRS
#'
#' @export
#' @name crs
#' @param x An object of class \code{geojson}
#' @param crs (character) a CRS string. required.
#' @references \url{https://github.com/OSGeo/proj.4},
#'\url{http://geojson.org/geojson-spec.html#coordinate-reference-system-objects}
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
#' x %>% feature() %>% add_crs(crs)
#'
#' # get crs
#' z <- x %>% feature() %>% add_crs(crs)
#' crs_get(z)
crs_add <- function(x, crs) {
  jqr::jq(unclass(x), paste0(". | .crs = ", crs))
}

#' @name crs
#' @export
crs_get <- function(x) {
  tmp <- unclass(jqr::jq(unclass(x), ".crs"))
  if (tmp == "null") {
    NULL
  } else {
    jsonlite::fromJSON(tmp)
  }
}
