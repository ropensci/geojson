#' Add properties, crs, and bounding box
#'
#' @export
#' @param x An object of class \code{geojson}
#' @param ... Properties to be added, supports NSE as well as SE
#' @param crs (character) a CRS string. required.
#' @param bbox (numeric) a vector or list of length 4. If \code{NULL},
#' the bounding box is calculated for you
#' @examples
#' # add properties
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }'
#' (y <- linestring(x))
#' y %>% feature() %>% add_properties(population = 1000)
#'
#' # add crs
#' crs <- '{"type": "name",
#'  "properties": {
#'      "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
#' }}'
#' y %>% feature() %>% add_crs(crs)
#'
#' # add bbox
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
#'   ]
#' }'
#' (y <- polygon(x))
#' y %>% feature() %>% add_bbox()
#' y %>% feature() %>% add_bbox(c(-10.0, -10.0, 10.0, 10.0))

add_properties <- function(x, ...) {
  tmp <- lazyeval::lazy_dots(...)
  kvpairs <- list()
  for (i in seq_along(tmp)) {
    kvpairs[[names(tmp[i])]] <- tmp[[i]]$expr
  }
  kvpairsjson <- jsonlite::toJSON(kvpairs, auto_unbox = TRUE)
  jqr::jq(unclass(x), paste0(". | .properties = ", kvpairsjson))
}

#' @export
#' @rdname add_properties
add_crs <- function(x, crs) {
  jqr::jq(unclass(x), paste0(". | .crs = ", crs))
}

#' @export
#' @rdname add_properties
add_bbox <- function(x, bbox = NULL) {
  if (is.null(bbox)) {
    # calculate bbox
    bbox <- geo_bbox(x)
  }
  # add bbox
  jqr::jq(unclass(x), paste0(". | .bbox = ", jsonlite::toJSON(bbox)))
}
