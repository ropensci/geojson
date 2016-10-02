#' @title geojson
#'
#' @description Classes for GeoJSON to make working with GeoJSON easier
#'
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom jqr jq
#' @importFrom geojsonlint geojson_hint geojson_lint
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
#' @format A list of character strings of points or polygons in FeatureCollection or Feature
#' Geojson formats.
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
#'  \item polygons_aggregate - FeatureCollection of Polygons from turf.js examples
#'  \item points_aggregate - FeatureCollection of Points from turf.js examples
#' }
NULL
