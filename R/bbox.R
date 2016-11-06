#' Add or get bounding box
#'
#' @export
#' @name bbox
#' @param x An object of class \code{geojson}
#' @param bbox (numeric) a vector or list of length 4. If \code{NULL},
#' the bounding box is calculated for you
#' @references
#' \url{http://geojson.org/geojson-spec.html#bounding-boxes}
#' @details Note that \code{bbox_get} outputs the bbox if it exists, but
#' does not calculate it from the geojson. See \code{\link{geo_bbox}}
#' to calculate a bounding box
#' @examples
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
#'   ]
#' }'
#'
#' # add bbox
#' (y <- polygon(x))
#' y %>% feature() %>% bbox_add()
#' y %>% feature() %>% bbox_add(c(-10.0, -10.0, 10.0, 10.0))
#'
#' # get bounding box
#' z <- y %>% feature() %>% bbox_add()
#' bbox_get(z)
#'
#' ## returns NULL if no bounding box
#' bbox_get(x)
bbox_add <- function(x, bbox = NULL) {
  if (is.null(bbox)) bbox <- geo_bbox(x)
  jqr::jq(unclass(x), paste0(". | .bbox = ", jsonlite::toJSON(bbox)))
}

#' @export
#' @rdname bbox
bbox_get <- function(x) {
  tmp <- unclass(jqr::jq(unclass(x), ".bbox"))
  if (tmp == "null") {
    NULL
  } else {
    as.numeric(strsplit(gsub("\\[|\\]", "", tmp), ",")[[1]])
  }
}