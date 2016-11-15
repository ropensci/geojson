#' @title geojson
#'
#' @description Classes for GeoJSON to make working with GeoJSON easier
#'
#' @section Package API:
#' GeoJSON objects:
#' \itemize{
#'  \item \code{\link{feature}} - Feature
#'  \item \code{\link{featurecollection}} - FeatureCollection
#'  \item \code{\link{geometrycollection}} - GeometryCollection
#'  \item \code{\link{linestring}} - LineString
#'  \item \code{\link{multilinestring}} - MultiLineString
#'  \item \code{\link{multipoint}} - MultiPoint
#'  \item \code{\link{multipolygon}} - MultiPolygon
#'  \item \code{\link{point}} - Point
#'  \item \code{\link{polygon}} - Polygon
#' }
#' The above are assigned two classes. All of them are class \strong{geojson},
#' but also have a class name that is \strong{geo} plus the name of
#' the geometry, e.g., \strong{geopolygon} for polygon.
#'
#'
#' GeoJSON properties:
#' \itemize{
#'  \item \code{\link{properties_add}}, \code{\link{properties_get}} - Add
#'  or get properties
#'  \item \code{\link{crs_add}}, \code{\link{crs_get}} - Add or get CRS
#'  \item \code{\link{bbox_add}}, \code{\link{bbox_get}} - Add or get
#'  bounding box
#' }
#'
#' GeoJSON operations:
#' \itemize{
#'  \item \code{\link{geo_bbox}} - calculate a bounding box for any GeoJSON
#'  object
#'  \item \code{\link{geo_pretty}} - pretty print any GeoJSON object
#'  \item \code{\link{geo_type}} - get the object type for any GeoJSON
#'  object
#'  \item \code{\link{geo_write}} - easily write any GeoJSON to a file
#'  \item More complete GeoJSON operations are provdied in the package
#'  \pkg{geoops}
#' }
#'
#' GeoJSON/Geobuf serialization:
#' \itemize{
#'  \item \code{\link{from_geobuf}} - Geobuf to GeoJSON
#'  \item \code{\link{to_geobuf}} - GeoJSON to Geobuf
#'  \item Check out \url{https://github.com/mapbox/geobuf} for inormation on
#'  the Geobuf format
#' }
#'
#' @section Coordinate Reference System:
#' According to RFC 7946
#' (\url{https://tools.ietf.org/html/rfc7946#page-12}) the CRS for all GeoJSON
#' objects must be WGS-84, equivalent to \code{urn:ogc:def:crs:OGC::CRS84}.
#' And lat/long must be in decimal degrees.
#'
#' Given the above, but considering that GeoJSON blobs exist that have CRS
#' attributes in them, we provide CRS helpers in this package. But moving
#' forward these are not likely to be used much.
#'
#' @section Coordinate precision:
#' According to RFC 7946 (\url{https://tools.ietf.org/html/rfc7946#section-11.2})
#' consider that 6 decimal places amoutns to ~10 centimeters, a precision
#' well within that of current GPS sytems. Further, A GeoJSON text containing
#' many detailed Polygons can be inflated almost by a factor of two by
#' increasing coordinate precision from 6 to 15 decimal places - so consider
#' whether it is worth it to have more decimal places.
#'
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom jqr jq
#' @import methods
#' @name geojson-package
#' @author Scott Chamberlain, Jeroen Ooms
#' @aliases geojson
#' @docType package
#' @keywords package
NULL

#' Data for use in examples
#'
#' @docType data
#' @keywords datasets
#' @format A list of character strings of points or polygons in
#' FeatureCollection or Feature Geojson formats.
#' @name geojson_data
#' @details The data objects included in the list, accessible by name
#' \itemize{
#'  \item featurecollection_point - FeatureCollection with a single point
#'  \item filter_features - FeatureCollection of points
#'  \item points_average - FeatureCollection of points
#'  \item polygons_average - FeatureCollection of polygons
#'  \item points_count - FeatureCollection of points
#'  \item polygons_count - FeatureCollection of polygons
#'  \item points_within - FeatureCollection of points
#'  \item polygons_within - FeatureCollection of polygons
#'  \item poly - Feaure of a single 1 degree by 1 degree polygon
#'  \item multipoly - FeatureCollection of two 1 degree by 1 degree polygons
#'  \item polygons_aggregate - FeatureCollection of Polygons from
#'  turf.js examples
#'  \item points_aggregate - FeatureCollection of Points from turf.js examples
#' }
NULL
