#' Geojson class
#'
#' @export
#' @param x input, an object of class character, json, SpatialPoints,
#' SpatialPointsDataFrame, SpatialLines, SpatialLinesDataFrame,
#' SpatialPolygons, or SpatialPolygonsDataFrame
#' @return an object of class geojson/json
#' @details The \code{print.geojson} method prints the geojson geometry
#' type, the bounding box, number of features (if applicable), and the
#' geometries and their lengths
#' @examples
#' # character
#' as.geojson(geojson_data$featurecollection_point)
#' as.geojson(geojson_data$polygons_average)
#' as.geojson(geojson_data$polygons_aggregate)
#' as.geojson(geojson_data$points_count)
#'
#' # sp classes
#'
#' ## SpatialPoints
#' library(sp)
#' x <- c(1,2,3,4,5)
#' y <- c(3,2,5,1,4)
#' s <- SpatialPoints(cbind(x,y))
#' as.geojson(s)
#'
#' ## SpatialPointsDataFrame
#' s <- SpatialPointsDataFrame(cbind(x,y), mtcars[1:5,])
#' as.geojson(s)
#'
#' ## SpatialLines
#' L1 <- Line(cbind(c(1,2,3), c(3,2,2)))
#' L2 <- Line(cbind(c(1.05,2.05,3.05), c(3.05,2.05,2.05)))
#' L3 <- Line(cbind(c(1,2,3),c(1,1.5,1)))
#' Ls1 <- Lines(list(L1), ID = "a")
#' Ls2 <- Lines(list(L2, L3), ID = "b")
#' sl1 <- SpatialLines(list(Ls1))
#' as.geojson(sl1)
#'
#' ## SpatialLinesDataFrame
#' sl12 <- SpatialLines(list(Ls1, Ls2))
#' dat <- data.frame(X = c("Blue", "Green"),
#'                   Y = c("Train", "Plane"),
#'                   Z = c("Road", "River"), row.names = c("a", "b"))
#' sldf <- SpatialLinesDataFrame(sl12, dat)
#' as.geojson(sldf)
#'
#' ## SpatialPolygons
#' poly1 <- Polygons(list(Polygon(cbind(c(-100,-90,-85,-100),
#'    c(40,50,45,40)))), "1")
#' poly2 <- Polygons(list(Polygon(cbind(c(-90,-80,-75,-90),
#'    c(30,40,35,30)))), "2")
#' sp_poly <- SpatialPolygons(list(poly1, poly2), 1:2)
#' as.geojson(sp_poly)
#'
#' ## SpatialPolygonsDataFrame
#' sp_polydf <- as(sp_poly, "SpatialPolygonsDataFrame")
#' as.geojson(sp_polydf)

setGeneric("as.geojson", function(x) {
  standardGeneric("as.geojson")
})

setOldClass("geojson")

#' @rdname as.geojson
setMethod("as.geojson", "json", function(x){
  stopifnot(jsonlite::validate(x))
  structure(x, class = c("geojson", "json"))
})

#' @rdname as.geojson
setMethod("as.geojson", "geojson", function(x){
  x
})

#' @rdname as.geojson
setMethod("as.geojson", "character", function(x){
  stopifnot(jsonlite::validate(x))
  structure(x, class = c("geojson", "json"))
})

#' @export
print.geojson <- function(x, ...) {
  cat("<geojson>", "\n")
  cat("  type: ", get_type(x), "\n")
  cat("  bounding box: ", geo_bbox(x), "\n")
  cat(feat_geom_n(x), "\n")
  cat(feat_geom(x), "\n")
}

#' @export
summary.geojson <- function(object, ...) {
  cat(object)
}

get_type <- function(x) {
  if (asc(jqr::jq(unclass(x), ".type")) == "Feature") {
    asc(unclass(jqr::jq(unclass(x), ".geometry.type")))
  } else {
    cchar(jqr::jq(unclass(x), ".type"))
  }
}

feat_geom_n <- function(x) {
  switch(
    get_type(x),
    GeometryCollection = {
      paste0("  geometries (n): ", jqr::jq(unclass(x), ".geometries | length"))
    },
    FeatureCollection = {
      paste0("  features (n): ", jqr::jq(unclass(x), ".features | length"))
    }
  )
}

feat_geom <- function(x) {
  switch(
    get_type(x),
    GeometryCollection = {
      #paste0("  geometries: ", cchar(jqr::jq(unclass(x), ".geometries[].type")))
      paste0(
        "  geometries (geometry / length):\n    ",
        paste(
          cchar(unclass(jqr::jq(unclass(x), ".geometries[].type"))),
          # FIXME - needs diff. logic for diff. object types
          cchar(unclass(jqr::jq(unclass(x), ".geometries[].coordinates | length"))),
          sep = " / ", collapse = "\n    "
        )
      )
    },
    FeatureCollection = {
      paste0(
        "  features (geometry / length):\n    ",
        paste(
          gsub("\\\"", "", unclass(jqr::jq(unclass(x), ".features[].geometry.type"))),
          # FIXME - needs diff. logic for diff. object types
          gsub("\\\"", "", unclass(jqr::jq(unclass(x), ".features[].geometry.coordinates | length"))),
          sep = " / ", collapse = "\n    "
        )
      )
    }
  )
}
