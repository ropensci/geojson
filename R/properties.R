#' Add properties, crs, and bounding box
#'
#' @export
#' @name properties
#' @param x An object of class \code{geojson}
#' @param ... Properties to be added, supports NSE as well as SE
#' @param property (character) property name
#' @references \url{http://geojson.org/geojson-spec.html}
#' @examples
#' # add properties
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' (y <- linestring(x))
#' y %>% feature() %>% properties_add(population = 1000)
#'
#' # get property
#' x <- y %>% feature() %>% properties_add(population = 1000)
#' properties_get(x, property = 'population')
properties_add <- function(x, ...) {
  tmp <- lazyeval::lazy_dots(...)
  kvpairs <- list()
  for (i in seq_along(tmp)) {
    kvpairs[[names(tmp[i])]] <- tmp[[i]]$expr
  }
  kvpairsjson <- jsonlite::toJSON(kvpairs, auto_unbox = TRUE)
  jqr::jq(unclass(x), paste0(". | .properties = ", kvpairsjson))
}

#' @export
#' @rdname properties
properties_get <- function(x, property) {
  jqr::jq(unclass(x), paste0(".properties.", property))
}
