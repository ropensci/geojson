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
#'
#' ## sf objects
#' if (requireNamespace('sf')) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   as.geojson(nc)
#' }
#'

setGeneric("as.geojson", function(x) {
  standardGeneric("as.geojson")
})

setOldClass("geojson")

#' @rdname as.geojson
setMethod("as.geojson", "json", function(x){
  jsonval <- jsonlite::validate(x)
  if (!jsonval) stop("json invalid: ", attr(jsonval, "err"))
  structure(x, class = c("geojson", "json"))
})

#' @rdname as.geojson
setMethod("as.geojson", "geojson", function(x){
  x
})

#' @rdname as.geojson
setMethod("as.geojson", "character", function(x){
  jsonval <- jsonlite::validate(x)
  if (!jsonval) stop("json invalid: ", attr(jsonval, "err"))
  type <- get_type(x)
  no_feats <- feat_geom_n(x, type)
  first5 <- feat_geom(x, type)
  structure(x, class = c("geojson", "json"), 
    type = type, no_features = no_feats, five_feats = first5)
})

#' @export
print.geojson <- function(x, ...) {
  type <- attr(x, "type")
  no_features <- attr(x, "no_features")
  five_feats <- attr(x, "five_feats")
  cat("<geojson>", "\n")
  cat("  type: ", if (is.null(type)) get_type(x) else type, "\n")
  # FIXME: geo_bbox is very slow - bring back when speeds up
  # cat("  bounding box: ", geo_bbox(x), "\n")
  cat(no_features, "\n")
  #if (geo_type(x) %in% c("FeatureCollection", "GeometryCollection")) {
  cat(five_feats, "\n")
  #}
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

feat_geom_n <- function(x, type = NULL) {
  type <- if (is.null(type)) get_type(x) else type
  switch(
    type,
    Point = {
      paste0("  points (n): ", jqr::jq(unclass(x), ".coordinates | length"))
    },
    MultiPoint = {
      paste0("  points (n): ", length(jqr::jq(unclass(x), ".coordinates[]")))
    },
    Polygon = {
      paste0("  points (n): ", jqr::jq(unclass(x), ".coordinates[] | length"))
    },
    MultiPolygon = {
      paste0("  polygons (n): ", length(asc(jqr::jq(unclass(x), ".coordinates[] | length "))))
    },
    LineString = {
      paste0("  points (n): ", length(asc(jqr::jq(unclass(x), ".coordinates[] | length"))))
    },
    MultiLineString = {
      paste0("  lines (n): ", length(asc(jqr::jq(unclass(x), ".coordinates[] | length "))))
    },
    GeometryCollection = {
      paste0("  geometries (n): ", jqr::jq(unclass(x), ".geometries | length"))
    },
    FeatureCollection = {
      paste0("  features (n): ", jqr::jq(unclass(x), ".features | length"))
    }
  )
}

feat_geom <- function(x, type = NULL) {
  x <- unclass(x)
  type <- if (is.null(type)) get_type(x) else type
  switch(
    type,
    Point = {
      paste0("  coordinates: ", jqr::jq(x, ".coordinates"))
    },
    MultiPoint = {
      paste0("  coordinates: ", dotprint(jqr::jq(x, ".coordinates")))
    },
    Polygon = {
      paste0("  coordinates: ", dotprint(jqr::jq(x, ".coordinates")))
    },
    MultiPolygon = {
      paste0("  coordinates: ", dotprint(jqr::jq(x, ".coordinates")))
    },
    LineString = {
      paste0("  coordinates: ", dotprint(jqr::jq(x, ".coordinates")))
    },
    MultiLineString = {
      paste0("  coordinates: ", get_coordinates(x))
    },
    GeometryCollection = {
      paste0(
        "  geometries (geometry / length):\n    ",
        paste(
          cchar(unclass(jqr::jq(x, ".geometries[].type"))),
          # FIXME - needs diff. logic for diff. object types
          cchar(
            unclass(jqr::jq(x, ".geometries[].coordinates | length"))),
          sep = " / ", collapse = "\n    "
        )
      )
    },
    FeatureCollection = {
      # get first 5 objects
      first5 <- jqr::jq(x, "limit(5; .features[])")
      pieces <- paste(
        gsub("\\\"", "",
             unclass(jqr::jq(first5, ".geometry.type"))),
        # FIXME - needs diff. logic for diff. object types
        gsub("\\\"", "",
             unclass(jqr::jq(first5, ".geometry.coordinates | length"))),
        sep = " / "
      )
      pieces <- paste0(pieces, collapse = "\n    ")
      paste0(
        "  features (geometry / length) [first 5]:\n    ", pieces)
    }
  )
}

#' Convert GeoJSON character string to approriate GeoJSON class
#'
#' Automatically detects and adds the class
#'
#' @param x GeoJSON character string
#'
#' @export
#'
#' @examples
#' mp <- '{"type":"MultiPoint","coordinates":[[100,0],[101,1]]}'
#' to_geojson(mp)
#'
#' ft <- '{"type":"Feature","properties":{"a":"b"},
#' "geometry":{"type": "MultiPoint","coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}}'
#' to_geojson(mp)
#'
#' fc <- '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"a":"b"},
#' "geometry":{"type": "MultiPoint","coordinates": [ [100.0, 0.0], [101.0, 1.0] ]}}]}'
#' to_geojson(fc)
to_geojson <- function(x) {
  type <- asc(jqr::jq(unclass(x), ".type"))

  fn <- switch(type,
    "Point" = point,
    "LineString" = linestring,
    "Polygon" = polygon,
    "MultiPoint" = multipoint,
    "MultiLineString" = multilinestring,
    "MultiPolygon" = multipolygon,
    "Feature" = feature,
    "FeatureCollection" = featurecollection,
    "GeometryCollection" = geometrycollection
  )

  if (is.null(fn)) {
    stop("Invalid GeoJSON type: ", type, call. = FALSE)
  }

  fn(x)
}
