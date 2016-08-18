#' Geojson class
#' @export
#' @param x input
#' @examples
#' as.geojson(geojson_data$featurecollection_point)
#'
#' x <- geojson_data$polygons_average
#' as.geojson(x)
#'
#' x <- geojson_data$polygons_aggregate
#' as.geojson(x)
#'
#' x <- geojson_data$points_count
#' as.geojson(x)
setGeneric("as.geojson", function(x) {
  standardGeneric("as.geojson")
})

#' @rdname as.geojson
setMethod("as.geojson", "json", function(x){
  stopifnot(jsonlite::validate(x))
  structure(x, class = c("geojson", "json"))
})

#' @rdname as.geojson
setMethod("as.geojson", "character", function(x){
  stopifnot(jsonlite::validate(x))
  structure(x, class = c("geojson", "json"))
})

# setMethod("as.geojson", "default", function(x){
#   stop("no 'as.geojson' method for ", class(x), call. = FALSE)
# })

#' @export
print.geojson <- function(x, ...) {
  cat("<geojson>", "\n")
  cat("  type: ", get_type(x), "\n")
  #cat("  bounding box (minlon minlat maxlon maxlat): ", bound_box(x), "\n")
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
