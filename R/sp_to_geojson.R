# Exports SP object to \code{geojson} format. Behaves very similar to
# \code{\link[rgdal:writeOGR]{writeOGR}} with \code{driver = "geoJSON"}.
sp_to_geojson <- function(x){
  # This immediately asserts the class of 'x' is supported:
  geometry <- geojson_geometry(x)

  # Output template
  features <- data.frame(
    type = "Feature",
    id = seq_len(length(x)) - 1L
    , stringsAsFactors = FALSE)
  features$properties <- if(ncol(x@data) && nrow(x@data)){
    x@data
  } else {
    as.data.frame(matrix(nrow=length(x), ncol = 0))
  }
  features$geometry <- geometry
  json <- jsonlite::toJSON(list(
    type = jsonlite::unbox("FeatureCollection"),
    features = features
  ), always_decimal = TRUE, rownames = FALSE)
  structure(json, class = c("geojson", "json"))
}

# Calculates the 'geometry' data for this type
setGeneric("geojson_geometry", function(x) {
  standardGeneric("geojson_geometry")
})

#' @importClassesFrom sp SpatialPointsDataFrame
setMethod("geojson_geometry", "SpatialPointsDataFrame", function(x){
  geometry <- data.frame(
    type = rep("Point", length(x))
   , stringsAsFactors = FALSE)
  geometry$coordinates <- x@coords
  return(geometry)
})

#' @importClassesFrom sp SpatialLinesDataFrame
setMethod("geojson_geometry", "SpatialLinesDataFrame", function(x){
  geometry <- data.frame(
    type = rep("MultiLineString", length(x))
    , stringsAsFactors = FALSE)
  geometry$coordinates <- lapply(x@lines, function(lineset) {
    lapply(lineset@Lines, methods::slot, "coords")
  })
  return(geometry)
})

#' @importClassesFrom sp SpatialPolygonsDataFrame
setMethod("geojson_geometry", "SpatialPolygonsDataFrame", function(x){
  geometry <- data.frame(
    type = rep("Polygon", length(x))
    , stringsAsFactors = FALSE)
  geometry$coordinates <- lapply(x@polygons, function(polyset) {
    lapply(polyset@Polygons, methods::slot, "coords")
  })
  return(geometry)
})


#' @importClassesFrom sp SpatialPointsDataFrame SpatialPoints
#' @rdname as.geojson
setMethod("as.geojson", "SpatialPointsDataFrame", sp_to_geojson)

#' @rdname as.geojson
setMethod("as.geojson", "SpatialPoints", function(x){
  as.geojson(methods::as(x, "SpatialPointsDataFrame"))
})

#' @importClassesFrom sp SpatialLinesDataFrame SpatialLines
#' @rdname as.geojson
setMethod("as.geojson", "SpatialLinesDataFrame", sp_to_geojson)

#' @rdname as.geojson
setMethod("as.geojson", "SpatialLines", function(x){
  as.geojson(methods::as(x, "SpatialLinesDataFrame"))
})

#' @importClassesFrom sp SpatialPolygonsDataFrame SpatialPolygons
#' @rdname as.geojson
setMethod("as.geojson", "SpatialPolygonsDataFrame", sp_to_geojson)

#' @rdname as.geojson
setMethod("as.geojson", "SpatialPolygons", function(x){
  as.geojson(methods::as(x, "SpatialPolygonsDataFrame"))
})
