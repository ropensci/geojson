#' featurecollection class
#'
#' @export
#' @param x input
#' @examples
#' file <- system.file("examples", 'featurecollection1.geojson',
#'   package = "geojson")
#' file <- system.file("examples", 'featurecollection2.geojson',
#'   package = "geojson")
#' str <- paste0(readLines(file), collapse = " ")
#' (y <- featurecollection(str))
#' geo_type(y)
#' geo_pretty(y)
#' geo_write(y, f <- tempfile(fileext = ".geojson"))
#' jsonlite::fromJSON(f, FALSE)
#' unlink(f)
#'
#' # add to a data.frame
#' library('tibble')
#' data_frame(a = 1:5, b = list(y))
#'
#' # features to featurecollection
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' point(x) %>% feature() %>% featurecollection()
#'
#' ## all points
#' x <- '{ "type": "Point", "coordinates": [100.0, 0.0] }'
#' y <- '{ "type": "Point", "coordinates": [100.0, 50.0] }'
#' featls <- lapply(list(x, y), function(z) feature(point(z)))
#' featurecollection(featls)
#'
#' ## mixed geometry types
#'
featurecollection <- function(x) {
  UseMethod("featurecollection")
}

#' @export
featurecollection.default <- function(x) {
  stop("no method for ", class(x), call. = FALSE)
}

#' @export
featurecollection.character <- function(x) {
  json_val(x)
  hint_geojson(x)
  x <- as_featurecollection(x)
  verify_class_(x, "FeatureCollection")
  switch_verify_names(x)
  gtype <- get_type(x)
  no_feats <- asc(jqr::jq(unclass(x), ".features | length"))
  five_feats <- paste0(asc(jqr::jq(unclass(x), ".features[].geometry.type")),
                       collapse = ", ")
  structure(x, class = c("geofeaturecollection", "geojson"),
            type = gtype,
            no_features = no_feats,
            five_feats = five_feats)
}

#' @export
featurecollection.geofeature <- function(x) {
  featurecollection(as_featurecollection(unclass(x)[1]))
}

#' @export
featurecollection.list <- function(x) {
  invisible(lapply(x, is.feature))
  featurecollection(as_featurecollection(lapply(x, function(z) unclass(z)[1])))
}

#' @export
print.geofeaturecollection <- function(x, ...) {
  cat("<FeatureCollection>", "\n")
  cat("  type: ", attr(x, 'type'), "\n")
  cat("  no. features: ", attr(x, 'no_feats'), "\n")
  cat("  features (1st 5): ", attr(x, 'five_feats'), "\n")
}

as_featurecollection <- function(x) {
  xchar <- as.character(unclass(x))
  if (
    all(vapply(xchar, function(z) {
      asc(jqr::jq(z, ".type")) == "FeatureCollection"
    }, logical(1)))
  ) {
    return(x)
  } else {
    sprintf(
      '{ "type": "FeatureCollection", "features": [%s] }',
      if (length(x) > 1) {
        paste0(x, collapse = ", ")
      } else {
        x
      }
    )
  }
}
