#' Add or get bounding box
#'
#' @export
#' @name bbox
#' @param x An object of class \code{geojson}
#' @param bbox (numeric) a vector or list of length 4 for a 2D bounding box
#' or length 6 for a 3D bounding box. If \code{NULL}, the bounding box is 
#' calculated for you
#'
#' @references
#' \url{https://tools.ietf.org/html/rfc7946#section-5}
#'
#' @details Note that \code{bbox_get} outputs the bbox if it exists, but
#' does not calculate it from the geojson. See \code{\link{geo_bbox}}
#' to calculate a bounding box. Bounding boxes can be 2D or 3D.
#'
#' @return 
#' \itemize{
#'  \item bbox_add: an object of class jqson/character from \pkg{jqr}
#'  \item bbox_get: a bounding box, of the form 
#'   \code{[west, south, east, north]} for 2D or of the form
#'   \code{[west, south, min-altitude, east, north, max-altitude]} for 3D
#' }
#'
#' @examples
#' # make a polygon
#' x <- '{ "type": "Polygon",
#' "coordinates": [
#'   [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
#'   ]
#' }'
#' (y <- polygon(x))
#'
#' # add bbox - without an input, we figure out the 2D bbox for you
#' y %>% feature() %>% bbox_add()
#' ## 2D bbox
#' y %>% feature() %>% bbox_add(c(100.0, -10.0, 105.0, 10.0))
#' ## 3D bbox
#' y %>% feature() %>% bbox_add(c(100.0, -10.0, 3, 105.0, 10.0, 17))
#'
#' # get bounding box
#' z <- y %>% feature() %>% bbox_add()
#' bbox_get(z)
#'
#' ## returns NULL if no bounding box
#' bbox_get(x)
bbox_add <- function(x, bbox = NULL) {
  stopifnot(inherits(x, "geojson"))
  if (!is.null(bbox)) {
    stopifnot(inherits(bbox, "numeric"))
    stopifnot(length(bbox) %in% c(4L, 6L))
  }
  if (is.null(bbox)) bbox <- geo_bbox(x)
  jqr::jq(unclass(x), paste0(". | .bbox = ", jsonlite::toJSON(bbox)))
}

#' @export
#' @rdname bbox
bbox_get <- function(x) {
  stopifnot(inherits(x, c("jqson", "character")))
  tmp <- unclass(jqr::jq(unclass(x), ".bbox"))
  if (tmp == "null") {
    NULL
  } else {
    as.numeric(strsplit(gsub("\\[|\\]", "", tmp), ",")[[1]])
  }
}
