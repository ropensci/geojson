#' Add or get properties
#'
#' @export
#' @name properties
#' @param x An object of class \code{geojson}
#' @param ... Properties to be added, supports NSE as well as SE
#' @param .list a named list of properties to add. must be named
#' @param property (character) property name
#' @references \url{http://geojson.org/geojson-spec.html}
#' @examples
#' # add properties
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' (y <- linestring(x))
#' y %>% feature() %>% properties_add(population = 1000)
#'
#' ## add with a named list already created
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' (y <- linestring(x))
#' props <- list(population = 1000, temperature = 89, size = 5)
#' y %>% feature() %>% properties_add(.list = props)
#'
#' ## combination of NSE and .list
#' x <- '{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}'
#' (y <- linestring(x))
#' props <- list(population = 1000, temperature = 89, size = 5)
#' y %>% feature() %>% properties_add(stuff = 4, .list = props)
#'
#'
#' # get property
#' x <- y %>% feature() %>% properties_add(population = 1000)
#' properties_get(x, property = 'population')
properties_add <- function(x, ..., .list = NULL) {
  if (!is.null(.list)) {
    if (!inherits(.list, "list")) stop(".list must be a list", call. = FALSE)
    if (!all(nchar(names(.list)) > 0)) {
      stop("all elements of .list must be named", call. = FALSE)
    }
  }
  tmp <- lazyeval::lazy_dots(...)
  kvpairs <- list()
  for (i in seq_along(tmp)) {
    kvpairs[[names(tmp[i])]] <- lazyeval::lazy_eval(tmp[[i]])
  }
  kvpairs <- c(kvpairs, .list)
  kvpairsjson <- jsonlite::toJSON(kvpairs, auto_unbox = TRUE)
  jqr::jq(unclass(x), paste0(". | .properties = ", kvpairsjson))
}

#' @export
#' @rdname properties
properties_get <- function(x, property) {
  jqr::jq(unclass(x), paste0(".properties.", property))
}
